


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity memory is
  Port (
  clk : in std_logic;
  alu_in : in std_logic_vector(15 downto 0);
  write_data : in std_logic_vector(15 downto 0);
  mem_write : in std_logic;
  mem_data : out std_logic_vector(15 downto 0);
  alu_out : out std_logic_vector(15 downto 0)
   );
end memory;

architecture Behavioral of memory is
type ram_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal ram : ram_array := (others => x"0000");

begin
process(clk, mem_write)
begin
if rising_edge(clk) then
if mem_write='1' then
ram(conv_integer(alu_in(7 downto 0))) <= write_data;
end if;
end if;
mem_data <= ram(conv_integer(alu_in(7 downto 0)));
end process;

alu_out <= alu_in;
end Behavioral;
