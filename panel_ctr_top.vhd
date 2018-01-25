library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity panel_ctr_top is 
	port (
		reset : in std_logic;	-- System reset
		clk : in std_logic;	-- System clock
		swi : in std_logic_vector(1 downto 0);	-- Tactile switch input
		ph1a : in std_logic;	-- Phase A input of rotary encoder 1
		ph1b : in std_logic;	-- Phase B input of rotary encoder 1
		ph2a : in std_logic;	-- Phase A input of rotary encoder 2
		ph2b : in std_logic;	-- Phase B input of rotary endoder 2
		ad_status : in std_logic;	-- Conversion status of AD converter(not used)
		fs : out std_logic;
		bclk : out std_logic;
		csn : out std_logic;
		data : std_logic;
		sclk : out std_logic;
		ad : in std_logic_vector(11 downto 0);	-- Data from AD converter
		fclka : out std_logic;	-- Setting clock of LPF cutoff frequency(AD)
		conv : out std_logic;	-- 1-0 edge initiate a conversion AD 
		dd : out std_logic_vector(11 downto 0);	-- Data to DA converter
		fclkd : out std_logic;	-- Setting clock of LPF cutoff frequency(DA)
		da_clock : out std_logic;	-- Data latch clock of DA converter
		sel : out std_logic_vector(5 downto 0);	--Digit select signal of 7 Seg. LEDs
		seg_a : out std_logic;	-- Segment a
		seg_b : out std_logic;	-- Segment b
		seg_c : out std_logic;	-- Segment c
		seg_d : out std_logic;	-- Segment d
		seg_e : out std_logic;	-- Segment e
		seg_f : out std_logic;	-- Segment f
		seg_g : out std_logic;	-- Segment g
		seg_dt : out std_logic;	-- Dot
		dx : in std_logic;
		led_pcm : out std_logic;	-- Linear or Not Linear. 0 is Not Linear
		led : out std_logic_vector(7 downto 0);	-- 8 bit data LEDs
		rsl_bit : out std_logic_vector(2 downto 0);	-- Resolusion LEDs
		test : in std_logic_vector(3 downto 0));	-- For test mode
end panel_ctr_top;

architecture rtl of panel_ctr_top is

component fsfcgen
	port (
		reset : in std_logic;
		clk : in std_logic;
		fscntq : in std_logic_vector(6 downto 0);
		fccntq : in std_logic_vector(3 downto 0);
		fsclk : out std_logic;
		fcclk : out std_logic);
end component;

component fsfccnt
port(
		CLK : IN std_logic;
		RESET : IN std_logic;
		PHA_FS : IN std_logic;
		PHB_FS : IN std_logic;
		PHA_FC : IN std_logic;
		PHB_FC : IN std_logic;
		ATTUP : OUT std_logic;
		ATTDWN : OUT std_logic;
		FSCNTQ : OUT std_logic_vector(6 downto 0);
		FCCNTQ : OUT std_logic_vector(3 downto 0));
end component;

component dispctr
	PORT(
		RESET : IN std_logic;
		CLK : IN std_logic;
		SCCLK : IN std_logic;
		ATTDWN : IN std_logic;
		ATTUP : IN std_logic;
		FSDATA : IN std_logic_vector(8 downto 0);
		FCDATA : IN std_logic_vector(8 downto 0);
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
		leddt : out std_logic_vector(7 downto 0);
		rsl_bit : out std_logic_vector(2 downto 0));
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
		res12 : out std_logic;
		nlon : out std_logic;
		led_pcm : out std_logic);
end component;

component conv_disp_data
	port(
		fscntq : in std_logic_vector(6 downto 0);
		fccntq : in std_logic_vector(3 downto 0);
		fsdata : out std_logic_vector(8 downto 0);
		fcdata : out std_logic_vector(8 downto 0));
end component;


signal fsclk,fcclk,scclk,scale : std_logic;
signal res12,res8,res4,res2 : std_logic;
--signal pha_fs,phb_fs,pha_fc,phb_fc : std_logic;
signal attup,attdwn : std_logic;
signal swo : std_logic_vector(1 downto 0);
signal segled,leddt : std_logic_vector(7 downto 0);
signal fscntq : std_logic_vector(6 downto 0);
signal fccntq : std_logic_vector(3 downto 0);
signal fsdata,fcdata : std_logic_vector(8 downto 0);
signal dadt : std_logic_vector(11 downto 0);

----non-linear_2---
signal nlon : std_logic; --non-linear=1 or linear=0;
----end of non-linear_2----


begin

	U1 : fsfcgen port map(reset=>reset,clk=>clk,fscntq=>fscntq,fccntq=>fccntq,
			fsclk=>fsclk,fcclk=>fcclk);
	
	U2 : fsfccnt port map(CLK=>clk,RESET=>reset,PHA_FS=>ph1a,PHB_FS=>ph1b,PHA_FC=>ph2a,
			PHB_FC=>ph2b,ATTUP=>attup,ATTDWN=>attdwn,FSCNTQ=>fscntq,FCCNTQ=>fccntq);
	
	U3 : dispctr port map(RESET=>reset,CLK=>clk,SCCLK=>scclk,ATTDWN=>attdwn,ATTUP=>attup,
			FSDATA=>fsdata,FCDATA=>fcdata,COMSEL=>sel,LED=>segled);
			
	U4 : clkgen port map(reset=>reset,clk=>clk,scale=>scale,scclk=>scclk);
	
	U5 : dtprc port map(test=>test,nlon=>nlon,ad_status =>ad_status,fsclk=>fsclk,res12=>res12,
			res8=>res8,res4=>res4,res2=>res2,addt=>ad,conv=>conv,da_clock=>da_clock,dadt=>dd,
			leddt=>led,rsl_bit=>rsl_bit);
			
	U6 : chat port map(reset=>reset,clk=>clk,scale=>scale,swi=>swi,swo=>swo);
	
	U7 : sequencer port map(reset=>reset,clk=>clk,keyi=>swo,scale=>scale,res2=>res2,res4=>res4,
			res8=>res8,res12=>res12,nlon=>nlon,led_pcm=>led_pcm);
	
	U8 : conv_disp_data port map(fscntq=>fscntq,fccntq=>fccntq,fsdata=>fsdata,fcdata=>fcdata);

	
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
	

end rtl;
				
	