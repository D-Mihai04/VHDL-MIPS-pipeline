


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity mpg is
  Port (
  clk : in std_logic;
  btn : in std_logic;
  enable : out std_logic);
end mpg;

architecture Behavioral of mpg is
signal cnt : std_logic_vector(15 downto 0);
signal q1 : std_logic;
signal q2 : std_logic;
signal q3 : std_logic;
begin

process(clk)
begin
    if rising_edge(clk) then
    cnt <= cnt + 1;
    end if;
end process;

process(clk, cnt)
begin
    if rising_edge(clk) then
        if cnt = "1111111111111111" then
        q1 <= btn;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
    q2 <= q1;
    end if;
end process;

process(clk)
    begin
    if rising_edge(clk) then
    q3 <= q2;
end if;

enable <= not(q3) and q2;
end process;
end Behavioral;
