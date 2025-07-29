-------------------------------------------------------------------------------
-- Module: tb_ALU_32Bit
-- Description: 
--   - Testbench for ALU_32Bit.
--   - Simulates AND, OR, ADD, SUB, NOR, NAND, SLT operations and zero flag.
-- Author: Levy Elmescany
-- Date: 2025-07-27
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for AND, OR, ADD, SUB, NOR, NAND, SLT.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-07-27 - Initial testbench implementation
--   Rev 1.1 - 2025-07-28 - Fixed incorrect operation encoding for SUB and SLT operations
--   Rev 1.2 - 2025-07-29 - Corrected expected result in one SUB assertion and expected zero flag in one SLT assertion;
--                          changed architecture name
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALU_32Bit is
end tb_ALU_32Bit;

architecture behavioral of tb_ALU_32Bit is

    -- Operation selector encoding
    constant OP_AND  : std_logic_vector(3 downto 0) := "0000";
    constant OP_OR   : std_logic_vector(3 downto 0) := "0001";
    constant OP_ADD  : std_logic_vector(3 downto 0) := "0010";
    constant OP_SUB  : std_logic_vector(3 downto 0) := "0110";
    constant OP_NOR  : std_logic_vector(3 downto 0) := "1100";
    constant OP_NAND : std_logic_vector(3 downto 0) := "1101";
    constant OP_SLT  : std_logic_vector(3 downto 0) := "0111";

    component ALU_32Bit is
        port (
            a    : in  std_logic_vector(31 downto 0); -- 1st operand
            b    : in  std_logic_vector(31 downto 0); -- 2nd operand
            op   : in  std_logic_vector(3 downto 0);  -- operation selector
            zero : out std_logic;                     -- zero flag
            res  : out std_logic_vector(31 downto 0) -- result
        );
    end component;
  
    -- DUT signals
    signal w_a    : std_logic_vector(31 downto 0);
    signal w_b    : std_logic_vector(31 downto 0);
    signal w_op   : std_logic_vector(3 downto 0);
    signal w_zero : std_logic;
    signal w_res  : std_logic_vector(31 downto 0);

begin
    -- DUT connection
    dut : ALU_32Bit
    port map (
        a    => w_a,
        b    => w_b,
        op   => w_op,
        zero => w_zero,
        res  => w_res
    );

    -- Stimulus process
    process
    begin

    -- Test ADD operation: 10 + 5 = 15
    w_op <= OP_ADD;
    w_a  <= std_logic_vector(to_signed(10, 32)); -- 10 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(5, 32));  -- 5 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(15, 32)) and w_zero = '0')
    report "Error: ADD 10 + 5 failed - Expected result = 15, zero flag = 0" severity error;

    -- Test ADD operation: -70 + 70 = 0
    w_op <= OP_ADD;
    w_a  <= std_logic_vector(to_signed(-70, 32)); -- -70 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(70, 32));  -- 70 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(0, 32)) and w_zero = '1')
    report "Error: ADD -70 + 70 failed - Expected result = 0, zero flag = 1" severity error;

    -- Test SUB operation: -100 - 100 = 0
    w_op <= OP_SUB;
    w_a  <= std_logic_vector(to_signed(-100, 32)); -- -100 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(100, 32));  -- 100 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(-200, 32)) and w_zero = '0')
    report "Error: SUB -100 - 100 failed - Expected result = -200, zero flag = 0" severity error;

    -- Test SUB operation: 16 AND 7 = 0
    w_op <= OP_SUB;
    w_a  <= std_logic_vector(to_signed(16, 32)); -- 16 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(7, 32));  -- 7 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(9, 32)) and w_zero = '0')
    report "Error: SUB 16 - 7 failed - Expected result = 9, zero flag = 0" severity error;

    -- Test AND operation: 0x0FF0FF0F AND 0x0F000FFF = 0x0F000F0F
    w_op <= OP_AND;
    w_a  <= x"0FF0FF0F";
    w_b  <= x"0F000FFF";
    wait for 1 ns;
    assert (w_res = x"0F000F0F" and w_zero = '0')
    report "Error: AND 0x0FF0FF0F AND 0x0F000FFF failed - Expected result = 0x0F000F0F, zero flag = 0" severity error;

    -- Test OR operation: 0xF00F00F0 OR 0xF0FFF000 = 0xF0FFF0F0
    w_op <= OP_OR;
    w_a  <= x"F00F00F0";
    w_b  <= x"F0FFF000";
    wait for 1 ns;
    assert (w_res = x"F0FFF0F0" and w_zero = '0')
    report "Error: OR 0xF00F00F0 OR 0xF0FFF000 failed - Expected result = 0xF0FFF0F0, zero flag = 0" severity error;

    -- Test NOR operation: 0x0000FFFF NOR 0x0F000FFF = 0xF0FF0000
    w_op <= OP_NOR;
    w_a  <= x"0000FFFF";
    w_b  <= x"0F000FFF";
    wait for 1 ns;
    assert (w_res = x"F0FF0000" and w_zero = '0')
    report "Error: NOR 0x0000FFFF NOR 0x0F000FFF failed - Expected result = 0xF0FF0000, zero flag = 0" severity error;

    -- Test NAND operation: 0xFFFFFFFF NAND 0x0FF0F00F = 0xF00F0FF0
    w_op <= OP_NAND;
    w_a  <= x"FFFFFFFF";
    w_b  <= x"0FF0F00F";
    wait for 1 ns;
    assert (w_res = x"F00F0FF0" and w_zero = '0')
    report "Error: NAND 0xFFFFFFFF NAND 0x0FF0F00F failed - Expected result = 0xF00F0FF0, zero flag = 0" severity error;

    -- Test SLT operation: 0 less than 1 = 1
    w_op <= OP_SLT;
    w_a  <= std_logic_vector(to_signed(0, 32)); -- 0 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(1, 32)); -- 1 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(1, 32)) and w_zero = '0')
    report "Error: SLT 0 less than 1 failed - Expected result = 1, zero flag = 0" severity error;

    -- Test SLT operation: 1000 less than 1000 = 0
    w_op <= OP_SLT;
    w_a  <= std_logic_vector(to_signed(1000, 32)); -- 1000 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(1000, 32)); -- 1000 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(0, 32)) and w_zero = '1')
    report "Error: SLT 1000 less than 1000 failed - Expected result = 0, zero flag = 1" severity error;

    -- Test SLT operation: 11 less than 6 = 0
    w_op <= OP_SLT;
    w_a  <= std_logic_vector(to_signed(11, 32)); -- 11 as signed 32-bit
    w_b  <= std_logic_vector(to_signed(6, 32));  -- 6 as signed 32-bit
    wait for 1 ns;
    assert (w_res = std_logic_vector(to_signed(0, 32)) and w_zero = '1')
    report "Error: SLT 11 less than 6 failed - Expected result = 0, zero flag = 1" severity error;

    -- Clear inputs
    w_op <= (others => '0');
    w_a  <= (others => '0');
    w_b  <= (others => '0');
    assert false report "Successful test." severity note;
    wait;
  end process;
end arch_1;