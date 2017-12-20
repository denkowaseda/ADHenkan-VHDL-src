library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nlsw is
     port( swo :   in   std_logic_vector(1 downto 0);
           reset : in   std_logic;
           nlon :  out  std_logic );
end nlsw;

architecture RTL of nlsw is

signal reg_nlon : std_logic :='0';
signal int_swo : std_logic ;

begin
    nlon <= reg_nlon;
    int_swo <= swo(1);
    process( int_swo, reset) begin
      if(reset = '0') then
         reg_nlon <= '0';
      elsif( int_swo'event and int_swo='1') then 
         reg_nlon<= not reg_nlon; 
      end if;
    end process;
end RTL;

