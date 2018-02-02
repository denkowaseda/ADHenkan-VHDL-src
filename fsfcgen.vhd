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
signal fsreg,setval_fs : std_logic_vector(31 downto 0);
signal fcreg,setval_fc : std_logic_vector(23 downto 0);

begin

	--========================================================================
	-- Additional value setting table of phase accumulator for sampling clock
	--========================================================================
	process(fscntq) begin
		case fscntq is
			when "0000001" => setval_fs <= X"000029F1";	--100Hz
			when "0000010" => setval_fs <= X"000053E3";	--200Hz
			when "0000011" => setval_fs <= X"00007DD4";	--300Hz
			when "0000100" => setval_fs <= X"0000A7C6";	--400Hz
			when "0000101" => setval_fs <= X"0000D1B7";	--500Hz
			when "0000110" => setval_fs <= X"0000FBA9";	--600Hz
			when "0000111" => setval_fs <= X"0001259A";	--700Hz
			when "0001000" => setval_fs <= X"00014F8B";	--800Hz
			when "0001001" => setval_fs <= X"0001797D";	--900Hz
			when "0001010" => setval_fs <= X"0001A36E";	--1000Hz
			when "0001011" => setval_fs <= X"0001CD60";	--1100Hz
			when "0001100" => setval_fs <= X"0001F751";	--1200Hz
			when "0001101" => setval_fs <= X"00022142";	--1300Hz
			when "0001110" => setval_fs <= X"00024B34";	--1400Hz
			when "0001111" => setval_fs <= X"00027525";	--1500Hz
			when "0010000" => setval_fs <= X"00029F17";	--1600Hz
			when "0010001" => setval_fs <= X"0002C908";	--1700Hz
			when "0010010" => setval_fs <= X"0002F2FA";	--1800Hz
			when "0010011" => setval_fs <= X"00031CEB";	--1900Hz
			when "0010100" => setval_fs <= X"000346DC";	--2000Hz
			when "0010101" => setval_fs <= X"000370CE";	--2100Hz
			when "0010110" => setval_fs <= X"00039ABF";	--2200Hz
			when "0010111" => setval_fs <= X"0003C4B1";	--2300Hz
			when "0011000" => setval_fs <= X"0003EEA2";	--2400Hz
			when "0011001" => setval_fs <= X"00041893";	--2500Hz
			when "0011010" => setval_fs <= X"00044285";	--2600Hz
			when "0011011" => setval_fs <= X"00046C76";	--2700Hz
			when "0011100" => setval_fs <= X"00049668";	--2800Hz
			when "0011101" => setval_fs <= X"0004C059";	--2900Hz
			when "0011110" => setval_fs <= X"0004EA4B";	--3000Hz
			when "0011111" => setval_fs <= X"0005143C";	--3100Hz
			when "0100000" => setval_fs <= X"00053E2D";	--3200Hz
			when "0100001" => setval_fs <= X"0005681F";	--3300Hz
			when "0100010" => setval_fs <= X"00059210";	--3400Hz
			when "0100011" => setval_fs <= X"0005BC02";	--3500Hz
			when "0100100" => setval_fs <= X"0005E5F3";	--3600Hz
			when "0100101" => setval_fs <= X"00060FE4";	--3700Hz
			when "0100110" => setval_fs <= X"000639D6";	--3800Hz
			when "0100111" => setval_fs <= X"000663C7";	--3900Hz
			when "0101000" => setval_fs <= X"00068DB9";	--4000Hz
			when "0101001" => setval_fs <= X"0006B7AA";	--4100Hz
			when "0101010" => setval_fs <= X"0006E19C";	--4200Hz
			when "0101011" => setval_fs <= X"00070B8D";	--4300Hz
			when "0101100" => setval_fs <= X"0007357E";	--4400Hz
			when "0101101" => setval_fs <= X"00075F70";	--4500Hz
			when "0101110" => setval_fs <= X"00078961";	--4600Hz
			when "0101111" => setval_fs <= X"0007B353";	--4700Hz
			when "0110000" => setval_fs <= X"0007DD44";	--4800Hz
			when "0110001" => setval_fs <= X"00080735";	--4900Hz
			when "0110010" => setval_fs <= X"00083127";	--5000Hz
			when "0110011" => setval_fs <= X"00085B18";	--5100Hz
			when "0110100" => setval_fs <= X"0008850A";	--5200Hz
			when "0110101" => setval_fs <= X"0008AEFB";	--5300Hz
			when "0110110" => setval_fs <= X"0008D8ED";	--5400Hz
			when "0110111" => setval_fs <= X"000902DE";	--5500Hz
			when "0111000" => setval_fs <= X"00092CCF";	--5600Hz
			when "0111001" => setval_fs <= X"000956C1";	--5700Hz
			when "0111010" => setval_fs <= X"000980B2";	--5800Hz
			when "0111011" => setval_fs <= X"0009AAA4";	--5900Hz
			when "0111100" => setval_fs <= X"0009D495";	--6000Hz
			when "0111101" => setval_fs <= X"0009FE87";	--6100Hz
			when "0111110" => setval_fs <= X"000A2878";	--6200Hz
			when "0111111" => setval_fs <= X"000A5269";	--6300Hz
			when "1000000" => setval_fs <= X"000A7C5B";	--6400Hz
			when "1000001" => setval_fs <= X"000AA64C";	--6500Hz
			when "1000010" => setval_fs <= X"000AD03E";	--6600Hz
			when "1000011" => setval_fs <= X"000AFA2F";	--6700Hz
			when "1000100" => setval_fs <= X"000B2420";	--6800Hz
			when "1000101" => setval_fs <= X"000B4E12";	--6900Hz
			when "1000110" => setval_fs <= X"000B7803";	--7000Hz
			when "1000111" => setval_fs <= X"000BA1F5";	--7100Hz
			when "1001000" => setval_fs <= X"000BCBE6";	--7200Hz
			when "1001001" => setval_fs <= X"000BF5D8";	--7300Hz
			when "1001010" => setval_fs <= X"000C1FC9";	--7400Hz
			when "1001011" => setval_fs <= X"000C49BA";	--7500Hz
			when "1001100" => setval_fs <= X"000C73AC";	--7600Hz
			when "1001101" => setval_fs <= X"000C9D9D";	--7700Hz
			when "1001110" => setval_fs <= X"000CC78F";	--7800Hz
			when "1001111" => setval_fs <= X"000CF180";	--7900Hz
			when "1010000" => setval_fs <= X"000D1B71";	--8000Hz
			when "1010001" => setval_fs <= X"000D4563";	--8100Hz
			when "1010010" => setval_fs <= X"000D6F54";	--8200Hz
			when "1010011" => setval_fs <= X"000D9946";	--8300Hz
			when "1010100" => setval_fs <= X"000DC337";	--8400Hz
			when "1010101" => setval_fs <= X"000DED29";	--8500Hz
			when "1010110" => setval_fs <= X"000E171A";	--8600Hz
			when "1010111" => setval_fs <= X"000E410B";	--8700Hz
			when "1011000" => setval_fs <= X"000E6AFD";	--8800Hz
			when "1011001" => setval_fs <= X"000E94EE";	--8900Hz
			when "1011010" => setval_fs <= X"000EBEE0";	--9000Hz
			when "1011011" => setval_fs <= X"000EE8D1";	--9100Hz
			when "1011100" => setval_fs <= X"000F12C2";	--9200Hz
			when "1011101" => setval_fs <= X"000F3CB4";	--9300Hz
			when "1011110" => setval_fs <= X"000F66A5";	--9400Hz
			when "1011111" => setval_fs <= X"000F9097";	--9500Hz
			when "1100000" => setval_fs <= X"000FBA88";	--9600Hz
			when "1100001" => setval_fs <= X"000FE47A";	--9700Hz
			when "1100010" => setval_fs <= X"00100E6B";	--9800Hz
			when "1100011" => setval_fs <= X"0010385C";	--9900Hz
			when "1100100" => setval_fs <= X"0010624E";	--10kHz			
			when "1100101" => setval_fs <= X"001205BC";	--11kHz
			when "1100110" => setval_fs <= X"0013A92A";	--12kHz
			when "1100111" => setval_fs <= X"00154C98";	--13kHz
			when "1101000" => setval_fs <= X"0016F007";	--14kHz
			when "1101001" => setval_fs <= X"00189375";	--15kHz
			when "1101010" => setval_fs <= X"001A36E3";	--16kHz
			when "1101011" => setval_fs <= X"001BDA51";	--17kHz
			when "1101100" => setval_fs <= X"001D7DBF";	--18kHz
			when "1101101" => setval_fs <= X"001F212D";	--19kHz
			when "1101110" => setval_fs <= X"0020C49C";	--20kHz
			when "1101111" => setval_fs <= X"0028F5C3";	--25kHz
			when "1110000" => setval_fs <= X"00346DC6";	--32kHz
			when "1110001" => setval_fs <= X"00418937";	--40kHz
			when "1110010" => setval_fs <= X"004816F0";	--44kHz
			when others => setval_fs <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--============================================
	--Generate Sampling clock by phase accumulator
	--============================================
	process(clk,reset) begin
		if reset = '0' then
--			fsreg <= "000000000000000000000000";
			fsreg <= "00000000000000000000000000000000";
		elsif clk'event and clk='1' then
			fsreg <= fsreg + setval_fs;
		end if;
	end process;
	fsclk <= fsreg(31);

	
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
				
	