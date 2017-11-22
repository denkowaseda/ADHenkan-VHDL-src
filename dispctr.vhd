Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY dispctr IS
PORT(
	RESET : IN std_logic;
	CLK : IN std_logic;
	SCCLK : IN std_logic;
	ATTDWN : IN std_logic;
	ATTUP : IN std_logic;
	FSDATA : IN std_logic_vector(8 downto 0);
	FCDATA : IN std_logic_vector(8 downto 0);
	COMSEL : OUT std_logic_vector(5 downto 0);
	LED : OUT std_logic_vector(7 downto 0));
END dispctr;

ARCHITECTURE RTL OF dispctr IS

component seven_segdec
	port (
		DIN   : in	std_logic_vector( 3 downto 0);
		DOUT  : out std_logic_vector( 7 downto 0));
end component;

component BcdDigit
    Port ( Clk :    in  STD_LOGIC;
           Init :   in  STD_LOGIC;
           DoneIn:  in  STD_LOGIC;
           ModIn :  in  STD_LOGIC;
           ModOut : out  STD_LOGIC;
           Q :      out  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal fs1stdig,fs2nddig,fs3rddig,fc1stdig,fc2nddig,fc3rddig : std_logic_vector(3 downto 0);
signal bcdo : std_logic_vector(3 downto 0);
signal selreg,muxsel : std_logic_vector(5 downto 0);
signal dout : std_logic_vector(7 downto 0);
signal shift_fsdata,shift_fcdata : std_logic_vector(8 downto 0);
signal count : std_logic_vector(3 downto 0);
signal shift_rst : std_logic_vector(1 downto 0);
signal done_node : std_logic;
signal modout0, modout1,modout2,modout3 : std_logic;
signal load : std_logic;
signal init,init_rst : std_logic;


begin
-- Call the three BcdDigit instance
BcdDigit0 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => shift_fsdata(8),
	ModOut => modout0,
	Q => fs1stdig
	);
BcdDigit1 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => modout0,
	ModOut => modout1,
	Q => fs2nddig
	);
BcdDigit2 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => modout1,
	ModOut => open,
	Q => fs3rddig
	);
BcdDigit3 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => shift_fcdata(8),
	ModOut => modout2,
	Q => fc1stdig
	);
BcdDigit4 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => modout2,
	ModOut => modout3,
	Q => fc2nddig
	);
BcdDigit5 : BcdDigit port map(
	Clk => clk,
	Init => init,
	DoneIn => done_node,
	ModIn => modout3,
	ModOut => open,
	Q => fc3rddig
	);

init_rst <= not shift_rst(0) and reset;
	
--Call the Seven Segment Decoder instance
seg1 : seven_segdec port map(DIN => bcdo,DOUT => dout);


-- Shift the binary data
process(reset,clk) begin
	if reset = '0' then
		shift_fsdata	 <= "000001010";
		shift_fcdata <= "000100010";
	elsif clk'event and clk='1' then
		if init='1' then
			shift_fsdata <= (others => '0');
			shift_fcdata <= (others => '0');
		else
			if load='1' then
				shift_fsdata <= FSDATA(8 downto 0);
				shift_fcdata <= FCDATA(8 downto 0);
			else
				shift_fsdata <= shift_fsdata(7 downto 0) & '0';
				shift_fcdata <= shift_fcdata(7 downto 0) & '0';
			end if;
		end if;
	end if;
end process;

process(clk) begin
	if clk'event and clk='1' then
		shift_rst <=shift_rst(0) & reset;
	end if;
end process;
 
-- Initialize the BcdDigit
init <= ATTUP or ATTDWN or init_rst;

process(clk) begin
	if clk'event and clk='1' then
		load <= init;
	end if;
end process;

process(clk) begin
	if clk'event and clk='1' then
			if load='1' then
				count <= (others => '0');
				done_node <= '0';
			elsif count = "1000" then
				count <= count;
				done_node <= '1';
			else
				count <= count + '1';
				done_node <= '0';
			end if;
	end if;
end process;

--Circular shift register
process(RESET,SCCLK) begin
	if RESET = '0' then
		selreg <= "000001";
	elsif(SCCLK'event and SCCLK='1') then
		selreg(0) <= selreg(5);
		selreg(1) <= selreg(0);
		selreg(2) <= selreg(1);
		selreg(3) <= selreg(2);
		selreg(4) <= selreg(3);
		selreg(5) <= selreg(4);
	end if;
end process;

--Digit select signal
COMSEL(0) <= not selreg(0);
COMSEL(1) <= not selreg(1);
COMSEL(2) <= not selreg(2);
COMSEL(3) <= not selreg(3);
COMSEL(4) <= not selreg(4);
COMSEL(5) <= not selreg(5);

--BCD data select signal
muxsel(0) <= selreg(0);
muxsel(1) <= selreg(1);
muxsel(2) <= selreg(2);
muxsel(3) <= selreg(3);
muxsel(4) <= selreg(4);
muxsel(5) <= selreg(5);
 

process(muxsel,fs1stdig,fs2nddig,fs3rddig,fc1stdig,fc2nddig,fc3rddig)begin
	case muxsel is
		when "000001" => bcdo <= fs1stdig;
		when "000010" => bcdo <= fs2nddig;
		when "000100" => bcdo <= fs3rddig;
		when "001000" => bcdo <= fc1stdig;
		when "010000" => bcdo <= fc2nddig;
		when "100000" => bcdo <= fc3rddig;
		when others => bcdo <= "0000";
	end case;
end process;

	LED <= dout;

end RTL;