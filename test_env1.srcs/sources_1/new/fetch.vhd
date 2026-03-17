
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fetch is
  Port (
        clk : in std_logic;
        jump_address : in std_logic_vector(15 downto 0);
        branch_address : in std_logic_vector(15 downto 0);
        jump : in std_logic;
        pc_src : in std_logic;
        pc_en : in std_logic;
        pc_reset : in std_logic;
        instruction : out std_logic_vector(15 downto 0);
        next_instruction : out std_logic_vector(15 downto 0));
end fetch;

architecture Behavioral of fetch is
type rom_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom : rom_array := ( B"001_000_001_0000101", --addi $1 $0 5
                           B"001_000_010_0000110", --addi $2 $0 6
                           B"000_001_010_011_0_000", --add $3 $1 $2
                           B"001_011_011_0000001", --addi $3 $3 1
                           B"000_010_001_100_0_100", --xor $4 $2 $1
                           B"101_001_011_0001010", --andi $3 $1 10
                           B"000_000_011_100_1_101", --sll $4 $3 1
                           B"011_001_100_0001010", --sw $4 10($1)
                           B"010_001_101_0001010", --lw $5 10($1)
                           B"000_101_010_110_0_001", --sub $6 $5 $2
                           B"100_011_101_0000001", --beq $3 $5 1
                           B"111_0000000001000", --j 8
                           B"001_000_110_0000010", --addi $6 $0 2
                           B"000_001_011_010_0_111", --sllv $2 $3 $1
                           B"001_000_011_0000101", --addi $3 $0 5 
                           others => x"0000");
signal pc_input : std_logic_vector(15 downto 0);
signal pc_output : std_logic_vector(15 downto 0);
signal adder_output : std_logic_vector(15 downto 0);
signal mux1_output : std_logic_vector(15 downto 0);
begin

process(clk) 
begin
    if(pc_reset = '1') then
        pc_output <= (others => '0');
    else
        if(rising_edge(clk)) then
            if(pc_en = '1') then
                pc_output <= pc_input;
            end if;
        end if;
    end if;
end process;

instruction <= rom(conv_integer(pc_output(7 downto 0)));
adder_output <= pc_output + 1;
next_instruction <= adder_output;

process(pc_src) 
begin
    if(pc_src = '1') then
        mux1_output <= branch_address;
    else 
        mux1_output <= adder_output;
    end if;
end process;

process(jump)
begin
    if(jump = '1') then
        pc_input <= jump_address;
    else
        pc_input <= mux1_output;
    end if;
end process;
end Behavioral;
