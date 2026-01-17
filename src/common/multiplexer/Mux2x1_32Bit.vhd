-------------------------------------------------------------------------------
-- Module: Mux2x1_32Bit
-- Description: 32-bit 2-to-1 multiplexer; chooses an output from 2 different ones based on selector.
-- Author: Levy Elmescany
-- Date: 2025-07-30
-- License: MIT
-- Inputs: a, b, sel
-- Outputs: res
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: If selector chooses an invalid input, defaults to 0.
-- Simulation: Verified via tb_Mux2x1_32Bit
-- Revision History:
--   Rev 1.0 - 2025-07-30 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux2x1_32Bit is
    port (
        a      : in  std_logic_vector(31 downto 0); -- 1st input
        b      : in  std_logic_vector(31 downto 0); -- 2nd input
        sel    : in  std_logic;                     -- selector
        res    : out std_logic_vector(31 downto 0)  -- chosen output
    );
end Mux2x1_32Bit;
 
architecture rtl of Mux2x1_32Bit is
begin
    process(a, b, sel)
    begin
        -- Select one input based on sel, default output '0' for invalid selectors
        case sel is
            when '0' =>
                res <= a;
            when '1' =>
                res <= b;
            when others =>
                res <= (others => '0');
        end case;
    end process;
end rtl;