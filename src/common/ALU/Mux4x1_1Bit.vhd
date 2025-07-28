-------------------------------------------------------------------------------
-- Module: Mux4x1_1Bit
-- Description: 1-bit 4-to-1 multiplexer; chooses an output from 4 different ones based on selector.
-- Author: Levy Elmescany
-- Date: 2025-07-24
-- License: MIT
-- Inputs: sel, inputs
-- Outputs: output
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: If selector chooses an invalid input, defaults to '0'.
-- Simulation: None (to be tested via ALU_32Bit simulation)
-- Revision History:
--   Rev 1.0 - 2025-07-24 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux4x1_1Bit is
    port (
        sel    : in  std_logic_vector(1 downto 0); -- selector
        inputs : in  std_logic_vector(3 downto 0); -- 4 inputs
        output : out std_logic;                    -- 1 output
    );
end Mux4x1_1Bit;

architecture rtl of Mux4x1_1Bit is
begin
    process(sel, inputs)
    begin
        -- Select one input based on sel, default output '0' for invalid selectors
        case sel is
            when "00" =>
                output <= inputs(0);
            when "01" =>
                output <= inputs(1);
            when "10" =>
                output <= inputs(2);
            when "11" =>
                output <= inputs(3);
            when others =>
                output <= '0';
        end case;
    end process;
end rtl;