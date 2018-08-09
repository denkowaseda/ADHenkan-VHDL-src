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
signal fcreg,setval_fc : std_logic_vector(27 downto 0);

begin

	--========================================================================
	-- Additional value setting table of phase accumulator for sampling clock
	--========================================================================
	process(fscntq) begin
		case fscntq is
			when "0000001" => setval_fs <= X"000053E";	--100Hz
			when "0000010" => setval_fs <= X"0000A7C";	--200Hz
			when "0000011" => setval_fs <= X"0000FBB";	--300Hz
			when "0000100" => setval_fs <= X"00014F9";	--400Hz
			when "0000101" => setval_fs <= X"0001A37";	--500Hz
			when "0000110" => setval_fs <= X"0001F75";	--600Hz
			when "0000111" => setval_fs <= X"00024B3";	--700Hz
			when "0001000" => setval_fs <= X"00029F1";	--800Hz
			when "0001001" => setval_fs <= X"0002F30";	--900Hz
			when "0001010" => setval_fs <= X"000346E";	--1000Hz
			when "0001011" => setval_fs <= X"00039AC";	--1100Hz
			when "0001100" => setval_fs <= X"0003EEA";	--1200Hz
			when "0001101" => setval_fs <= X"0004428";	--1300Hz
			when "0001110" => setval_fs <= X"0004966";	--1400Hz
			when "0001111" => setval_fs <= X"0004EA5";	--1500Hz
			when "0010000" => setval_fs <= X"00053E3";	--1600Hz
			when "0010001" => setval_fs <= X"0005921";	--1700Hz
			when "0010010" => setval_fs <= X"0005E5F";	--1800Hz
			when "0010011" => setval_fs <= X"000639D";	--1900Hz
			when "0010100" => setval_fs <= X"00068DC";	--2000Hz
			when "0010101" => setval_fs <= X"0006E1A";	--2100Hz
			when "0010110" => setval_fs <= X"0007358";	--2200Hz
			when "0010111" => setval_fs <= X"0007896";	--2300Hz
			when "0011000" => setval_fs <= X"0007DD4";	--2400Hz
			when "0011001" => setval_fs <= X"0008312";	--2500Hz
			when "0011010" => setval_fs <= X"0008851";	--2600Hz
			when "0011011" => setval_fs <= X"0008D8F";	--2700Hz
			when "0011100" => setval_fs <= X"00092CD";	--2800Hz
			when "0011101" => setval_fs <= X"000980B";	--2900Hz
			when "0011110" => setval_fs <= X"0009D49";	--3000Hz
			when "0011111" => setval_fs <= X"000A287";	--3100Hz
			when "0100000" => setval_fs <= X"000A7C6";	--3200Hz
			when "0100001" => setval_fs <= X"000AD04";	--3300Hz
			when "0100010" => setval_fs <= X"000B242";	--3400Hz
			when "0100011" => setval_fs <= X"000B780";	--3500Hz
			when "0100100" => setval_fs <= X"000BCBE";	--3600Hz
			when "0100101" => setval_fs <= X"000C1FD";	--3700Hz
			when "0100110" => setval_fs <= X"000C73B";	--3800Hz
			when "0100111" => setval_fs <= X"000CC79";	--3900Hz
			when "0101000" => setval_fs <= X"000D1B7";	--4000Hz
			when "0101001" => setval_fs <= X"000D6F5";	--4100Hz
			when "0101010" => setval_fs <= X"000DC33";	--4200Hz
			when "0101011" => setval_fs <= X"000E172";	--4300Hz
			when "0101100" => setval_fs <= X"000E6B0";	--4400Hz
			when "0101101" => setval_fs <= X"000EBEE";	--4500Hz
			when "0101110" => setval_fs <= X"000F12C";	--4600Hz
			when "0101111" => setval_fs <= X"000F66A";	--4700Hz
			when "0110000" => setval_fs <= X"000FBA9";	--4800Hz
			when "0110001" => setval_fs <= X"00100E7";	--4900Hz
			when "0110010" => setval_fs <= X"0010625";	--5000Hz
			when "0110011" => setval_fs <= X"0010B63";	--5100Hz
			when "0110100" => setval_fs <= X"00110A1";	--5200Hz
			when "0110101" => setval_fs <= X"00115DF";	--5300Hz
			when "0110110" => setval_fs <= X"0011B1E";	--5400Hz
			when "0110111" => setval_fs <= X"001205C";	--5500Hz
			when "0111000" => setval_fs <= X"001259A";	--5600Hz
			when "0111001" => setval_fs <= X"0012AD8";	--5700Hz
			when "0111010" => setval_fs <= X"0013016";	--5800Hz
			when "0111011" => setval_fs <= X"0013554";	--5900Hz
			when "0111100" => setval_fs <= X"0013A93";	--6000Hz
			when "0111101" => setval_fs <= X"0013FD1";	--6100Hz
			when "0111110" => setval_fs <= X"001450F";	--6200Hz
			when "0111111" => setval_fs <= X"0014A4D";	--6300Hz
			when "1000000" => setval_fs <= X"0014F8B";	--6400Hz
			when "1000001" => setval_fs <= X"00154CA";	--6500Hz
			when "1000010" => setval_fs <= X"0015A08";	--6600Hz
			when "1000011" => setval_fs <= X"0015F46";	--6700Hz
			when "1000100" => setval_fs <= X"0016484";	--6800Hz
			when "1000101" => setval_fs <= X"00169C2";	--6900Hz
			when "1000110" => setval_fs <= X"0016F00";	--7000Hz
			when "1000111" => setval_fs <= X"001743F";	--7100Hz
			when "1001000" => setval_fs <= X"001797D";	--7200Hz
			when "1001001" => setval_fs <= X"0017EBB";	--7300Hz
			when "1001010" => setval_fs <= X"00183F9";	--7400Hz
			when "1001011" => setval_fs <= X"0018937";	--7500Hz
			when "1001100" => setval_fs <= X"0018E75";	--7600Hz
			when "1001101" => setval_fs <= X"00193B4";	--7700Hz
			when "1001110" => setval_fs <= X"00198F2";	--7800Hz
			when "1001111" => setval_fs <= X"0019E30";	--7900Hz
			when "1010000" => setval_fs <= X"001A36E";	--8000Hz
			when "1010001" => setval_fs <= X"001A8AC";	--8100Hz
			when "1010010" => setval_fs <= X"001ADEB";	--8200Hz
			when "1010011" => setval_fs <= X"001B329";	--8300Hz
			when "1010100" => setval_fs <= X"001B867";	--8400Hz
			when "1010101" => setval_fs <= X"001BDA5";	--8500Hz
			when "1010110" => setval_fs <= X"001C2E3";	--8600Hz
			when "1010111" => setval_fs <= X"001C821";	--8700Hz
			when "1011000" => setval_fs <= X"001CD60";	--8800Hz
			when "1011001" => setval_fs <= X"001D29E";	--8900Hz
			when "1011010" => setval_fs <= X"001D7DC";	--9000Hz
			when "1011011" => setval_fs <= X"001DD1A";	--9100Hz
			when "1011100" => setval_fs <= X"001E258";	--9200Hz
			when "1011101" => setval_fs <= X"001E796";	--9300Hz
			when "1011110" => setval_fs <= X"001ECD5";	--9400Hz
			when "1011111" => setval_fs <= X"001F213";	--9500Hz
			when "1100000" => setval_fs <= X"001F751";	--9600Hz
			when "1100001" => setval_fs <= X"001FC8F";	--9700Hz
			when "1100010" => setval_fs <= X"00201CD";	--9800Hz
			when "1100011" => setval_fs <= X"002070C";	--9900Hz
			when "1100100" => setval_fs <= X"0020C4A";	--10kHz			
			when "1100101" => setval_fs <= X"00240B8";	--11kHz
			when "1100110" => setval_fs <= X"0027525";	--12kHz
			when "1100111" => setval_fs <= X"002A993";	--13kHz
			when "1101000" => setval_fs <= X"002DE01";	--14kHz
			when "1101001" => setval_fs <= X"003126F";	--15kHz
			when "1101010" => setval_fs <= X"00346DC";	--16kHz
			when "1101011" => setval_fs <= X"0037B4A";	--17kHz
			when "1101100" => setval_fs <= X"003AFB8";	--18kHz
			when "1101101" => setval_fs <= X"003E426";	--19kHz
			when "1101110" => setval_fs <= X"0041893";	--20kHz
			when "1101111" => setval_fs <= X"0051EB8";	--25kHz
			when "1110000" => setval_fs <= X"0068DB9";	--32kHz
			when "1110001" => setval_fs <= X"0083127";	--40kHz
			when "1110010" => setval_fs <= X"00902DE";	--44kHz
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
			when "0000" => setval_fc <= X"045A1CB";	--3.4kHz
			when "0001" => setval_fc <= X"0147AE1";	--1kHz
			when "0010" => setval_fc <= X"028F5C3";	--2kHz
			when "0011" => setval_fc <= X"03D70A4";	--3kHz
			when "0100" => setval_fc <= X"051EB85";	--4kHz
			when "0101" => setval_fc <= X"0666666";	--5kHz
			when "0110" => setval_fc <= X"07AE148";	--6kHz
			when "0111" => setval_fc <= X"08F5C29";	--7kHz
			when "1000" => setval_fc <= X"0A3D70A";	--8kHz
			when "1001" => setval_fc <= X"0B851EC";	--9kHz
			when "1010" => setval_fc <= X"0CCCCCD";	--10kHz
			when "1011" => setval_fc <= X"11EB852";	--14kHz
			when "1100" => setval_fc <= X"199999A";	--20kHz
			when "1101" => setval_fc <= X"4000000";	--50kHz
			when others => setval_fc <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

	--==========================================
	--Generate FCCLK signal by phase accumulator
	--==========================================
	process(clk,reset) begin
		if reset = '0' then
			fcreg <= "0000000000000000000000000000";
		elsif clk'event and clk='1' then
			fcreg <= fcreg + setval_fc;
		end if;
	end process;
	fcclk <= fcreg(27);

end rtl;
				
	