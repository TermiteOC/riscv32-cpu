-------------------------------------------------------------------------------
-- Module: ImmGen
-- Description:
--   - Sign-extended immediate value generator for instruction types:
--     - I-type (arithmetic instructions)
--     - B-type
-- Author: Levy Elmescany
-- Date: 2025-08-09
-- License: MIT
-- Inputs: inst
-- Outputs: imm
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - Received B-type instruction immediate is always multiple of two.
--   - If opcode is incompatible, defaults to '0'.
-- Simulation: Verified via tb_ImmGen
-- Revision History:
--   Rev 1.0 - 2025-08-09 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ImmGen is
    port (
        inst  : in  std_logic_vector(31 downto 0); -- instruction
        imm   : out std_logic_vector(31 downto 0)  -- sign-extended immediate value
    );
end ImmGen;

architecture rtl of ImmGen is
begin
    -- Combinational Logic
    process(inst)
    begin
        -- Builds sign-extended immediate value from immediate field in instruction for different opcodes
        case inst(6 downto 0) is
            -- I-type opcode
            when "0010011" =>
                imm(11 downto 0)  <= inst(31 downto 20);
                imm(31 downto 12) <= (others => inst(31));

            -- B-type opcode
            when "1100011" =>
                imm(11 downto 0)  <= inst(31) & inst(7) & inst(30 downto 25) & inst(11 downto 8);
                imm(31 downto 12) <= (others => inst(31));
            
            when others =>
                imm <= (others => '0');
        end case;
    end process;
end rtl;
