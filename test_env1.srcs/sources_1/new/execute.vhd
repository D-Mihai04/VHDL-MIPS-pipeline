
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity execute is
    Port (
        next_instruction : in  std_logic_vector(15 downto 0);
        rd1              : in  std_logic_vector(15 downto 0);
        alu_src          : in  std_logic;
        rd2              : in  std_logic_vector(15 downto 0);
        ext_imm          : in  std_logic_vector(15 downto 0);
        sa               : in  std_logic;
        func             : in  std_logic_vector(2 downto 0);
        alu_op           : in  std_logic_vector(2 downto 0);
        branch_address   : out std_logic_vector(15 downto 0);
        alu_res          : out std_logic_vector(15 downto 0);
        zero             : out std_logic
    );
end execute;

architecture Behavioral of execute is
    signal alu_ctrl    : std_logic_vector(2 downto 0);
    signal mux_operand : std_logic_vector(15 downto 0);
begin

    -- ALU 
    process(alu_op, func)
    begin
        case alu_op is
            when "001" =>
                case func is
                    when "000" => alu_ctrl <= "000";
                    when "001" => alu_ctrl <= "001";
                    when "010" => alu_ctrl <= "010";
                    when "011" => alu_ctrl <= "011";
                    when "100" => alu_ctrl <= "100";
                    when "101" => alu_ctrl <= "101";
                    when "110" => alu_ctrl <= "110";
                    when "111" => alu_ctrl <= "111";
                    when others => alu_ctrl <= "000";
                end case;
            when "010" => alu_ctrl <= "000";
            when "011" => alu_ctrl <= "001";
            when "000" => alu_ctrl <= "010";
            when "100" => alu_ctrl <= "011";
            when others => alu_ctrl <= "000";
        end case;
    end process;

    -- ALU selection
    mux_operand <= rd2 when alu_src = '0' else ext_imm;

    -- ALU operations
    process(rd1, mux_operand, alu_ctrl, sa)
    begin
        zero <= '0';
        case alu_ctrl is
            when "000" => 
                alu_res <= rd1 + mux_operand;

            when "001" => 
                alu_res <= rd1 - mux_operand;
                if rd1 = mux_operand then
                    zero <= '1';
                else
                    zero <= '0';
                end if;

            when "010" => 
                alu_res <= rd1 and mux_operand;

            when "011" => 
                alu_res <= rd1 or mux_operand;

            when "100" => 
                alu_res <= rd1 xor mux_operand;

            when "101" =>
                if sa = '1' then
                    alu_res <= rd2(14 downto 0) & '0';
                else
                    alu_res <= rd2;
                end if;

            when "110" =>
                if sa = '1' then
                    alu_res <= '0' & rd1(15 downto 1);
                else
                    alu_res <= rd1;
                end if;

            when "111" =>
                case mux_operand(1 downto 0) is
                    when "00" => alu_res <= rd1;
                    when "01" => alu_res <= rd1(14 downto 0) & '0';
                    when "10" => alu_res <= rd1(13 downto 0) & "00";
                    when "11" => alu_res <= rd1(12 downto 0) & "000";
                    when others => alu_res <= rd1;
                end case;

            when others =>
                alu_res <= (others => '0');
        end case;
    end process;

   
    branch_address <= ext_imm(13 downto 0) + next_instruction;

end Behavioral;
