Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY panel_ctr_top_test IS
END panel_ctr_top_test;

ARCHITECTURE panel_ctr_top_test_bench OF panel_ctr_top_test IS

COMPONENT panel_ctr_top
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
END COMPONENT;
	
constant cycle	: Time := 100ns;
constant	half_cycle : Time := 50ns;

constant stb	: Time := 2ns;

signal reset_N,reset,clk,ph1a,ph1b,ph2a,ph2b,ad_status,fclka,fclkd:std_logic;
signal conv,da_clock,seg_a,seg_b,seg_c,seg_d,seg_e,seg_f : std_logic;
signal seg_g,seg_dt : std_logic;
signal swi : std_logic_vector(1 downto 0);
signal rsl_bit : std_logic_vector(2 downto 0);
signal sel : std_logic_vector(5 downto 0);
signal led,test : std_logic_vector(7 downto 0);
signal ad,dd : std_logic_vector(11 downto 0);

BEGIN

	U1: panel_ctr_top port map (reset_N=>reset,clk=>clk,swi=>swi,ph1a=>ph1a,ph1b=>ph1b,ph2a=>ph2a,
			ph2b=>ph2b,ad_status=>ad_status,ad=>ad,fclka=>fclka,conv=>conv,dd=>dd,fclkd=>fclkd,
			da_clock=>da_clock,sel=>sel,seg_a=>seg_a,seg_b=>seg_b,seg_c=>seg_c,seg_d=>seg_d,
			seg_e=>seg_e,seg_f=>seg_f,seg_g=>seg_g,seg_dt=>seg_dt,led=>led,rsl_bit=>rsl_bit,
			test=>test);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
	
	process begin
		ph1a <= '0';
		wait for cycle*50;
		ph1a <= '1';
		wait for cycle*50;
	end process;
	
	process begin
		ph1b <= '1';
		wait for cycle*25;
		ph1b <= '0';
		wait for cycle*50;
		ph1b <= '1';
		wait for cycle*25;
	end process;
	

	PROCESS BEGIN
		reset <= '0';
		swi <= "11";
		ad_status <= '1';
		ad <= "000000000000";
		
		wait for cycle*10;
		wait for stb;
		reset <= '1';
		
		wait for cycle*10;
		swi <= "00";
		
		wait for cycle*350;
		swi <= "11";
		
		wait for cycle*100;
		swi <= "00";
		
		wait for cycle*350;
		swi <= "11";
		

		wait;
	end PROCESS;
end panel_ctr_top_test_bench;

CONFIGURATION cfg_test of panel_ctr_top_test IS
	for panel_ctr_top_test_bench
	end for;
end cfg_test;