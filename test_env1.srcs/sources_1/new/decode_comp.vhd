----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 08:18:48 AM
-- Design Name: 
-- Module Name: decode_comp - Behavioral
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

entity decode is
  Port (
    clk : in std_logic;
    reg_write : in std_logic;
    reg_enable : in std_logic;
    instruction : in std_logic_vector(15 downto 0);
    reg_dst : in std_logic;
    write_data : in std_logic_vector(15 downto 0);
    ext_op : in std_logic;
    rd1 : out std_logic_vector(15 downto 0);
    rd2 : out std_logic_vector(15 downto 0);
    ext_imm : out std_logic_vector(15 downto 0);
    func : out std_logic_vector(2 downto 0);
    sa : out std_logic);
end decode;

architecture Behavioral of decode is
component reg_file is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
en : in std_logic;
write_data : in std_logic_vector (15 downto 0);
reg_write : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component;

signal mux_output : std_logic_vector(2 downto 0);

begin
mux_output <= instruction(9 downto 7) when reg_dst='0' else instruction(6 downto 4);

reg : reg_file port map(clk => clk, ra1 => instruction(12 downto 10), ra2 => instruction(9 downto 7), 
    wa => mux_output, en => reg_enable, write_data => write_data, reg_write => reg_write, 
    rd1 => rd1, rd2 => rd2);

ext_imm(15 downto 7) <= (others => '0') when ext_op = '0' else (others => instruction(6));
ext_imm(6 downto 0) <= instruction(6 downto 0);

func <= instruction(2 downto 0);
sa <= instruction(3);
end Behavioral;
