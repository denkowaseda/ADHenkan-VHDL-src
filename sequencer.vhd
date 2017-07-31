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
	res12 : out std_logic);
END sequencer;

ARCHITECTURE RTL OF sequencer IS

type state_t is (S0,S1,S2,S3);
signal state : state_t; 


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

end RTL;