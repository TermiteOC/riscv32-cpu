-------------------------------------------------------------------------------
-- Module: InstMem
-- Description: Asynchronous single-Port ROM for instruction storage.
-- Author: Levy Elmescany
-- Date: 2025-08-11
-- License: MIT
-- Inputs: addr
-- Outputs: q
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - Implements memory as a 2D array of words.
--   - Output reflects the contents at the address port immediately after the address changes.
--   - Default data width parameter matches 32-bit RISC-V architecture.
--   - Default address width is 10 (1024 total addresses).
--   - ROM contents initialized to zero; can be modified for test programs.
-- Simulation: Verified via tb_InstMem testbench
-- Revision History:
--   Rev 1.0 - 2025-08-11 - Initial implementation
--   Rev 1.1 - 2025-08-12 - Changed address input to receive binary value (std_logic_vector);
--                          initializing with basic RARS program for simulation purposes
--   Rev 1.2 - 2025-08-14 - Modified to asynchronous ROM: output updates immediately with 
--                          address changes, no clock required
--   Rev 2.0 - 2026-01-16 - Changed initialized RARS assmebly program to simulate every feature
--                          of the RISCV-32 CPU
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstMem is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10
    );

    port 
    (
        addr    : in std_logic_vector((ADDR_WIDTH - 1) downto 0); -- instruction address
        q       : out std_logic_vector((DATA_WIDTH - 1) downto 0) -- instruction output
    );
end InstMem;

architecture rtl of InstMem is

    -- Build a 2-D array type for the ROM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    function init_rom return memory_t is
        variable temp : memory_t := (others => (others => '0'));
    begin
        temp(0)  := x"00500413"; -- addi x8, x0, 5
        temp(1)  := x"00a00493"; -- addi x9, x0, 10
        temp(2)  := x"009402b3"; -- add x5, x8, x9
        temp(3)  := x"40848333"; -- sub x6, x9, x8
        temp(4)  := x"009473b3"; -- and x7, x8, x9
        temp(5)  := x"00946e33"; -- or x28, x8, x9
        temp(6)  := x"00942933"; -- slt x18, x8, x9
        temp(7)  := x"06400993"; -- addi x19, x0, 100
        temp(8)  := x"00790663"; -- beq x18, x7, 0x0000000c
        temp(9)  := x"00100993"; -- addi x19, x0, 1
        temp(10) := x"00700463"; -- beq x0, x7, 0x000 00008
        temp(11) := x"00200993"; -- addi x19, x0, 2
        temp(12) := x"0079fe93"; -- andi x29, x19, 7
        temp(13) := x"0049ef13"; -- ori x30, x19, 4
        temp(14) := x"00000013"; -- addi x0, x0, 0 (NOP)
    return temp;
    end init_rom;   

    -- Declare the ROM signal and specify a default value.
    signal rom : memory_t := init_rom;

begin
    -- Update instruction output with corresponding instruction from address input
    q <= rom(to_integer(unsigned(addr)));
end rtl;