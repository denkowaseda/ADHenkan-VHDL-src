library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity panel_ctr_top is 
	port (
		reset_N : in std_logic;
		clk : in std_logic;
		swi : in std_logic_vector(1 downto 0);
		ph1a : in std_logic;
		ph1b : in std_logic;
		ph2a : in std_logic;
		ph2b : in std_logic;
		ad_status : in std_logic;
		ad : in std_logic_vector(11 downto 0);
		fclka : out std_logic;
		conv : out std_logic;
		dd : out std_logic_vector(11 downto 0);
		fclkd : out std_logic;
		da_clock : out std_logic;
		sel : out std_logic_vector(5 downto 0);
		seg_a : out std_logic;
		seg_b : out std_logic;
		seg_c : out std_logic;
		seg_d : out std_logic;
		seg_e : out std_logic;
		seg_f : out std_logic;
		seg_g : out std_logic;
		seg_dt : out std_logic;
		led : out std_logic_vector(7 downto 0);
		rsl_bit : out std_logic_vector(2 downto 0);
		test : in std_logic_vector(7 downto 0));
end panel_ctr_top;

architecture rtl of panel_ctr_top is

component fsfcgen
	port (
		reset : in std_logic;
		clk : in std_logic;
		fscntq : in std_logic_vector(7 downto 0);
		fsclk : out std_logic;
		fcclk : out std_logic);
end component;

component fscnt
	port(
		CLK : IN std_logic;
		RESET_N : IN std_logic;
		A : IN std_logic;
		B : IN std_logic;
		CNTUP : OUT std_logic;
		CNTDWN : OUT std_logic;
		Q : OUT std_logic_vector(7 downto 0));
end component;

component dispctr
	PORT(
		RESET : IN std_logic;
		CLK : IN std_logic;
		SCCLK : IN std_logic;
		ATTDWN : IN std_logic;
		ATTUP : IN std_logic;
		FSDATA : IN std_logic_vector(7 downto 0);
		FCDATA : IN std_logic_vector(7 downto 0);
		COMSEL : OUT std_logic_vector(5 downto 0);
		LED : OUT std_logic_vector(7 downto 0));
end component;

component clkgen
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : out std_logic;
		scclk : out std_logic);
end component;

component dtprc
	port (
		ad_status : in std_logic;
		fsclk : in std_logic;
		res12 : in std_logic;
		res8 : in std_logic;
		res4 : in std_logic;
		res2 : in std_logic;
		addt : in std_logic_vector(11 downto 0);
		conv : out std_logic;
		da_clock : out std_logic;
		dadt : out std_logic_vector(11 downto 0));
end component;

component chat
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : in std_logic;
		swi : in std_logic_vector(1 downto 0);
		swo : out std_logic_vector(1 downto 0));
end component;

component sequencer
	port (
		reset : in std_logic;
		clk : in std_logic;
		keyi : in std_logic_vector(1 downto 0);
		scale : in std_logic;
		res2 : out std_logic;
		res4 : out std_logic;
		res8 : out std_logic;
		res12 : out std_logic);
end component;


signal sec : std_logic;
signal cnt_25 : integer:=33554431;
--signal cnt_25 : integer:=31;
signal fsclk,fcclk,cntup,cntdwn,scclk,scale,reset : std_logic;
signal res12,res8,res4,res2 : std_logic;
signal keyi,swo : std_logic_vector(1 downto 0);
signal comsel : std_logic_vector(5 downto 0);
signal q,fscntq,fcdata,fsdata,segled : std_logic_vector(7 downto 0);
signal dadt : std_logic_vector(11 downto 0);

begin

	U1 : fsfcgen port map(reset=>reset,clk=>clk,fscntq=>fscntq,fsclk=>fsclk,fcclk=>fcclk);
	
	U2 : fscnt port map(CLK=>clk,RESET_N=>reset,A=>ph1a,B=>ph1b,CNTUP=>cntup,CNTDWN=>cntdwn,Q=>q);
	
	U3 : dispctr port map(RESET=>reset,CLK=>clk,SCCLK=>scclk,ATTDWN=>cntdwn,ATTUP=>cntup,
			FSDATA=>fsdata,FCDATA=>fcdata,COMSEL=>comsel,LED=>segled);
			
	U4 : clkgen port map(reset=>reset,clk=>clk,scale=>scale,scclk=>scclk);
	
	U5 : dtprc port map(ad_status =>ad_status,fsclk=>fsclk,res12=>res12,res8=>res8,res4=>res4,
			res2=>res2,addt=>ad,conv=>conv,da_clock=>da_clock,dadt=>dadt);
			
	U6 : chat port map(reset=>reset,clk=>clk,scale=>scale,swi=>swi,swo=>swo);
	
	U7 : sequencer port map(reset=>reset,clk=>clk,keyi=>swo,scale=>scale,res2=>res2,res4=>res4,
			res8=>res8,res12=>res12);
	
	
	fscntq <= q;
	fsdata <= fscntq;
	fcdata <= "00100010";
	sel <= comsel;
	reset <= reset_N;
	fclka <= fcclk;
	fclkd <= fcclk;
	
	seg_dt <= segled(0);
	seg_g <= segled(1);
	seg_f <= segled(2);
	seg_e <= segled(3);
	seg_d <= segled(4);
	seg_c <= segled(5);
	seg_b <= segled(6);
	seg_a <= segled(7);
	
	led(7) <= not dadt(10);
	led(6) <= not dadt(9);
	led(5) <= not dadt(8);
	led(4) <= not dadt(7);
	led(3) <= not dadt(6);
	led(2) <= not dadt(5);
	led(1) <= not dadt(4);
	led(0) <= not dadt(3);
	rsl_bit(2) <= not dadt(2) when test(2 downto 0) /= "111" else not res8;
	rsl_bit(1) <= not dadt(1) when test(2 downto 0) /= "111" else not res4;
	rsl_bit(0) <= not dadt(0) when test(2 downto 0) /= "111" else not res2;

--	dd <= dadt;
	
	process (test(2 downto 0)) begin
		case test(2 downto 0) is
			when "110" => dd <= "111111111111";
			when "101" => dd <= "011111111111";
			when "011" => dd <= "000000000000";
			when others => dd <= dadt;
		end case;
	end process;
	
--	process(CLK,reset)
--	begin
--		if(reset = '0') then
--			cnt_25 <= 0;
--			sec <= '0';
--		elsif(CLK'event and CLK = '1') then
--			if(cnt_25 = 25000000) then
--			--if(cnt_25 = 25) then
--				sec <= not sec;
--				cnt_25 <= 0;
--			else
--				cnt_25 <= cnt_25 + 1;
--			end if;
--		end if;
--	end process;
	
--	process (sec) begin
--		if sec = '0' then
----			led <= "10101010";
--			rsl_bit <= "101";
--		else
----			led <= "01010101";
--			rsl_bit <= "010";
--		end if;
--	end process;
end rtl;
				
	