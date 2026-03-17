
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ssd is
  Port (
  clk : in std_logic;
  digit0 : in std_logic_vector(3 downto 0);
  digit1 : in std_logic_vector(3 downto 0);
  digit2 : in std_logic_vector(3 downto 0);
  digit3 : in std_logic_vector(3 downto 0);
  an : out std_logic_vector(3 downto 0);
  cat : out std_logic_vector(6 downto 0));
end ssd;

architecture Behavioral of ssd is
signal sel : std_logic_vector(1 downto 0);
signal mux_out : std_logic_vector(3 downto 0);
signal cnt : std_logic_vector(15 downto 0);
begin

process(clk)
begin
if rising_edge(clk) then
cnt <= cnt + 1;
end if;
end process;

sel <= cnt(15 downto 14);

process(sel, digit0, digit1, digit2, digit3)
begin
case sel is
when "00" => mux_out <= digit0;
when "01" => mux_out <= digit1;
when "10" => mux_out <= digit2;
when others => mux_out <= digit3;
end case;
end process;

process(mux_out)
begin
case mux_out is
  when "0001" => cat <= "1111001";   
  when "0010" => cat <= "0100100";   
  when "0011" => cat <= "0110000";   
  when "0100"  => cat <= "0011001";   
  when "0101" => cat <= "0010010" ;   
  when "0110" => cat <= "0000010" ;   
  when "0111" => cat <= "1111000" ;   
  when "1000" => cat <= "0000000" ;   
  when "1001" => cat <= "0010000" ;   
  when "1010" => cat <= "0001000" ;   
  when "1011" => cat <= "0000011" ;   
  when "1100" => cat <= "1000110" ;   
  when "1101" => cat <= "0100001" ;   
  when "1110" => cat <= "0000110" ;   
  when "1111" => cat <= "0001110" ;  
  when others => cat <= "1000000" ;  
  end case;
end process;

process(sel)
begin
case sel is
when "00" => an <= "1110";
when "01" => an <= "1101";
when "10" => an <= "1011";
when others => an <= "0111";
end case;
end process;

end Behavioral;
