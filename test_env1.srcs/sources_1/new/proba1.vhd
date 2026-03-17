
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity main is
 port (
 clk : in std_logic;
 btn : in std_logic_vector(4 downto 0);
 sw : in std_logic_vector(15 downto 0);
 led : out std_logic_vector(15 downto 0);
 an : out std_logic_vector(3 downto 0);
 cat : out std_logic_vector(6 downto 0)
 );
end entity main;

architecture behavioral of main is

signal cnt : std_logic_vector(3 downto 0):= (others => '0');
signal enable : std_logic;
signal digits : std_logic_vector(15 downto 0) := (others => '0');
signal rom_output : std_logic_vector(15 downto 0);
signal A : std_logic_vector(15 downto 0) := (others => '0');
signal B : std_logic_vector(15 downto 0) := (others => '0');
signal rst : std_logic;
signal ram_input : std_logic_vector(15 downto 0);
signal ram_output : std_logic_vector(15 downto 0);
signal instr : std_logic_vector(15 downto 0);
signal next_instr : std_logic_vector(15 downto 0);

signal reg_dst : std_logic;
signal ext_op :  std_logic;
signal reg_write :  std_logic;
signal alu_src :  std_logic;
signal alu_op :  std_logic_vector(2 downto 0);
signal branch :  std_logic;
signal jump :  std_logic;
signal mem_write :  std_logic;
signal memto_reg :  std_logic;

signal rd1 : std_logic_vector(15 downto 0);
signal rd2 : std_logic_vector(15 downto 0);
signal ext_imm : std_logic_vector(15 downto 0);
signal func : std_logic_vector(2 downto 0);
signal sa : std_logic;
signal alu_res : std_logic_vector(15 downto 0);
signal zero : std_logic;

signal branch_address : std_logic_vector(15 downto 0);
signal pc_src : std_logic;

signal mem_data : std_logic_vector(15 downto 0);
signal alu_out : std_logic_vector(15 downto 0);
signal write_data : std_logic_vector(15 downto 0);

signal jump_address : std_logic_vector(15 downto 0);

component mpg is
  Port (
  clk : in std_logic;
  btn : in std_logic;
  enable : out std_logic);
end component;

component reg_file is
port (
clk : in std_logic;
ra1 : in std_logic_vector (3 downto 0);
ra2 : in std_logic_vector (3 downto 0);
wa : in std_logic_vector (3 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0));
end component;

component ssd is
  Port (
  clk : in std_logic;
  digit0 : in std_logic_vector(3 downto 0);
  digit1 : in std_logic_vector(3 downto 0);
  digit2 : in std_logic_vector(3 downto 0);
  digit3 : in std_logic_vector(3 downto 0);
  an : out std_logic_vector(3 downto 0);
  cat : out std_logic_vector(6 downto 0));
end component;

component fetch is
  Port (clk : in std_logic;
        jump_address : in std_logic_vector(15 downto 0);
        branch_address : in std_logic_vector(15 downto 0);
        jump : in std_logic;
        pc_src : in std_logic;
        pc_en : in std_logic;
        pc_reset : in std_logic;
        instruction : out std_logic_vector(15 downto 0);
        next_instruction : out std_logic_vector(15 downto 0));
end component;

component decode is
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
end component;

component main_control is
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
end component;

component execute is
  Port (
  next_instruction : in std_logic_vector(15 downto 0);
  rd1 : in std_logic_vector(15 downto 0);
  alu_src : in std_logic;
  rd2 : in std_logic_vector(15 downto 0);
  ext_imm : in std_logic_vector(15 downto 0);
  sa : in std_logic;
  func : in std_logic_vector(2 downto 0);
  alu_op : in std_logic_vector(2 downto 0);
  branch_address : out std_logic_vector(15 downto 0);
  alu_res : out std_logic_vector(15 downto 0);
  zero : out std_logic
    );
end component;

component memory is
  Port (
  clk : in std_logic;
  alu_in : in std_logic_vector(15 downto 0);
  write_data : in std_logic_vector(15 downto 0);
  mem_write : in std_logic;
  mem_data : out std_logic_vector(15 downto 0);
  alu_out : out std_logic_vector(15 downto 0)
   );
end component;

begin

mpg_c: mpg port map(clk => clk, btn => btn(0), enable => enable);
jump_address <= next_instr(15 downto 13) & instr(12 downto 0);

fetch_c: fetch port map(clk => clk, jump_address => jump_address, branch_address => branch_address, jump => jump, pc_src => pc_src, 
    pc_en => enable, pc_reset => sw(2), instruction => instr, next_instruction => next_instr);
main_c: main_control port map(instr => instr, reg_dst => reg_dst, ext_op => ext_op, reg_write => reg_write,
    alu_src => alu_src, alu_op => alu_op, branch => branch, jump => jump, mem_write => mem_write, memto_reg => memto_reg);
decode_c: decode port map(clk => clk, reg_write => reg_write, reg_enable => enable, instruction => instr, reg_dst => reg_dst,
    write_data => write_data, ext_op => ext_op, rd1 => rd1, rd2 => rd2, ext_imm => ext_imm, func => func, sa => sa);
execute_c: execute port map(next_instruction => next_instr, rd1 => rd1, alu_src => alu_src, rd2 => rd2, ext_imm => ext_imm,
    sa => sa, func => func, alu_op => alu_op, branch_address => branch_address, alu_res => alu_res, zero => zero);
memory_c: memory port map(clk => clk, alu_in => alu_res, write_data => rd2, mem_write => mem_write, mem_data => mem_data, alu_out => alu_out);

pc_src <= branch and zero;
write_data <= mem_data when memto_reg = '1' else alu_out;

process(sw(7 downto 5), clk)
begin
case sw(7 downto 5) is
    when "000" => digits <= instr;
    when "001" => digits <= next_instr;
    when "010" => digits <= rd1;
    when "011" => digits <= rd2;
    when "100" => digits <= ext_imm;
    when "101" => digits <= alu_res;
    when "110" => digits <= mem_data;
    when "111" => digits <= write_data;
end case;
end process;

process(sw(0), clk)
begin
if sw(0) = '0' then
    led(0) <= reg_dst;
    led(1) <= ext_op;
    led(2) <= reg_write;
    led(3) <= alu_src;
    led(4) <= branch;
    led(5) <= jump;
    led(6) <= mem_write;
    led(7) <= memto_reg;
else
    led(0) <= alu_op(0);
    led(1) <= alu_op(1);
    led(2) <= alu_op(2);
    led(3) <= '0';
    led(4) <= '0';
    led(5) <= '0';
    led(6) <= '0';
    led(7) <= '0';
end if;
end process;

ssd_comp : ssd port map(clk => clk, digit0 => digits(3 downto 0), digit1 => digits(7 downto 4), digit2 => digits(11 downto 8), digit3 => digits(15 downto 12), an => an, cat => cat(6 downto 0));

end architecture behavioral;
