Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY panel_ctr_top_test IS
END panel_ctr_top_test;

ARCHITECTURE panel_ctr_top_test_bench OF panel_ctr_top_test IS

COMPONENT panel_ctr_top
	port (
		reset : in std_logic;
		clk : in std_logic;
		swi : in std_logic_vector(1 downto 0);
		ph1a : in std_logic;
		ph1b : in std_logic;
		ph2a : in std_logic;
		ph2b : in std_logic;
		ad_status : in std_logic;
		fs : out std_logic;
		bclk : out std_logic;
		csn : out std_logic;
		data : std_logic;
		sclk : out std_logic;
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
		dx : in std_logic;
		led : out std_logic_vector(7 downto 0);
		rsl_bit : out std_logic_vector(2 downto 0);
		test : in std_logic_vector(3 downto 0));
END COMPONENT;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;

constant stb	: Time := 2ns;

signal reset,clk,ph1a,ph1b,ph2a,ph2b,ad_status,fclka,fclkd:std_logic;
signal conv,da_clock,seg_a,seg_b,seg_c,seg_d,seg_e,seg_f : std_logic;
signal seg_g,seg_dt : std_logic;
signal swi : std_logic_vector(1 downto 0);
signal rsl_bit : std_logic_vector(2 downto 0);
signal test : std_logic_vector(3 downto 0);
signal sel : std_logic_vector(5 downto 0);
signal led : std_logic_vector(7 downto 0);
signal ad,dd : std_logic_vector(11 downto 0);
signal fs,bclk,csn,data,sclk,dx : std_logic;

BEGIN

	U1: panel_ctr_top port map (reset=>reset,clk=>clk,swi=>swi,ph1a=>ph1a,ph1b=>ph1b,ph2a=>ph2a,
			ph2b=>ph2b,ad_status=>ad_status,
			fs=>fs,bclk=>bclk,csn=>csn,data=>data,sclk=>sclk,
			ad=>ad,fclka=>fclka,conv=>conv,dd=>dd,fclkd=>fclkd,
			da_clock=>da_clock,sel=>sel,seg_a=>seg_a,seg_b=>seg_b,seg_c=>seg_c,seg_d=>seg_d,
			seg_e=>seg_e,seg_f=>seg_f,seg_g=>seg_g,seg_dt=>seg_dt,
			dx=>dx,
			led=>led,rsl_bit=>rsl_bit,
			test=>test);
	
	--====================
	-- 40MHz system clock
	--====================
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
	
	--=======================================================
	-- Output of rotary encoder 1(Sampling frequency setting)
	--=======================================================
	-- Phase B
	process begin
		ph1b <= '1';
		wait for cycle*400;
		
		-- Count up
		for i in 0 to 113 loop
			ph1b <= '0';
			wait for cycle*50;
			ph1b <= '1';
			wait for cycle*50;
		end loop;
		
		wait for cycle*1000;
		
		-- Count down
		for i in 0 to 150 loop
			wait for cycle*25;
			ph1b <= '0';
			wait for cycle*50;
			ph1b <= '1';
			wait for cycle*25;
		end loop;
		
		wait for cycle*400;
		
		-- Count up
		for i in 0 to 98 loop
			ph1b <= '0';
			wait for cycle*50;
			ph1b <= '1';
			wait for cycle*50;
		end loop;
		
		wait;
	end process;
	
	-- Phase A
	process begin
		ph1a <= '1';
		wait for cycle*400;
		
		-- Count up
		for j in 0 to 113 loop
			wait for cycle*25;
			ph1a <= '0';
			wait for cycle*50;
			ph1a <= '1';
			wait for cycle*25;
		end loop;
		
		wait for cycle*1000;
		
		-- Count down
		for j in 0 to 150 loop
			ph1a <= '0';
			wait for cycle*50;
			ph1a <= '1';
			wait for cycle*50;
		end loop;
		
		wait for cycle*400;
		
		-- Count up
		for j in 0 to 98 loop
			wait for cycle*25;
			ph1a <= '0';
			wait for cycle*50;
			ph1a <= '1';
			wait for cycle*25;
		end loop;
		
		wait;
	end process;
	
	--=========================================================
	-- Output of rotary encoder 2(LPF cutoff frequency setting)
	--=========================================================
	-- Phase B
	process begin
		ph2b <= '1';
		wait for cycle*400;
		
		-- Count up
		for k in 0 to 12 loop
			ph2b <= '0';
			wait for cycle*50;
			ph2b <= '1';
			wait for cycle*50;
		end loop;
		
		wait for cycle*400;
		
		-- Count down
		for k in 0 to 12 loop
			wait for cycle*25;
			ph2b <= '0';
			wait for cycle*50;
			ph2b <= '1';
			wait for cycle*25;
		end loop;
		wait;
	end process;
	
	-- Phase A
	process begin
		ph2a <= '1';
		wait for cycle*400;
		
		-- Count up
		for l in 0 to 12 loop
			wait for cycle*25;
			ph2a <= '0';
			wait for cycle*50;
			ph2a <= '1';
			wait for cycle*25;
		end loop;
		
		wait for cycle*400;
		
		-- Count down
		for l in 0 to 12 loop
			ph2a <= '0';
			wait for cycle*50;
			ph2a <= '1';
			wait for cycle*50;
		end loop;
		wait;
	end process;
	
	PROCESS BEGIN
		reset <= '0';
		swi <= "11";
		ad <= X"FFF";
		test <= "1111";
		
		wait for cycle*10;
		reset <= '1';
		
		wait for cycle*10;
		swi <= "01";
		
		wait for cycle*350;
		swi <= "11";
		
		wait for cycle*100;
		swi <= "00";
		
		wait for cycle*350;
		swi <= "11";
		
		wait for cycle*25600;
		test <= "0111";
		
		wait;
	end PROCESS;
end panel_ctr_top_test_bench;

CONFIGURATION cfg_test of panel_ctr_top_test IS
	for panel_ctr_top_test_bench
	end for;
end cfg_test;