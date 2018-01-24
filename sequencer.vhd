Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY sequencer IS
PORT(
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
END sequencer;

ARCHITECTURE RTL OF sequencer IS

type state_t is (S0,S1,S2,S3);
signal state : state_t; 
signal reg_nlon,reg_ledpcm : std_logic;

BEGIN

	process(reset,clk) begin
		if reset = '0' then
			state <= S0;
		elsif clk'event and clk='1' then
			case state is
				when S0 => 
					if keyi(0) = '1' then
						state <= S1;
					else
						state <= S0;
					end if;
				when S1 =>
					if keyi(0) = '1' then
						state <= S2;
					else
						state <= S1;
					end if;
				when S2 =>
					if keyi(0) = '1' then
						state <= S3;
					else
						state <= S2;
					end if;
				when S3 =>
					if keyi(0) = '1' then
						state <= S0;
					else
						state <= S3;
					end if;
				end case;
		end if;
	end process;

	process(state) begin
		case state is
			when S0 => res12 <= '1'; res2 <= '0'; res4 <= '0'; res8 <= '0'; 
			when S1 => res12 <= '0'; res2 <= '1'; res4 <= '0'; res8 <= '0';
			when S2 => res12 <= '0'; res2 <= '0'; res4 <= '1'; res8 <= '0';
			when S3 => res12 <= '0'; res2 <= '0'; res4 <= '0'; res8 <= '1';
		end case;
	end process;


	-- Non-linear
	nlon <= reg_nlon;
	led_pcm <= reg_ledpcm;
	process( clk, reset) begin
		if(reset = '0') then
			reg_nlon <= '0';
			reg_ledpcm <= '1';
		elsif( clk'event and clk='1') then 
			if keyi(1) = '1' then
				reg_nlon<= not reg_nlon; 
				reg_ledpcm <= not reg_ledpcm;
			else
				reg_nlon <= reg_nlon;
			end if;
		end if;
	end process;

end RTL;