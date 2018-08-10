library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity clkgen is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : out std_logic;
		scclk : out std_logic;
		divclk : out std_logic);
end clkgen;

architecture rtl of clkgen is

constant sim : integer := 0;

signal scclki,scalei,divclki : std_logic;
signal cnt_ms : std_logic_vector(15 downto 0);

begin

-- Systme clock is 40MHz
-- Generate 1ms event signal
SIMULATION : if(sim = 1) generate
	process(clk,reset) begin
		if reset = '0' then
			cnt_ms <= "0000000000000000";
		elsif clk'event and clk = '1' then
			if cnt_ms = "0000000000001001" then
				cnt_ms <= "0000000000000000";
			else
				cnt_ms <= cnt_ms + 1;
			end if;
		end if;
	end process;

	scalei <= '1' when cnt_ms = "0000000000001001" else '0';

	end generate;


COMPILE : if(sim /= 1) generate
	process(clk,reset) begin
		if reset = '0' then
			cnt_ms <= "0000000000000000";
		elsif clk'event and clk = '1' then
			if cnt_ms = "1001110001000000" then		-- 25ns*40000 times count
				cnt_ms <= "0000000000000000";
			else
				cnt_ms <= cnt_ms + 1;
			end if;
		end if;
	end process;

	scalei <= '1' when cnt_ms = "1001110001000000" else '0';

end generate;

	
	process(clk,reset) begin
		if reset = '0' then
			scclki <= '0';
		elsif clk'event and clk='1' then
			if scalei = '1' then
				scclki <= not scclki;
			end if;			
		end if;
	end process;
	
	process(clk,reset) begin
		if clk'event and clk='1' then
			divclki <= not divclki;
		end if;
	end process;
	
	scclk <= scclki;
	scale <= scalei;
	divclk <= divclki;
	
end rtl;
				
	