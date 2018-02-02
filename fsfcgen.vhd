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

signal fsclki : std_logic;
signal fsreg,setval_fs : std_logic_vector(27 downto 0);
signal fcreg,setval_fc : std_logic_vector(23 downto 0);

begin

	--========================================================================
	-- Additional value setting table of phase accumulator for sampling clock
	--========================================================================
	process(fscntq) begin
		case fscntq is
			when "0000001" => setval_fs <= X"000029F";	--100Hz
			when "0000010" => setval_fs <= X"000053E";	--200Hz
			when "0000011" => setval_fs <= X"00007DD";	--300Hz
			when "0000100" => setval_fs <= X"0000A7C";	--400Hz
			when "0000101" => setval_fs <= X"0000D1B";	--500Hz
			when "0000110" => setval_fs <= X"0000FBB";	--600Hz
			when "0000111" => setval_fs <= X"000125A";	--700Hz
			when "0001000" => setval_fs <= X"00014F9";	--800Hz
			when "0001001" => setval_fs <= X"0001798";	--900Hz
			when "0001010" => setval_fs <= X"0001A37";	--1000Hz
			when "0001011" => setval_fs <= X"0001CD6";	--1100Hz
			when "0001100" => setval_fs <= X"0001F75";	--1200Hz
			when "0001101" => setval_fs <= X"0002214";	--1300Hz
			when "0001110" => setval_fs <= X"00024B3";	--1400Hz
			when "0001111" => setval_fs <= X"0002752";	--1500Hz
			when "0010000" => setval_fs <= X"00029F1";	--1600Hz
			when "0010001" => setval_fs <= X"0002C91";	--1700Hz
			when "0010010" => setval_fs <= X"0002F30";	--1800Hz
			when "0010011" => setval_fs <= X"00031CF";	--1900Hz
			when "0010100" => setval_fs <= X"000346E";	--2000Hz
			when "0010101" => setval_fs <= X"000370D";	--2100Hz
			when "0010110" => setval_fs <= X"00039AC";	--2200Hz
			when "0010111" => setval_fs <= X"0003C4B";	--2300Hz
			when "0011000" => setval_fs <= X"0003EEA";	--2400Hz
			when "0011001" => setval_fs <= X"0004189";	--2500Hz
			when "0011010" => setval_fs <= X"0004428";	--2600Hz
			when "0011011" => setval_fs <= X"00046C7";	--2700Hz
			when "0011100" => setval_fs <= X"0004966";	--2800Hz
			when "0011101" => setval_fs <= X"0004C06";	--2900Hz
			when "0011110" => setval_fs <= X"0004EA5";	--3000Hz
			when "0011111" => setval_fs <= X"0005144";	--3100Hz
			when "0100000" => setval_fs <= X"00053E3";	--3200Hz
			when "0100001" => setval_fs <= X"0005682";	--3300Hz
			when "0100010" => setval_fs <= X"0005921";	--3400Hz
			when "0100011" => setval_fs <= X"0005BC0";	--3500Hz
			when "0100100" => setval_fs <= X"0005E5F";	--3600Hz
			when "0100101" => setval_fs <= X"00060FE";	--3700Hz
			when "0100110" => setval_fs <= X"000639D";	--3800Hz
			when "0100111" => setval_fs <= X"000663C";	--3900Hz
			when "0101000" => setval_fs <= X"00068DC";	--4000Hz
			when "0101001" => setval_fs <= X"0006B7B";	--4100Hz
			when "0101010" => setval_fs <= X"0006E1A";	--4200Hz
			when "0101011" => setval_fs <= X"00070B9";	--4300Hz
			when "0101100" => setval_fs <= X"0007358";	--4400Hz
			when "0101101" => setval_fs <= X"00075F7";	--4500Hz
			when "0101110" => setval_fs <= X"0007896";	--4600Hz
			when "0101111" => setval_fs <= X"0007B35";	--4700Hz
			when "0110000" => setval_fs <= X"0007DD4";	--4800Hz
			when "0110001" => setval_fs <= X"0008073";	--4900Hz
			when "0110010" => setval_fs <= X"0008312";	--5000Hz
			when "0110011" => setval_fs <= X"00085B2";	--5100Hz
			when "0110100" => setval_fs <= X"0008851";	--5200Hz
			when "0110101" => setval_fs <= X"0008AF0";	--5300Hz
			when "0110110" => setval_fs <= X"0008D8F";	--5400Hz
			when "0110111" => setval_fs <= X"000902E";	--5500Hz
			when "0111000" => setval_fs <= X"00092CD";	--5600Hz
			when "0111001" => setval_fs <= X"000956C";	--5700Hz
			when "0111010" => setval_fs <= X"000980B";	--5800Hz
			when "0111011" => setval_fs <= X"0009AAA";	--5900Hz
			when "0111100" => setval_fs <= X"0009D49";	--6000Hz
			when "0111101" => setval_fs <= X"0009FE8";	--6100Hz
			when "0111110" => setval_fs <= X"000A287";	--6200Hz
			when "0111111" => setval_fs <= X"000A527";	--6300Hz
			when "1000000" => setval_fs <= X"000A7C6";	--6400Hz
			when "1000001" => setval_fs <= X"000AA65";	--6500Hz
			when "1000010" => setval_fs <= X"000AD04";	--6600Hz
			when "1000011" => setval_fs <= X"000AFA3";	--6700Hz
			when "1000100" => setval_fs <= X"000B242";	--6800Hz
			when "1000101" => setval_fs <= X"000B4E1";	--6900Hz
			when "1000110" => setval_fs <= X"000B780";	--7000Hz
			when "1000111" => setval_fs <= X"000BA1F";	--7100Hz
			when "1001000" => setval_fs <= X"000BCBE";	--7200Hz
			when "1001001" => setval_fs <= X"000BF5D";	--7300Hz
			when "1001010" => setval_fs <= X"000C1FD";	--7400Hz
			when "1001011" => setval_fs <= X"000C49C";	--7500Hz
			when "1001100" => setval_fs <= X"000C73B";	--7600Hz
			when "1001101" => setval_fs <= X"000C9DA";	--7700Hz
			when "1001110" => setval_fs <= X"000CC79";	--7800Hz
			when "1001111" => setval_fs <= X"000CF18";	--7900Hz
			when "1010000" => setval_fs <= X"000D1B7";	--8000Hz
			when "1010001" => setval_fs <= X"000D456";	--8100Hz
			when "1010010" => setval_fs <= X"000D6F5";	--8200Hz
			when "1010011" => setval_fs <= X"000D994";	--8300Hz
			when "1010100" => setval_fs <= X"000DC33";	--8400Hz
			when "1010101" => setval_fs <= X"000DED3";	--8500Hz
			when "1010110" => setval_fs <= X"000E172";	--8600Hz
			when "1010111" => setval_fs <= X"000E411";	--8700Hz
			when "1011000" => setval_fs <= X"000E6B0";	--8800Hz
			when "1011001" => setval_fs <= X"000E94F";	--8900Hz
			when "1011010" => setval_fs <= X"000EBEE";	--9000Hz
			when "1011011" => setval_fs <= X"000EE8D";	--9100Hz
			when "1011100" => setval_fs <= X"000F12C";	--9200Hz
			when "1011101" => setval_fs <= X"000F3CB";	--9300Hz
			when "1011110" => setval_fs <= X"000F66A";	--9400Hz
			when "1011111" => setval_fs <= X"000F909";	--9500Hz
			when "1100000" => setval_fs <= X"000FBA9";	--9600Hz
			when "1100001" => setval_fs <= X"000FE48";	--9700Hz
			when "1100010" => setval_fs <= X"00100E7";	--9800Hz
			when "1100011" => setval_fs <= X"0010386";	--9900Hz
			when "1100100" => setval_fs <= X"0010625";	--10kHz			
			when "1100101" => setval_fs <= X"001205C";	--11kHz
			when "1100110" => setval_fs <= X"0013A93";	--12kHz
			when "1100111" => setval_fs <= X"00154CA";	--13kHz
			when "1101000" => setval_fs <= X"0016F00";	--14kHz
			when "1101001" => setval_fs <= X"0018937";	--15kHz
			when "1101010" => setval_fs <= X"001A36E";	--16kHz
			when "1101011" => setval_fs <= X"001BDA5";	--17kHz
			when "1101100" => setval_fs <= X"001D7DC";	--18kHz
			when "1101101" => setval_fs <= X"001F213";	--19kHz
			when "1101110" => setval_fs <= X"0020C4A";	--20kHz
			when "1101111" => setval_fs <= X"0028F5C";	--25kHz
			when "1110000" => setval_fs <= X"00346DC";	--32kHz
			when "1110001" => setval_fs <= X"0041893";	--40kHz
			when "1110010" => setval_fs <= X"004816F";	--44kHz
			when others => setval_fs <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--============================================
	--Generate Sampling clock by phase accumulator
	--============================================
	process(clk,reset) begin
		if reset = '0' then
			fsreg <= "0000000000000000000000000000";
		elsif clk'event and clk='1' then
			fsreg <= fsreg + setval_fs;
		end if;
	end process;
	fsclk <= fsreg(27);

	
	--====================================================================
	--Additional value setting table of phase accumulator for cutoff freq.
	--====================================================================
	process(fccntq) begin
		case fccntq is
			when "0000" => setval_fc <= X"022D0E";	--3.4kHz
			when "0001" => setval_fc <= X"00A3D7";	--1kHz
			when "0010" => setval_fc <= X"0147AE";	--2kHz
			when "0011" => setval_fc <= X"01EB85";	--3kHz
			when "0100" => setval_fc <= X"028F5C";	--4kHz
			when "0101" => setval_fc <= X"033333";	--5kHz
			when "0110" => setval_fc <= X"03D70A";	--6kHz
			when "0111" => setval_fc <= X"047AE1";	--7kHz
			when "1000" => setval_fc <= X"051EB8";	--8kHz
			when "1001" => setval_fc <= X"05C28F";	--9kHz
			when "1010" => setval_fc <= X"066666";	--10kHz
			when "1011" => setval_fc <= X"08F5C3";	--14kHz
			when "1100" => setval_fc <= X"0CCCCD";	--20kHz
			when "1101" => setval_fc <= X"200000";	--50kHz
			when others => setval_fc <= "XXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--==========================================
	--Generate FCCLK signal by phase accumulator
	--==========================================
	process(clk,reset) begin
		if reset = '0' then
			fcreg <= "000000000000000000000000";
		elsif clk'event and clk='1' then
			fcreg <= fcreg + setval_fc;
		end if;
	end process;
	fcclk <= fcreg(23);

end rtl;
				
	