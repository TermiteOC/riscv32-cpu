-------------------------------------------------------------------------------
-- Module: ALUControl
-- Description: Control unit responsible for ALU control line selection
-- Author: Levy Elmescany
-- Date: 2026-01-03
-- License: MIT
-- Inputs: alu_op, f7, f3
-- Outputs: sel
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes:
--   - Funct7 field from the instruction is 7 bits wide (instruction[31:25]), 
--     but only the bit 30 (funct7[5]) is relevant to distinguish ADD from SUB
--     in R-type instructions
--   - alu_op encoding:
--     - 00 -> Load / Store
--     - 01 -> Branch (BEQ)
--     - 10 -> R-type instruction
--     - 11 -> I-type instruction
-- Simulation: Verified via tb_ALUControl testbench
-- Revision History:
--   Rev 1.0 - 2026-01-03 - Initial implementation
--   Rev 1.1 - 2026-01-16 - Fixed wrong SLT operation encoding
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUControl is
    port (
        alu_op : in  std_logic_vector(1 downto 0); -- main control generated bits
        f7     : in  std_logic;                    -- funct7[5] / instruction[30]
        f3     : in  std_logic_vector(2 downto 0); -- funct3 field from instruction
        sel     : out std_logic_vector(3 downto 0) -- selected alu control lines
    );
end ALUControl;

architecture rtl of ALUControl is

    -- ALU operation encoding
    constant ALU_AND     : std_logic_vector(3 downto 0) := "0000";
    constant ALU_OR      : std_logic_vector(3 downto 0) := "0001";
    constant ALU_ADD     : std_logic_vector(3 downto 0) := "0010";
    constant ALU_SLT     : std_logic_vector(3 downto 0) := "0111";
    constant ALU_SUB     : std_logic_vector(3 downto 0) := "0110";
    constant ALU_DEFAULT : std_logic_vector(3 downto 0) := "1111";

begin
    -- Combinational Logic
    process(all)
    begin
        case alu_op is
            -- Load or store instruction
            when "00" =>
                case f3 is
                    when "010" =>
                        sel <= ALU_ADD; -- ALU performs addition to find rs1 + immediate
                    
                    when others =>
                        sel <= ALU_DEFAULT;
                end case;

            -- Branch if equal instruction
            when "01" =>
                case f3 is
                    when "000" =>
                        sel <= ALU_SUB; -- ALU performs subtraction for comparison purposes (zero flag assertion)
                    
                    when others =>
                        sel <= ALU_DEFAULT;
                end case;

            -- R-type instructions depend on both funct7 and funct3 fields from instruction
            when "10" =>
                if f7 = '0' then
                    case f3 is
                        when "000" =>
                            sel <= ALU_ADD;

                        when "010" =>
                            sel <= ALU_SLT;

                        when "110" =>
                            sel <= ALU_OR;

                        when "111" =>
                            sel <= ALU_AND;

                        when others =>
                            sel <= ALU_DEFAULT;
                    end case;
                else
                    -- funct7 field bit differentiates ADD (0) from SUB (1) when funct3 = 000 in R-type instructions
                    if f3 = "000" then
                        sel <= ALU_SUB;
                    else
                        sel <= ALU_DEFAULT;
                    end if;
                end if;

            -- I-type instructions depend only on funct3 field from instruction
            when "11" =>
                case  f3 is
                    when "000" =>
                        sel <= ALU_ADD;

                    when "110" =>
                        sel <= ALU_OR;

                    when "111" =>
                        sel <= ALU_AND;

                    when others =>
                        sel <= ALU_DEFAULT;
                end case;

            when others =>
                sel <= ALU_DEFAULT;
        end case;
    end process;
end rtl;
