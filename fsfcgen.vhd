library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity fsfcgen is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		fscntq : in std_logic_vector(6 downto 0);
		fccntq : in std_logic_vector(3 downto 0);
		fsclk : out std_logic;
		fcclk : out std_logic);
end fsfcgen;

architecture rtl of fsfcgen is

signal fsclki,fcclki : std_logic;
signal fsreg,setval_fs : std_logic_vector(19 downto 0);
signal fcreg,setval_fc : std_logic_vector(7 downto 0);

begin

	process(fscntq) begin
		case fscntq is
			when "0000001" => setval_fs <= X"30D3F";	--100Hz
			when "0000010" => setval_fs <= X"1869F";	--200Hz
			when "0000011" => setval_fs <= X"1046A";	--300Hz
			when "0000100" => setval_fs <= X"0C34F";	--400Hz
			when "0000101" => setval_fs <= X"09C3F";	--500Hz
			when "0000110" => setval_fs <= X"08235";	--600Hz
			when "0000111" => setval_fs <= X"06F9B";	--700Hz
			when "0001000" => setval_fs <= X"061A7";	--800Hz
			when "0001001" => setval_fs <= X"056CE";	--900Hz
			when "0001010" => setval_fs <= X"04E1F";	--1000Hz
			when "0001011" => setval_fs <= X"04705";	--1100Hz
			when "0001100" => setval_fs <= X"0411A";	--1200Hz
			when "0001101" => setval_fs <= X"03C18";	--1300Hz
			when "0001110" => setval_fs <= X"037CD";	--1400Hz
			when "0001111" => setval_fs <= X"03415";	--1500Hz
			when "0010000" => setval_fs <= X"030D3";	--1600Hz
			when "0010001" => setval_fs <= X"02DF4";	--1700Hz
			when "0010010" => setval_fs <= X"02B67";	--1800Hz
			when "0010011" => setval_fs <= X"0291E";	--1900Hz
			when "0010100" => setval_fs <= X"0270F";	--2000Hz
			when "0010101" => setval_fs <= X"02533";	--2100Hz
			when "0010110" => setval_fs <= X"02382";	--2200Hz
			when "0010111" => setval_fs <= X"021F7";	--2300Hz
			when "0011000" => setval_fs <= X"0208D";	--2400Hz
			when "0011001" => setval_fs <= X"01F3F";	--2500Hz
			when "0011010" => setval_fs <= X"01E0C";	--2600Hz
			when "0011011" => setval_fs <= X"01CEF";	--2700Hz
			when "0011100" => setval_fs <= X"01BE6";	--2800Hz
			when "0011101" => setval_fs <= X"01AF0";	--2900Hz
			when "0011110" => setval_fs <= X"01A0A";	--3000Hz
			when "0011111" => setval_fs <= X"01933";	--3100Hz
			when "0100000" => setval_fs <= X"01869";	--3200Hz
			when "0100001" => setval_fs <= X"017AC";	--3300Hz
			when "0100010" => setval_fs <= X"016FA";	--3400Hz
			when "0100011" => setval_fs <= X"01652";	--3500Hz
			when "0100100" => setval_fs <= X"015B3";	--3600Hz
			when "0100101" => setval_fs <= X"0151D";	--3700Hz
			when "0100110" => setval_fs <= X"0148F";	--3800Hz
			when "0100111" => setval_fs <= X"01408";	--3900Hz
			when "0101000" => setval_fs <= X"01387";	--4000Hz
			when "0101001" => setval_fs <= X"0130E";	--4100Hz
			when "0101010" => setval_fs <= X"01299";	--4200Hz
			when "0101011" => setval_fs <= X"0122B";	--4300Hz
			when "0101100" => setval_fs <= X"011C1";	--4400Hz
			when "0101101" => setval_fs <= X"0115C";	--4500Hz
			when "0101110" => setval_fs <= X"010FB";	--4600Hz
			when "0101111" => setval_fs <= X"0109F";	--4700Hz
			when "0110000" => setval_fs <= X"01046";	--4800Hz
			when "0110001" => setval_fs <= X"00FF1";	--4900Hz
			when "0110010" => setval_fs <= X"00F9F";	--5000Hz
			when "0110011" => setval_fs <= X"00F51";	--5100Hz
			when "0110100" => setval_fs <= X"00F06";	--5200Hz
			when "0110101" => setval_fs <= X"00EBD";	--5300Hz
			when "0110110" => setval_fs <= X"00E77";	--5400Hz
			when "0110111" => setval_fs <= X"00E34";	--5500Hz
			when "0111000" => setval_fs <= X"00DF3";	--5600Hz
			when "0111001" => setval_fs <= X"00DB4";	--5700Hz
			when "0111010" => setval_fs <= X"00D78";	--5800Hz
			when "0111011" => setval_fs <= X"00D3D";	--5900Hz
			when "0111100" => setval_fs <= X"00D05";	--6000Hz
			when "0111101" => setval_fs <= X"00CCE";	--6100Hz
			when "0111110" => setval_fs <= X"00C99";	--6200Hz
			when "0111111" => setval_fs <= X"00C66";	--6300Hz
			when "1000000" => setval_fs <= X"00C34";	--6400Hz
			when "1000001" => setval_fs <= X"00C04";	--6500Hz
			when "1000010" => setval_fs <= X"00BD6";	--6600Hz
			when "1000011" => setval_fs <= X"00BA9";	--6700Hz
			when "1000100" => setval_fs <= X"00B7C";	--6800Hz
			when "1000101" => setval_fs <= X"00B52";	--6900Hz
			when "1000110" => setval_fs <= X"00B29";	--7000Hz
			when "1000111" => setval_fs <= X"00B00";	--7100Hz
			when "1001000" => setval_fs <= X"00AD9";	--7200Hz
			when "1001001" => setval_fs <= X"00AB3";	--7300Hz
			when "1001010" => setval_fs <= X"00A8E";	--7400Hz
			when "1001011" => setval_fs <= X"00A6A";	--7500Hz
			when "1001100" => setval_fs <= X"00A47";	--7600Hz
			when "1001101" => setval_fs <= X"00A25";	--7700Hz
			when "1001110" => setval_fs <= X"00A04";	--7800Hz
			when "1001111" => setval_fs <= X"009E3";	--7900Hz
			when "1010000" => setval_fs <= X"009C3";	--8000Hz
			when "1010001" => setval_fs <= X"009A5";	--8100Hz
			when "1010010" => setval_fs <= X"00987";	--8200Hz
			when "1010011" => setval_fs <= X"00969";	--8300Hz
			when "1010100" => setval_fs <= X"0094C";	--8400Hz
			when "1010101" => setval_fs <= X"00930";	--8500Hz
			when "1010110" => setval_fs <= X"00915";	--8600Hz
			when "1010111" => setval_fs <= X"008FA";	--8700Hz
			when "1011000" => setval_fs <= X"008E0";	--8800Hz
			when "1011001" => setval_fs <= X"008C7";	--8900Hz
			when "1011010" => setval_fs <= X"008AE";	--9000Hz
			when "1011011" => setval_fs <= X"00895";	--9100Hz
			when "1011100" => setval_fs <= X"0087D";	--9200Hz
			when "1011101" => setval_fs <= X"00866";	--9300Hz
			when "1011110" => setval_fs <= X"0084F";	--9400Hz
			when "1011111" => setval_fs <= X"00839";	--9500Hz
			when "1100000" => setval_fs <= X"00823";	--9600Hz
			when "1100001" => setval_fs <= X"0080D";	--9700Hz
			when "1100010" => setval_fs <= X"007F8";	--9800Hz
			when "1100011" => setval_fs <= X"007E4";	--9900Hz
			when "1100100" => setval_fs <= X"007CF";	--10kHz			
			when "1100101" => setval_fs <= X"0071A";	--11kHz
			when "1100110" => setval_fs <= X"00682";	--12kHz
			when "1100111" => setval_fs <= X"00602";	--13kHz
			when "1101000" => setval_fs <= X"00594";	--14kHz
			when "1101001" => setval_fs <= X"00535";	--15kHz
			when "1101010" => setval_fs <= X"004E1";	--16kHz
			when "1101011" => setval_fs <= X"00498";	--17kHz
			when "1101100" => setval_fs <= X"00457";	--18kHz
			when "1101101" => setval_fs <= X"0041C";	--19kHz
			when "1101110" => setval_fs <= X"003E7";	--20kHz
			when "1101111" => setval_fs <= X"0031F";	--25kHz
			when "1110000" => setval_fs <= X"00270";	--32kHz
			when "1110001" => setval_fs <= X"001F3";	--40kHz
			when "1110010" => setval_fs <= X"001C6";	--44kHz
			when others => setval_fs <= "XXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	process(fccntq) begin
		case fccntq is
			when "0000" => setval_fc <= "00111010"; --3.4kHz
			when "0001" => setval_fc <= "11000111";	--1kHz
			when "0010" => setval_fc <= "01100011";	--2kHz
			when "0011" => setval_fc <= "01000001";	--3kHz
			when "0100" => setval_fc <= "00110001";	--4kHz
			when "0101" => setval_fc <= "00100111";	--5kHz
			when "0110" => setval_fc <= "00100000";	--6kHz
			when "0111" => setval_fc <= "00011011";	--7kHz
			when "1000" => setval_fc <= "00011000";	--8kHz
			when "1001" => setval_fc <= "00010101";	--9kHz
			when "1010" => setval_fc <= "00010011";	--10kHz
			when "1011" => setval_fc <= "00001101";	--14kHz
			when "1100" => setval_fc <= "00001001";	--20kHz
			when others => setval_fc <= "XXXXXXXX";
		end case;
	end process;
	
-- System clock is 40MHz
-- Generate FS clock signal
	process(clk,reset) begin
		if reset = '0' then
			fsclki <= '0';
		elsif clk'event and clk = '1' then
			if fsreg = setval_fs then		-- 25ns*setval_fs times count
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
			fcreg <= "00000000";
			fcclki <= '0';
		elsif clk'event and clk = '1' then
			if fcreg = setval_fc then
				fcreg <= "00000000";
				fcclki <= not fcclki;
			else
				fcreg <= fcreg + 1;
			end if;
		end if;
	end process;
	
	fsclk <= fsclki;
	fcclk <= fcclki;
	
end rtl;
				
	