-------------------------------------------------------------------------------
-- Module: Mux32x1_32Bit
-- Description: 32-bit 32-to-1 multiplexer; chooses an output from 32 different ones based on selector.
-- Author: Levy Elmescany
-- Date: 2025-08-02
-- License: MIT
-- Inputs: inputs, sel
-- Outputs: res
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: If selector chooses an invalid input, defaults to 0.
-- Simulation: Verified via tb_RegFile
-- Revision History:
--   Rev 1.0 - 2025-08-02 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CommonTypes.all; -- Import type WordArray_t (array(0 to 31) of std_logic_vector(31 downto 0))

entity Mux32x1_32Bit is
    port (
        inputs : in  WordArray_t;                   -- input array
        sel    : in  std_logic_vector(4 downto 0);  -- selector
        res    : out std_logic_vector(31 downto 0)  -- selected output
    );
end Mux32x1_32Bit;
 
architecture rtl of Mux32x1_32Bit is
begin
    process(inputs, sel)
    begin
        -- Select one input based on sel, default output '0' for invalid selectors
        if unsigned(sel) < 32 then
            res <= inputs(to_integer(unsigned(sel)));
        else
            res <= (others => '0');
        end if;
    end process;
end rtl;