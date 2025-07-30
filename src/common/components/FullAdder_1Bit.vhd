-------------------------------------------------------------------------------
-- Module: FullAdder_1Bit
-- Description: 1-bit full adder; computes sum and carry-out from inputs and carry-in.
-- Author: Levy Elmescany
-- Date: 2025-07-24
-- License: MIT
-- Inputs: a, b, cin
-- Outputs: sum, cout
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: None.
-- Simulation: Functionally verified via simulation of ALU_32Bit using tb_ALU_32Bit
-- Revision History:
--   Rev 1.0 - 2025-07-24 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FullAdder_1Bit is
    port (
        a    : in  std_logic; -- 1st operand
        b    : in  std_logic; -- 2nd operand
        cin  : in  std_logic; -- carry-in
        sum  : out std_logic; -- result of the sum
        cout : out std_logic  -- carry-out
    );
end FullAdder_1Bit;
 
architecture rtl of FullAdder_1Bit is
begin
    -- Full adder sum and carry-out logic
    sum  <= a xor b xor cin;
    cout <= (a and b) or ((a xor b) and cin);
end rtl;