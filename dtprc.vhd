library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity dtprc is 
	port (
		test : in std_logic_vector(3 downto 0);
		nlon : in std_logic;
		ad_status : in std_logic;
		fsclk : in std_logic;
		res12 : in std_logic;
		res8 : in std_logic;
		res4 : in std_logic;
		res2 : in std_logic;
		addt : in std_logic_vector(11 downto 0);
--		conv : out std_logic;
--		da_clock : out std_logic;
		dadt : out std_logic_vector(11 downto 0);
		leddt : out std_logic_vector(7 downto 0);
		rsl_bit : out std_logic_vector(2 downto 0));
end dtprc;

architecture rtl of dtprc is

component waveforms
	port (
		clk : in std_logic;
		daout : out std_logic_vector(11 downto 0));
end component;

component NLAD is
     port( ADIN: in  std_logic_vector( 11 downto 0 );
           NLADOUT: out std_logic_vector( 7 downto 0 ));
end component;

signal selres : std_logic_vector(3 downto 0);
signal daout,led : std_logic_vector(11 downto 0);
signal NLADOUT : std_logic_vector(7 downto 0);

begin

	selres <= res12 & res2 & res4 & res8;

	process(selres,addt,daout,test) begin
		if test = "0111" then	-- 
			dadt <= addt; led <= addt;
		elsif test = "1110" then
			dadt <= "111111111111";	-- Plus fullscale
			led <= "111111111111";
		elsif test = "1101" then
			dadt <= "100000000000";	-- 0V
			led <= "100000000000";
		elsif test = "1011" then
			dadt <= "000000000000";	-- Minus fullscale
			led <= "000000000000";
		elsif test = "0110" then
			dadt <= daout;	-- Sine wave 200Hz at 10kHz sampling frequency.
			led <= daout;
		else
			case selres is
				when "1000" => led <= addt;
									dadt <= addt(11 downto 0); -- 12bit
				when "0100" => led <= addt(11) & "000000" & addt(10 downto 9) & "000";
									dadt <= addt(11 downto 9) & "000000000";	-- 2bit
				when "0010" => led <= addt(11) & "0000" & addt(10 downto 7) & "000";
									dadt <= addt(11 downto 7) & "0000000";	-- 4bit
				when "0001" => led <= addt(11 downto 3) & "000";
									dadt <= addt(11 downto 3) & "000";	-- 8bit
				when others => led <= addt; dadt <= addt;
			end case;
		end if;
	end process;

	w1 : waveforms port map(clk=>fsclk, daout=>daout);
	
	-- Non-linear
	process (nlon,led,NLADOUT) begin	
		if(nlon ='0') then
			leddt <= not led(10 downto 3);
		else
			leddt <= not NLADOUT;
		end if;
   end process;
	
	N1 : NLAD port map(ADIN=>addt ,NLADOUT=>NLADOUT);

	rsl_bit(2) <= not led(2) when test /= "1111" else not res8;
	rsl_bit(1) <= not led(1) when test /= "1111" else not res4;
	rsl_bit(0) <= not led(0) when test /= "1111" else not res2;
	
end rtl;
				
	