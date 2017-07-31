library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity dtprc is 
	port (
--		reset : in std_logic;
--		clk : in std_logic;
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
end dtprc;

architecture rtl of dtprc is

signal selres : std_logic_vector(3 downto 0);

begin

selres <= res12 & res2 & res4 & res8;

	process(selres,addt) begin
		case selres is
			when "1000" => dadt <= addt;
			when "0100" => dadt <= addt(11 downto 9) & "000000000";
			when "0010" => dadt <= addt(11 downto 7) & "0000000";
			when "0001" => dadt <= addt(11 downto 3) & "000";
			when others => dadt <= addt;
		end case;
	end process;
	
--dadt <= addt;
conv <= fsclk;
da_clock <= not fsclk;

	
end rtl;
				
	