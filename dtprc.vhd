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
		conv : out std_logic;
		da_clock : out std_logic;
		dadt : out std_logic_vector(11 downto 0);
		leddt : out std_logic_vector(11 downto 0));
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
		if test(3) = '0' then	-- Sin wave 200Hz at 10kHz sampling frequency.
			dadt <= daout; led <= daout;
		elsif test(2 downto 0) = "110" then	-- +10V
			dadt <= "111111111111";
		elsif test(2 downto 0) = "101" then	-- 0V
			dadt <= "011111111111";
		elsif test(2 downto 0) = "011" then	-- -10V
			dadt <= "000000000000";
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
	
	conv <= fsclk;
	da_clock <= not fsclk;

	w1 : waveforms port map(clk=>fsclk, daout=>daout);
	
	-- Non-linear
	process (nlon,led(10 downto 3),NLADOUT) begin	
		if(nlon ='0') then
			leddt <= not led;
		else
		 leddt(10) <= not NLADOUT(7);
		 leddt(9) <= not NLADOUT(6);
		 leddt(8) <= not NLADOUT(5);
		 leddt(7) <= not NLADOUT(4);
		 leddt(6) <= not NLADOUT(3);
		 leddt(5) <= not NLADOUT(2);
		 leddt(4) <= not NLADOUT(1);
		 leddt(3) <= not NLADOUT(0);
		end if;
   end process;
	
	N1 : NLAD port map(ADIN=>addt ,NLADOUT=>NLADOUT);
	
end rtl;
				
	