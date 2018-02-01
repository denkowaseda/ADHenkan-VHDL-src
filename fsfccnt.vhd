--
--
--
--
--
--
Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity fsfccnt is
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
end fsfccnt;

architecture RTL of fsfccnt is

component rotenc_cnt
generic(LENGTH : integer);
	port(
		CLK : IN std_logic;
		RESET_N : IN std_logic;
		A : IN std_logic;
		B : IN std_logic;
		INIT_VAL : IN std_logic_vector(LENGTH-1 downto 0);
		MAXCNT : IN std_logic_vector(LENGTH-1 downto 0);
		MINCNT : IN std_logic_vector(LENGTH-1 downto 0);
		CNTUP : OUT std_logic;
		CNTDWN : OUT std_logic;
		Q : OUT std_logic_vector(LENGTH-1 downto 0));
end component;

constant init_val_fs : std_logic_vector(6 downto 0) := "0001010";	-- 1kHz sampling freq.
constant init_val_fc : std_logic_vector(3 downto 0) := "0000";	-- 3.4kHz cutoff freq.
constant maxcnt_fs : std_logic_vector(6 downto 0) := "1110010";
constant maxcnt_fc : std_logic_vector(3 downto 0) := "1101";
constant mincnt_fs : std_logic_vector(6 downto 0) := "0000001";
constant mincnt_fc : std_logic_vector(3 downto 0) := "0000";

signal CNTUP_FS,CNTDWN_FS,CNTUP_FC,CNTDWN_FC : std_logic;

begin
	R1 : rotenc_cnt generic map(LENGTH => 7) port map(CLK=>clk,RESET_N=>reset,A=>PHA_FS,B=>PHB_FS,INIT_VAL=>init_val_fs,
		MAXCNT=>maxcnt_fs,MINCNT=>mincnt_fs,CNTUP=>CNTUP_FS,CNTDWN=>CNTDWN_FS,Q=>FSCNTQ);
						
	R2 : rotenc_cnt generic map(LENGTH => 4) port map(CLK=>clk,RESET_N=>reset,A=>PHA_FC,B=>PHB_FC,INIT_VAL=>init_val_fc,
		MAXCNT=>maxcnt_fc,MINCNT=>mincnt_fc,CNTUP=>CNTUP_FC,CNTDWN=>CNTDWN_FC,Q=>FCCNTQ);
					
	ATTUP <= CNTUP_FS or CNTUP_FC;
	ATTDWN <= CNTDWN_FS or CNTDWN_FC;
	
end rtl;