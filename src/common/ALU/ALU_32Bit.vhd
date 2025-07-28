-------------------------------------------------------------------------------
-- Module: ALU_32Bit
-- Description: 
--   - 32-bit ALU supports AND, OR, ADD, SUB, NOR, NAND, SLT operations.
--   - Provides zero flag output that can be used externally for conditional branching.
--   - Composed of 32 instances of a 1-bit ALU with ripple-carry chaining.
-- Author: Levy Elmescany
-- Date: 2025-07-26
-- License: MIT
-- Inputs: a, b, op
-- Outputs: zero, res
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes:
--   - The ALU operation control line is a combination of the following lines:
--     - Bit 3: a_invert
--     - Bit 2: b_invert
--     - Bit 1-0: 2-bit operation (00=AND, 01=OR, 10=ADD/SUB, 11=SLT)
--   - The structure of the operation selector is {a_invert, b_invert, op}.
--   - The first carry-in is set to 1 only in the SLT and SUB operations.
--   - The MSB set output is the LSB less input in a SLT operation.
--   - Zero flag is high when res = x"00000000"
-- Simulation:
-- Revision History:
--   Rev 1.0 - 2025-07-26 - Initial implementation
--   Rev 1.1 - 2025-07-27 - Fixed syntax errors and unconstrained array comparison
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_32Bit is
    port (
        a    : in  std_logic_vector(31 downto 0); -- 1st operand
        b    : in  std_logic_vector(31 downto 0); -- 2nd operand
        op   : in  std_logic_vector(3 downto 0);  -- operation selector
        zero : out std_logic;                     -- zero flag
        res  : out std_logic_vector(31 downto 0)  -- result
    );
end ALU_32Bit;

architecture rtl of ALU_32Bit is

    -- 1-bit ALU component *****
    component ALU_1Bit is
        port (
            a        : in  std_logic;                    -- 1st operand
            b        : in  std_logic;                    -- 2nd operand
            cin      : in  std_logic;                    -- carry-in
            less     : in  std_logic;                    -- value if a is less than b (LSB)
            a_invert : in  std_logic;                    -- inverted a selector
            b_invert : in  std_logic;                    -- inverted b selector
            op       : in  std_logic_vector(1 downto 0); -- operation selector
            res      : out std_logic;                    -- result
            cout     : out std_logic;                    -- carry-out from adder
            set      : out std_logic                     -- sets value if a is less than b (MSB)
        );
    end component;

    -- Ripple-carry signal
    signal w_carry : std_logic_vector(32 downto 0);
    
    -- Set less than signals
    signal w_set_out : std_logic_vector(31 downto 0);
    signal w_less_in : std_logic_vector(31 downto 0);

begin
    -- Combinational Logic
    -- Zero flag is high when the ALU result equals 0
    zero <= '1' when res = (31 downto 0 => '0') else '0';
    
    -- SLT and SUB operations first carry-in equals 1
    w_carry(0) <= '1' when op = "0111" or op = "0110" else '0';

    -- Assign LSB less input as MSB set output
    w_less_in(31 downto 1) <= (others => '0');
    w_less_in(0) <= w_set_out(31);

    -- Component Instatiations
    -- ALU generate loop
    alu_bit_gen : for i in 0 to 31 generate
    begin
        alu_inst : ALU_1Bit
        port map (
            a        => a(i),
            b        => b(i),
            cin      => w_carry(i),
            less     => w_less_in(i),
            a_invert => op(3),
            b_invert => op(2),
            op       => op(1 downto 0),
            res      => res(i),
            cout     => w_carry(i+1),
            set      => w_set_out(i)
        );
    end generate;
end rtl;
