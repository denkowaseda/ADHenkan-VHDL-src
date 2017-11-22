Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY conv_disp_data IS
PORT(
	fscntq : in std_logic_vector(6 downto 0);
	fccntq : in std_logic_vector(3 downto 0);
	fsdata : out std_logic_vector(8 downto 0);
	fcdata : out std_logic_vector(8 downto 0));
END conv_disp_data;

ARCHITECTURE RTL OF conv_disp_data IS


begin

	process(fscntq) begin
		case fscntq is
			when "1100101" => fsdata <= "001101110";	--11kHz
			when "1100110" => fsdata <= "001111000";	--12kHz
			when "1100111" => fsdata <= "010000010";	--13kHz
			when "1101000" => fsdata <= "010001100";	--14kHz
			when "1101001" => fsdata <= "010010110";	--15kHz
			when "1101010" => fsdata <= "010100000";	--16kHz
			when "1101011" => fsdata <= "010101010";	--17kHz
			when "1101100" => fsdata <= "010110100";	--18kHz
			when "1101101" => fsdata <= "010111110";	--19kHz
			when "1101110" => fsdata <= "011001000";	--20kHz
			when "1101111" => fsdata <= "011111010";	--25kHz
			when "1110000" => fsdata <= "101000000";	--32kHz
			when "1110001" => fsdata <= "110010000";	--40kHz
			when "1110010" => fsdata <= "110111000";	--44kHz
			when others => fsdata <= "00"&fscntq;
		end case;
	end process;
	
	process (fccntq) begin
		case fccntq is
			when "0000" => fcdata <= "000100010";	--3.4kHz
			when "0001" => fcdata <= "000001010";	--1kHz
			when "0010" => fcdata <= "000010100";	--2kHz
			when "0011" => fcdata <= "000011110";	--3kHz
			when "0100" => fcdata <= "000101000";	--4kHz
			when "0101" => fcdata <= "000110010";	--5kHz
			when "0110" => fcdata <= "000111100";	--6kHz
			when "0111" => fcdata <= "001000110";	--7kHz
			when "1000" => fcdata <= "001010000";	--8kHz
			when "1001" => fcdata <= "001011010";	--9kHz
			when "1010" => fcdata <= "001100100";	--10kHz
			when "1011" => fcdata <= "010001100";	--14kHz
			when "1100" => fcdata <= "011001000";	--20kHz
			when others => fcdata <= "XXXXXXXXX";
		end case;
	end process;
	
end RTL;