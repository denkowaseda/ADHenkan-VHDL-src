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
signal fsreg,setval_fs : std_logic_vector(23 downto 0);
signal fcreg,setval_fc : std_logic_vector(19 downto 0);

begin

	--========================================================================
	-- Additional value setting table of phase accumulator for sampling clock
	--========================================================================
	process(fscntq) begin
		case fscntq is
			when "0000001" => setval_fs <= X"00002A";	--100Hz
			when "0000010" => setval_fs <= X"000054";	--200Hz
			when "0000011" => setval_fs <= X"00007E";	--300Hz
			when "0000100" => setval_fs <= X"0000A8";	--400Hz
			when "0000101" => setval_fs <= X"0000D2";	--500Hz
			when "0000110" => setval_fs <= X"0000FC";	--600Hz
			when "0000111" => setval_fs <= X"000126";	--700Hz
			when "0001000" => setval_fs <= X"000150";	--800Hz
			when "0001001" => setval_fs <= X"000179";	--900Hz
			when "0001010" => setval_fs <= X"0001A3";	--1000Hz
			when "0001011" => setval_fs <= X"0001CD";	--1100Hz
			when "0001100" => setval_fs <= X"0001F7";	--1200Hz
			when "0001101" => setval_fs <= X"000221";	--1300Hz
			when "0001110" => setval_fs <= X"00024B";	--1400Hz
			when "0001111" => setval_fs <= X"000275";	--1500Hz
			when "0010000" => setval_fs <= X"00029F";	--1600Hz
			when "0010001" => setval_fs <= X"0002C9";	--1700Hz
			when "0010010" => setval_fs <= X"0002F3";	--1800Hz
			when "0010011" => setval_fs <= X"00031D";	--1900Hz
			when "0010100" => setval_fs <= X"000347";	--2000Hz
			when "0010101" => setval_fs <= X"000371";	--2100Hz
			when "0010110" => setval_fs <= X"00039B";	--2200Hz
			when "0010111" => setval_fs <= X"0003C5";	--2300Hz
			when "0011000" => setval_fs <= X"0003EF";	--2400Hz
			when "0011001" => setval_fs <= X"000419";	--2500Hz
			when "0011010" => setval_fs <= X"000443";	--2600Hz
			when "0011011" => setval_fs <= X"00046C";	--2700Hz
			when "0011100" => setval_fs <= X"000496";	--2800Hz
			when "0011101" => setval_fs <= X"0004C0";	--2900Hz
			when "0011110" => setval_fs <= X"0004EA";	--3000Hz
			when "0011111" => setval_fs <= X"000514";	--3100Hz
			when "0100000" => setval_fs <= X"00053E";	--3200Hz
			when "0100001" => setval_fs <= X"000568";	--3300Hz
			when "0100010" => setval_fs <= X"000592";	--3400Hz
			when "0100011" => setval_fs <= X"0005BC";	--3500Hz
			when "0100100" => setval_fs <= X"0005E6";	--3600Hz
			when "0100101" => setval_fs <= X"000610";	--3700Hz
			when "0100110" => setval_fs <= X"00063A";	--3800Hz
			when "0100111" => setval_fs <= X"000664";	--3900Hz
			when "0101000" => setval_fs <= X"00068E";	--4000Hz
			when "0101001" => setval_fs <= X"0006B8";	--4100Hz
			when "0101010" => setval_fs <= X"0006E2";	--4200Hz
			when "0101011" => setval_fs <= X"00070C";	--4300Hz
			when "0101100" => setval_fs <= X"000735";	--4400Hz
			when "0101101" => setval_fs <= X"00075F";	--4500Hz
			when "0101110" => setval_fs <= X"000789";	--4600Hz
			when "0101111" => setval_fs <= X"0007B3";	--4700Hz
			when "0110000" => setval_fs <= X"0007DD";	--4800Hz
			when "0110001" => setval_fs <= X"000807";	--4900Hz
			when "0110010" => setval_fs <= X"000831";	--5000Hz
			when "0110011" => setval_fs <= X"00085B";	--5100Hz
			when "0110100" => setval_fs <= X"000885";	--5200Hz
			when "0110101" => setval_fs <= X"0008AF";	--5300Hz
			when "0110110" => setval_fs <= X"0008D9";	--5400Hz
			when "0110111" => setval_fs <= X"000903";	--5500Hz
			when "0111000" => setval_fs <= X"00092D";	--5600Hz
			when "0111001" => setval_fs <= X"000957";	--5700Hz
			when "0111010" => setval_fs <= X"000981";	--5800Hz
			when "0111011" => setval_fs <= X"0009AB";	--5900Hz
			when "0111100" => setval_fs <= X"0009D5";	--6000Hz
			when "0111101" => setval_fs <= X"0009FF";	--6100Hz
			when "0111110" => setval_fs <= X"000A28";	--6200Hz
			when "0111111" => setval_fs <= X"000A52";	--6300Hz
			when "1000000" => setval_fs <= X"000A7C";	--6400Hz
			when "1000001" => setval_fs <= X"000AA6";	--6500Hz
			when "1000010" => setval_fs <= X"000AD0";	--6600Hz
			when "1000011" => setval_fs <= X"000AFA";	--6700Hz
			when "1000100" => setval_fs <= X"000B24";	--6800Hz
			when "1000101" => setval_fs <= X"000B4E";	--6900Hz
			when "1000110" => setval_fs <= X"000B78";	--7000Hz
			when "1000111" => setval_fs <= X"000BA2";	--7100Hz
			when "1001000" => setval_fs <= X"000BCC";	--7200Hz
			when "1001001" => setval_fs <= X"000BF6";	--7300Hz
			when "1001010" => setval_fs <= X"000C20";	--7400Hz
			when "1001011" => setval_fs <= X"000C4A";	--7500Hz
			when "1001100" => setval_fs <= X"000C74";	--7600Hz
			when "1001101" => setval_fs <= X"000C9E";	--7700Hz
			when "1001110" => setval_fs <= X"000CC8";	--7800Hz
			when "1001111" => setval_fs <= X"000CF2";	--7900Hz
			when "1010000" => setval_fs <= X"000D1B";	--8000Hz
			when "1010001" => setval_fs <= X"000D45";	--8100Hz
			when "1010010" => setval_fs <= X"000D6F";	--8200Hz
			when "1010011" => setval_fs <= X"000D99";	--8300Hz
			when "1010100" => setval_fs <= X"000DC3";	--8400Hz
			when "1010101" => setval_fs <= X"000DED";	--8500Hz
			when "1010110" => setval_fs <= X"000E17";	--8600Hz
			when "1010111" => setval_fs <= X"000E41";	--8700Hz
			when "1011000" => setval_fs <= X"000E6B";	--8800Hz
			when "1011001" => setval_fs <= X"000E95";	--8900Hz
			when "1011010" => setval_fs <= X"000EBF";	--9000Hz
			when "1011011" => setval_fs <= X"000EE9";	--9100Hz
			when "1011100" => setval_fs <= X"000F13";	--9200Hz
			when "1011101" => setval_fs <= X"000F3D";	--9300Hz
			when "1011110" => setval_fs <= X"000F67";	--9400Hz
			when "1011111" => setval_fs <= X"000F91";	--9500Hz
			when "1100000" => setval_fs <= X"000FBB";	--9600Hz
			when "1100001" => setval_fs <= X"000FE4";	--9700Hz
			when "1100010" => setval_fs <= X"00100E";	--9800Hz
			when "1100011" => setval_fs <= X"001038";	--9900Hz
			when "1100100" => setval_fs <= X"001062";	--10kHz			
			when "1100101" => setval_fs <= X"001206";	--11kHz
			when "1100110" => setval_fs <= X"0013A9";	--12kHz
			when "1100111" => setval_fs <= X"00154D";	--13kHz
			when "1101000" => setval_fs <= X"0016F0";	--14kHz
			when "1101001" => setval_fs <= X"001893";	--15kHz
			when "1101010" => setval_fs <= X"001A37";	--16kHz
			when "1101011" => setval_fs <= X"001BDA";	--17kHz
			when "1101100" => setval_fs <= X"001D7E";	--18kHz
			when "1101101" => setval_fs <= X"001F21";	--19kHz
			when "1101110" => setval_fs <= X"0020C5";	--20kHz
			when "1101111" => setval_fs <= X"0028F6";	--25kHz
			when "1110000" => setval_fs <= X"00346E";	--32kHz
			when "1110001" => setval_fs <= X"004189";	--40kHz
			when "1110010" => setval_fs <= X"004817";	--44kHz
			when others => setval_fs <= "XXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--============================================
	--Generate Sampling clock by phase accumulator
	--============================================
	process(clk,reset) begin
		if reset = '0' then
			fsreg <= "000000000000000000000000";
		elsif clk'event and clk='1' then
			fsreg <= fsreg + setval_fs;
		end if;
	end process;
	fsclk <= fsreg(23);

	
	--====================================================================
	--Additional value setting table of phase accumulator for cutoff freq.
	--====================================================================
	process(fccntq) begin
		case fccntq is
			when "0000" => setval_fc <= X"022D1";	--3.4kHz
			when "0001" => setval_fc <= X"00A3D";	--1kHz
			when "0010" => setval_fc <= X"0147B";	--2kHz
			when "0011" => setval_fc <= X"01EB8";	--3kHz
			when "0100" => setval_fc <= X"028F6";	--4kHz
			when "0101" => setval_fc <= X"03333";	--5kHz
			when "0110" => setval_fc <= X"03D71";	--6kHz
			when "0111" => setval_fc <= X"047AE";	--7kHz
			when "1000" => setval_fc <= X"051EC";	--8kHz
			when "1001" => setval_fc <= X"05C29";	--9kHz
			when "1010" => setval_fc <= X"06666";	--10kHz
			when "1011" => setval_fc <= X"08F5C";	--14kHz
			when "1100" => setval_fc <= X"0CCCD";	--20kHz
			when others => setval_fc <= "XXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--==========================================
	--Generate FCCLK signal by phase accumulator
	--==========================================
	process(clk,reset) begin
		if reset = '0' then
			fcreg <= "00000000000000000000";
		elsif clk'event and clk='1' then
			fcreg <= fcreg + setval_fc;
		end if;
	end process;
	fcclk <= fcreg(19);

end rtl;
				
	