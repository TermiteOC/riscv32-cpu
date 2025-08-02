-------------------------------------------------------------------------------
-- Module: RegDecoder
-- Description: 5-to-32 one-hot decoder.
-- Author: Levy Elmescany
-- Date: 2025-08-02
-- License: MIT
-- Inputs: code
-- Outputs: decode
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: Sets the bit corresponding to the input code to '1', all other bits are '0'.
-- Simulation: Verified via tb_RegFile
-- Revision History:
--   Rev 1.0 - 2025-08-02 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegDecoder is
    port (
        code   : in  std_logic_vector(4 downto 0);  -- selector
        decode : out std_logic_vector(31 downto 0)  -- one-hot output
    );
end RegDecoder;

architecture rtl of RegDecoder is
begin
    process(code)
    begin
        -- Default: all outputs low
        decode <= (others => '0');

        -- Set only the bit corresponding to code value
        decode(to_integer(unsigned(code))) <= '1';
    end process;
end rtl;