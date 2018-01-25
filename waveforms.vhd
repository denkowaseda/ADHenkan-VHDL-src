library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity waveforms is 
	port (
		clk : in std_logic;
		daout : out std_logic_vector(11 downto 0));
end waveforms;

architecture rtl of waveforms is

signal romaddr : std_logic_vector(5 downto 0) := "000000";
signal romdata : std_logic_vector(11 downto 0);

subtype wave is std_logic_vector(11 downto 0);
type rom is array(0 to 49) of wave;
	constant sin : rom :=(
		X"7FF",
		X"900",
		X"9FC",
		X"AF1",
		X"BD9",
		X"CB2",
		X"D78",
		X"E28",
		X"EBF",
		X"F3B",
		X"F9A",
		X"FDA",
		X"FFA",
		X"FFA",
		X"FDA",
		X"F9A",
		X"F3B",
		X"EBF",
		X"E28",
		X"D78",
		X"CB2",
		X"BD9",
		X"AF1",
		X"9FC",
		X"900",
		X"7FF",
		X"6FE",
		X"602",
		X"50D",
		X"425",
		X"34C",
		X"286",
		X"1D6",
		X"13F",
		X"0C3",
		X"064",
		X"024",
		X"004",
		X"004",
		X"024",
		X"064",
		X"0C3",
		X"13F",
		X"1D6",
		X"286",
		X"34C",
		X"425",
		X"50D",
		X"602",
		X"6FE");

begin

	process(clk) begin
		if clk'event and clk='0' then
			if romaddr = "110001" then
				romaddr <= "000000";
			else
				romaddr <= romaddr + 1;
			end if;
		end if;
	end process;

	process(clk) begin
		if clk'event and clk='1' then
			romdata <= sin(conv_integer(romaddr));
		end if;
		daout <= romdata;
	end process;
	
end rtl;
				
	