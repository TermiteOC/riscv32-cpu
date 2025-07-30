-------------------------------------------------------------------------------
-- Module: Adder_32Bit
-- Description: Adder composed of 32 instances of a 1-bit full adder with ripple-carry chaining.
-- Author: Levy Elmescany
-- Date: 2025-07-29
-- License: MIT
-- Inputs: a, b
-- Outputs: sum
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: None.
-- Simulation: Verified via tb_Adder_32Bit testbench
-- Revision History:
--   Rev 1.0 - 2025-07-29 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder_32Bit is
    port (
        a   : in  std_logic_vector(31 downto 0); -- 1st operand
        b   : in  std_logic_vector(31 downto 0); -- 2nd operand
        sum : out std_logic_vector(31 downto 0)  -- result of the sum
    );
end Adder_32Bit;

architecture rtl of Adder_32Bit is

    -- Full adder component
    component FullAdder_1Bit is
        port (
            a    : in  std_logic; -- 1st operand
            b    : in  std_logic; -- 2nd operand
            cin  : in  std_logic; -- carry-in
            sum  : out std_logic; -- result of the sum
            cout : out std_logic  -- carry-out
        );
    end component;

    -- Ripple-carry signal
    signal w_carry : std_logic_vector(32 downto 0);

begin
    -- Combinational Logic
    -- First carry-in is 0
    w_carry(0) <= '0';

    -- Component Instantiations
    -- Adder generate loop
    adder_bit_gen : for i in 0 to 31 generate
    begin
        full_adder_inst : FullAdder_1Bit
        port map (
            a    => a(i),
            b    => b(i),
            cin  => w_carry(i),
            sum  => sum(i),
            cout => w_carry(i+1)
        );
    end generate;
end rtl;