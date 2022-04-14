library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity fsfcgen is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		jikken1 : in std_logic;
		fscntq : in std_logic_vector(6 downto 0);
		fccntq : in std_logic_vector(3 downto 0);
		fsclk : out std_logic;
		fcclk : out std_logic);
end fsfcgen;

architecture rtl of fsfcgen is

signal fsclki : std_logic;
signal fsreg,setval_fs : std_logic_vector(31 downto 0);
signal fcreg,setval_fc : std_logic_vector(31 downto 0);

begin

	--========================================================================
	-- Additional value setting table of phase accumulator for sampling clock
	--========================================================================
	process(fscntq) begin
		case fscntq is
			when "0000000" => setval_fs <= X"000346DC";	--1000Hz
			when "0000001" => setval_fs <= X"000053E3";	--100Hz
			when "0000010" => setval_fs <= X"0000A7C6";	--200Hz
			when "0000011" => setval_fs <= X"0000FBA9";	--300Hz
			when "0000100" => setval_fs <= X"00014F8B";	--400Hz
			when "0000101" => setval_fs <= X"0001A36E";	--500Hz
			when "0000110" => setval_fs <= X"0001F751";	--600Hz
			when "0000111" => setval_fs <= X"00024B34";	--700Hz
			when "0001000" => setval_fs <= X"00029F17";	--800Hz
			when "0001001" => setval_fs <= X"0002F2FA";	--900Hz
			when "0001010" => setval_fs <= X"000346DC";	--1000Hz
			when "0001011" => setval_fs <= X"00039ABF";	--1100Hz
			when "0001100" => setval_fs <= X"0003EEA2";	--1200Hz
			when "0001101" => setval_fs <= X"00044285";	--1300Hz
			when "0001110" => setval_fs <= X"00049668";	--1400Hz
			when "0001111" => setval_fs <= X"0004EA4B";	--1500Hz
			when "0010000" => setval_fs <= X"00053E2D";	--1600Hz
			when "0010001" => setval_fs <= X"00059210";	--1700Hz
			when "0010010" => setval_fs <= X"0005E5F3";	--1800Hz
			when "0010011" => setval_fs <= X"000639D6";	--1900Hz
			when "0010100" => setval_fs <= X"00068DB9";	--2000Hz
			when "0010101" => setval_fs <= X"0006E19C";	--2100Hz
			when "0010110" => setval_fs <= X"0007357E";	--2200Hz
			when "0010111" => setval_fs <= X"00078961";	--2300Hz
			when "0011000" => setval_fs <= X"0007DD44";	--2400Hz
			when "0011001" => setval_fs <= X"00083127";	--2500Hz
			when "0011010" => setval_fs <= X"0008850A";	--2600Hz
			when "0011011" => setval_fs <= X"0008D8ED";	--2700Hz
			when "0011100" => setval_fs <= X"00092CCF";	--2800Hz
			when "0011101" => setval_fs <= X"000980B2";	--2900Hz
			when "0011110" => setval_fs <= X"0009D495";	--3000Hz
			when "0011111" => setval_fs <= X"000A2878";	--3100Hz
			when "0100000" => setval_fs <= X"000A7C5B";	--3200Hz
			when "0100001" => setval_fs <= X"000AD03E";	--3300Hz
			when "0100010" => setval_fs <= X"000B2420";	--3400Hz
			when "0100011" => setval_fs <= X"000B7803";	--3500Hz
			when "0100100" => setval_fs <= X"000BCBE6";	--3600Hz
			when "0100101" => setval_fs <= X"000C1FC9";	--3700Hz
			when "0100110" => setval_fs <= X"000C73AC";	--3800Hz
			when "0100111" => setval_fs <= X"000CC78F";	--3900Hz
			when "0101000" => setval_fs <= X"000D1B71";	--4000Hz
			when "0101001" => setval_fs <= X"000D6F54";	--4100Hz
			when "0101010" => setval_fs <= X"000DC337";	--4200Hz
			when "0101011" => setval_fs <= X"000E171A";	--4300Hz
			when "0101100" => setval_fs <= X"000E6AFD";	--4400Hz
			when "0101101" => setval_fs <= X"000EBEE0";	--4500Hz
			when "0101110" => setval_fs <= X"000F12C2";	--4600Hz
			when "0101111" => setval_fs <= X"000F66A5";	--4700Hz
			when "0110000" => setval_fs <= X"000FBA88";	--4800Hz
			when "0110001" => setval_fs <= X"00100E6B";	--4900Hz
			when "0110010" => setval_fs <= X"0010624E";	--5000Hz
			when "0110011" => setval_fs <= X"0010B631";	--5100Hz
			when "0110100" => setval_fs <= X"00110A13";	--5200Hz
			when "0110101" => setval_fs <= X"00115DF6";	--5300Hz
			when "0110110" => setval_fs <= X"0011B1D9";	--5400Hz
			when "0110111" => setval_fs <= X"001205BC";	--5500Hz
			when "0111000" => setval_fs <= X"0012599F";	--5600Hz
			when "0111001" => setval_fs <= X"0012AD82";	--5700Hz
			when "0111010" => setval_fs <= X"00130165";	--5800Hz
			when "0111011" => setval_fs <= X"00135547";	--5900Hz
			when "0111100" => setval_fs <= X"0013A92A";	--6000Hz
			when "0111101" => setval_fs <= X"0013FD0D";	--6100Hz
			when "0111110" => setval_fs <= X"001450F0";	--6200Hz
			when "0111111" => setval_fs <= X"0014A4D3";	--6300Hz
			when "1000000" => setval_fs <= X"0014F8B6";	--6400Hz
			when "1000001" => setval_fs <= X"00154C98";	--6500Hz
			when "1000010" => setval_fs <= X"0015A07B";	--6600Hz
			when "1000011" => setval_fs <= X"0015F45E";	--6700Hz
			when "1000100" => setval_fs <= X"00164841";	--6800Hz
			when "1000101" => setval_fs <= X"00169C24";	--6900Hz
			when "1000110" => setval_fs <= X"0016F007";	--7000Hz
			when "1000111" => setval_fs <= X"001743E9";	--7100Hz
			when "1001000" => setval_fs <= X"001797CC";	--7200Hz
			when "1001001" => setval_fs <= X"0017EBAF";	--7300Hz
			when "1001010" => setval_fs <= X"00183F92";	--7400Hz
			when "1001011" => setval_fs <= X"00189375";	--7500Hz
			when "1001100" => setval_fs <= X"0018E758";	--7600Hz
			when "1001101" => setval_fs <= X"00193B3A";	--7700Hz
			when "1001110" => setval_fs <= X"00198F1D";	--7800Hz
			when "1001111" => setval_fs <= X"0019E300";	--7900Hz
			when "1010000" => setval_fs <= X"001A36E3";	--8000Hz
			when "1010001" => setval_fs <= X"001A8AC6";	--8100Hz
			when "1010010" => setval_fs <= X"001ADEA9";	--8200Hz
			when "1010011" => setval_fs <= X"001B328B";	--8300Hz
			when "1010100" => setval_fs <= X"001B866E";	--8400Hz
			when "1010101" => setval_fs <= X"001BDA51";	--8500Hz
			when "1010110" => setval_fs <= X"001C2E34";	--8600Hz
			when "1010111" => setval_fs <= X"001C8217";	--8700Hz
			when "1011000" => setval_fs <= X"001CD5FA";	--8800Hz
			when "1011001" => setval_fs <= X"001D29DC";	--8900Hz
			when "1011010" => setval_fs <= X"001D7DBF";	--9000Hz
			when "1011011" => setval_fs <= X"001DD1A2";	--9100Hz
			when "1011100" => setval_fs <= X"001E2585";	--9200Hz
			when "1011101" => setval_fs <= X"001E7968";	--9300Hz
			when "1011110" => setval_fs <= X"001ECD4B";	--9400Hz
			when "1011111" => setval_fs <= X"001F212D";	--9500Hz
			when "1100000" => setval_fs <= X"001F7510";	--9600Hz
			when "1100001" => setval_fs <= X"001FC8F3";	--9700Hz
			when "1100010" => setval_fs <= X"00201CD6";	--9800Hz
			when "1100011" => setval_fs <= X"002070B9";	--9900Hz
			when "1100100" => setval_fs <= X"0020C49C";	--10kHz			
			when "1100101" => setval_fs <= X"00240B78";	--11kHz
			when "1100110" => setval_fs <= X"00275254";	--12kHz
			when "1100111" => setval_fs <= X"002A9931";	--13kHz
			when "1101000" => setval_fs <= X"002DE00D";	--14kHz
			when "1101001" => setval_fs <= X"003126E9";	--15kHz
			when "1101010" => setval_fs <= X"00346DC6";	--16kHz
			when "1101011" => setval_fs <= X"0037B4A2";	--17kHz
			when "1101100" => setval_fs <= X"003AFB7F";	--18kHz
			when "1101101" => setval_fs <= X"003E425B";	--19kHz
			when "1101110" => setval_fs <= X"00418937";	--20kHz
			when "1101111" => setval_fs <= X"0051EB85";	--25kHz
			when "1110000" => setval_fs <= X"0068DB8C";	--32kHz
			when "1110001" => setval_fs <= X"0083126F";	--40kHz
			when "1110010" => setval_fs <= X"00902DE0";	--44kHz
			when others => setval_fs <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--============================================
	--Generate Sampling clock by phase accumulator
	--============================================
	-- Clock frequency is 20MHz
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
	process(fccntq, jikken1) begin
		case fccntq is
			when "0000" => 
				if jikken1 = '1' then
					setval_fc <= X"045A1CAC";	--3.4kHz
				else
					setval_fc <= X"1999999A";	--20kHz
				end if;
			when "0001" => setval_fc <= X"0147AE14";	--1kHz
			when "0010" => setval_fc <= X"028F5C29";	--2kHz
			when "0011" => setval_fc <= X"03D70A3D";	--3kHz
			when "0100" => setval_fc <= X"051EB852";	--4kHz
			when "0101" => setval_fc <= X"06666666";	--5kHz
			when "0110" => setval_fc <= X"07AE147B";	--6kHz
			when "0111" => setval_fc <= X"08F5C28F";	--7kHz
			when "1000" => setval_fc <= X"0A3D70A4";	--8kHz
			when "1001" => setval_fc <= X"0B851EB8";	--9kHz
			when "1010" => setval_fc <= X"0CCCCCCD";	--10kHz
			when "1011" => setval_fc <= X"11EB851F";	--14kHz
			when "1100" => setval_fc <= X"1999999A";	--20kHz
			when "1101" => setval_fc <= X"40000000";	--50kHz
			when others => setval_fc <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--==========================================
	--Generate FCCLK signal by phase accumulator
	--==========================================
	-- Clock frequency is 20MHz
	process(clk,reset) begin
		if reset = '0' then
			fcreg <= "00000000000000000000000000000000";
		elsif clk'event and clk='1' then
			fcreg <= fcreg + setval_fc;
		end if;
	end process;
	fcclk <= fcreg(31);

end rtl;
				
	