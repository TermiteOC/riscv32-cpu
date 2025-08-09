-------------------------------------------------------------------------------
-- Module: ShiftLeft1
-- Description: 32-bit binary shifter performing shift left by one bit.
-- Author: Levy Elmescany
-- Date: 2025-08-09
-- License: MIT
-- Inputs: d
-- Outputs: shifted
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: None.
-- Simulation: Verified via tb_ShiftLeft1
-- Revision History:
--   Rev 1.0 - 2025-08-09 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftLeft1 is
    port (
        d     : in  std_logic_vector(31 downto 0);   -- data input
        shifted : out std_logic_vector(31 downto 0)  -- shifted output
    );
end ShiftLeft1;

architecture rtl of ShiftLeft1 is
begin
    -- Combinational Logic
    -- Shifts all input bits left by 1, excludes MSB, and sets LSB as 0
    shifted(31 downto 1) <= d(30 downto 0);
    shifted(0) <= '0';
end rtl;