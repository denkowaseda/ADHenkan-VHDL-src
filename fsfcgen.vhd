library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity fsfcgen is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		fscntq : in std_logic_vector(7 downto 0);
		fsclk : out std_logic;
		fcclk : out std_logic);
end fsfcgen;

architecture rtl of fsfcgen is

signal fsclki,fcclki : std_logic;
signal fsreg,setval : std_logic_vector(19 downto 0);
signal fcreg : std_logic_vector(10 downto 0);

begin

	process(fscntq) begin
		case fscntq is
			when "00000001" => setval <= X"30D40";	--100Hz
			when "00000010" => setval <= X"186A0";	--200Hz
			when "00000011" => setval <= X"1046A";	--300Hz
			when "00000100" => setval <= X"0C350";	--400Hz
			when "00000101" => setval <= X"09C40";	--500Hz
			when "00000110" => setval <= X"08235";	--600Hz
			when "00000111" => setval <= X"06F9B";	--700Hz
			when "00001000" => setval <= X"061A8";	--800Hz
			when "00001001" => setval <= X"056CE";	--900Hz
			when "00001010" => setval <= X"04E20";	--1000Hz
			when "00001011" => setval <= X"04705";	--1100Hz
			when "00001100" => setval <= X"0411A";	--1200Hz
			when "00001101" => setval <= X"03C18";	--1300Hz
			when "00001110" => setval <= X"037CD";	--1400Hz
			when "00001111" => setval <= X"03415";	--1500Hz
			when "00010000" => setval <= X"030D4";	--1600Hz
			when "00010001" => setval <= X"02DF4";	--1700Hz
			when "00010010" => setval <= X"02B67";	--1800Hz
			when "00010011" => setval <= X"0291E";	--1900Hz
			when "00010100" => setval <= X"02710";	--2000Hz
			when "00010101" => setval <= X"02533";	--2100Hz
			when "00010110" => setval <= X"02382";	--2200Hz
			when "00010111" => setval <= X"021F7";	--2300Hz
			when "00011000" => setval <= X"0208D";	--2400Hz
			when "00011001" => setval <= X"01F40";	--2500Hz
			when "00011010" => setval <= X"01E0C";	--2600Hz
			when "00011011" => setval <= X"01CEF";	--2700Hz
			when "00011100" => setval <= X"01BE6";	--2800Hz
			when "00011101" => setval <= X"01AF0";	--2900Hz
			when "00011110" => setval <= X"01A0A";	--3000Hz
			when "00011111" => setval <= X"01933";	--3100Hz
			when "00100000" => setval <= X"0186A";	--3200Hz
			when "00100001" => setval <= X"017AC";	--3300Hz
			when "00100010" => setval <= X"016FA";	--3400Hz
			when "00100011" => setval <= X"01652";	--3500Hz
			when "00100100" => setval <= X"015B3";	--3600Hz
			when "00100101" => setval <= X"0151D";	--3700Hz
			when "00100110" => setval <= X"0148F";	--3800Hz
			when "00100111" => setval <= X"01408";	--3900Hz
			when "00101000" => setval <= X"01388";	--4000Hz
			when "00101001" => setval <= X"0130E";	--4100Hz
			when "00101010" => setval <= X"01299";	--4200Hz
			when "00101011" => setval <= X"0122B";	--4300Hz
			when "00101100" => setval <= X"011C1";	--4400Hz
			when "00101101" => setval <= X"0115C";	--4500Hz
			when "00101110" => setval <= X"010FB";	--4600Hz
			when "00101111" => setval <= X"0109F";	--4700Hz
			when "00110000" => setval <= X"01046";	--4800Hz
			when "00110001" => setval <= X"00FF1";	--4900Hz
			when "00110010" => setval <= X"00FA0";	--5000Hz
			when "00110011" => setval <= X"00F51";	--5100Hz
			when "00110100" => setval <= X"00F06";	--5200Hz
			when "00110101" => setval <= X"00EBD";	--5300Hz
			when "00110110" => setval <= X"00E77";	--5400Hz
			when "00110111" => setval <= X"00E34";	--5500Hz
			when "00111000" => setval <= X"00DF3";	--5600Hz
			when "00111001" => setval <= X"00DB4";	--5700Hz
			when "00111010" => setval <= X"00D78";	--5800Hz
			when "00111011" => setval <= X"00D3D";	--5900Hz
			when "00111100" => setval <= X"00D05";	--6000Hz
			when "00111101" => setval <= X"00CCE";	--6100Hz
			when "00111110" => setval <= X"00C99";	--6200Hz
			when "00111111" => setval <= X"00C66";	--6300Hz
			when "01000000" => setval <= X"00C35";	--6400Hz
			when "01000001" => setval <= X"00C04";	--6500Hz
			when "01000010" => setval <= X"00BD6";	--6600Hz
			when "01000011" => setval <= X"00BA9";	--6700Hz
			when "01000100" => setval <= X"00B7D";	--6800Hz
			when "01000101" => setval <= X"00B52";	--6900Hz
			when "01000110" => setval <= X"00B29";	--7000Hz
			when "01000111" => setval <= X"00B00";	--7100Hz
			when "01001000" => setval <= X"00AD9";	--7200Hz
			when "01001001" => setval <= X"00AB3";	--7300Hz
			when "01001010" => setval <= X"00A8E";	--7400Hz
			when "01001011" => setval <= X"00A6A";	--7500Hz
			when "01001100" => setval <= X"00A47";	--7600Hz
			when "01001101" => setval <= X"00A25";	--7700Hz
			when "01001110" => setval <= X"00A04";	--7800Hz
			when "01001111" => setval <= X"009E3";	--7900Hz
			when "01010000" => setval <= X"009C4";	--8000Hz
			when "01010001" => setval <= X"009A5";	--8100Hz
			when "01010010" => setval <= X"00987";	--8200Hz
			when "01010011" => setval <= X"00969";	--8300Hz
			when "01010100" => setval <= X"0094C";	--8400Hz
			when "01010101" => setval <= X"00930";	--8500Hz
			when "01010110" => setval <= X"00915";	--8600Hz
			when "01010111" => setval <= X"008FA";	--8700Hz
			when "01011000" => setval <= X"008E0";	--8800Hz
			when "01011001" => setval <= X"008C7";	--8900Hz
			when "01011010" => setval <= X"008AE";	--9000Hz
			when "01011011" => setval <= X"00895";	--9100Hz
			when "01011100" => setval <= X"0087D";	--9200Hz
			when "01011101" => setval <= X"00866";	--9300Hz
			when "01011110" => setval <= X"0084F";	--9400Hz
			when "01011111" => setval <= X"00839";	--9500Hz
			when "01100000" => setval <= X"00823";	--9600Hz
			when "01100001" => setval <= X"0080D";	--9700Hz
			when "01100010" => setval <= X"007F8";	--9800Hz
			when "01100011" => setval <= X"007E4";	--9900Hz
			when "01100100" => setval <= X"007D0";	--10kHz
			when "01100101" => setval <= X"0071A";	--11kHz
			when "01100110" => setval <= X"00682";	--12kHz
			when "01100111" => setval <= X"00602";	--13kHz
			when "01101000" => setval <= X"00594";	--14kHz
			when "01101001" => setval <= X"00535";	--15kHz
			when "01101010" => setval <= X"004E2";	--16kHz
			when "01101011" => setval <= X"00498";	--17kHz
			when "01101100" => setval <= X"00457";	--18kHz
			when "01101101" => setval <= X"0041C";	--19kHz
			when "01101110" => setval <= X"003E8";	--20kHz
--			when "" => setval <= X"";	--
			when others => setval <= "XXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;
	
-- System clock is 40MHz
-- Generate FS clock signal
	process(clk,reset) begin
		if reset = '0' then
			fsclki <= '0';
		elsif clk'event and clk = '1' then
			if fsreg = setval then		-- 25ns*200000 times count
--			if fsreg = "0000000000001001" then		-- for simulation
				 fsreg <= "00000000000000000000";
				 fsclki <= not fsclki;
			else
				fsreg <= fsreg + 1;
			end if;
		end if;
	end process;
	
	process(clk,reset) begin
		if reset = '0' then
			fcreg <= "00000000000";
			fcclki <= '0';
		elsif clk'event and clk = '1' then
			if fcreg = "00000111010" then
				fcreg <= "00000000000";
				fcclki <= not fcclki;
			else
				fcreg <= fcreg + 1;
			end if;
		end if;
	end process;
	
	fsclk <= fsclki;
	fcclk <= fcclki;
	
end rtl;
				
	