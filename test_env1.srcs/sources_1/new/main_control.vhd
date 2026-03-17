----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 09:35:39 AM
-- Design Name: 
-- Module Name: main_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_control is
  Port (
    instr : in std_logic_vector(15 downto 0);
    reg_dst : out std_logic;
    ext_op : out std_logic;
    reg_write : out std_logic;
    alu_src : out std_logic;
    alu_op : out std_logic_vector(2 downto 0);
    branch : out std_logic;
    jump : out std_logic;
    mem_write : out std_logic;
    memto_reg : out std_logic);
end main_control;

architecture Behavioral of main_control is

begin
process(instr(15 downto 0))
begin
reg_dst <= '0';
ext_op <= '0';
reg_write <= '0';
alu_src <= '0';
alu_op <= "000";
branch <= '0';
jump <= '0';
mem_write <= '0';
memto_reg <= '0';

case instr(15 downto 13) is
when "000" => reg_dst <= '1'; reg_write <= '1'; alu_op <= "001";
when "001" => reg_write <= '1'; alu_src <= '1'; ext_op <= '1'; alu_op <= "010";
when "010" => reg_write <= '1'; alu_src <= '1'; ext_op <= '1'; alu_op <= "010"; memto_reg <= '1';
when "011" => alu_src <= '1'; ext_op <= '1'; alu_op <= "010"; mem_write <= '1';
when "100" => ext_op <= '1'; alu_op <= "011"; branch <= '1';
when "101" => reg_write <= '1'; alu_src <= '1'; alu_op <= "000";
when "110" => reg_write <= '1'; alu_src <= '1'; alu_op <= "100";
when "111" => jump <= '1';
when others => jump <= '1';
end case;
end process;

end Behavioral;
