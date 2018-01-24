library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity chat is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : in std_logic;
		swi : in std_logic_vector(1 downto 0);
		swo : out std_logic_vector(1 downto 0));
end chat;

architecture rtl of chat is

constant sim : integer := 1;

signal swo1_int : std_logic_vector(1 downto 0);
signal swo0_int : std_logic_vector(1 downto 0);

signal clk_count : std_logic_vector(4 downto 0);
signal sw_prev,sw_curr,sw_out_reg : std_logic_vector(1 downto 0);
signal sw_mask : std_logic;

begin

-- Chattering canceller	
SIMULATION : if (sim = 1) generate
	process(clk,reset)
	begin
		if(reset = '0') then
			clk_count <= (others => '0');
			sw_prev <= (others => '0');
			sw_curr <= (others => '0');
			sw_out_reg <= (others => '1');
			sw_mask <= '0';
		elsif(clk'event and clk = '1') then
			if scale = '1' then
				if(sw_mask = '0') then
					if(sw_prev /= sw_curr) then
						sw_mask <= '1';
						clk_count <= (others => '0');
					end if;
				else
					if(clk_count = "111") then
						sw_mask <= '0';
						sw_out_reg <= sw_curr;
					else
						clk_count <= clk_count + 1;
					end if;
				end if;
				sw_prev <= sw_curr;
				sw_curr <= swi;
			end if;
		end if;
	end process;
end generate;

COMPILE : if (sim /= 1) generate
	process(clk,reset)
	begin
		if(reset = '0') then
			clk_count <= (others => '0');
			sw_prev <= (others => '0');
			sw_curr <= (others => '0');
			sw_out_reg <= (others => '1');
			sw_mask <= '0';
		elsif(clk'event and clk = '1') then
			if scale = '1' then
				if(sw_mask = '0') then
					if(sw_prev /= sw_curr) then
						sw_mask <= '1';
						clk_count <= (others => '0');
					end if;
				else
					if(clk_count = "11111") then
						sw_mask <= '0';
						sw_out_reg <= sw_curr;
					else
						clk_count <= clk_count + 1;
					end if;
				end if;
				sw_prev <= sw_curr;
				sw_curr <= swi;
			end if;
		end if;
	end process;
end generate;

-- Shift regester
	process(clk,reset) begin
		if clk'event and clk = '1' then
			swo1_int <= swo1_int(0) & sw_out_reg(1);
			swo0_int <= swo0_int(0) & sw_out_reg(0);
		end if;
	end process;
	
--	 Falling edge detection
	swo(1) <= swo1_int(1) and not swo1_int(0);
	swo(0) <= swo0_int(1) and not swo0_int(0);

	
end rtl;
				
	