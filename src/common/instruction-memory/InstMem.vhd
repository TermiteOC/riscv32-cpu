-------------------------------------------------------------------------------
-- Module: InstMem
-- Description: Single-Port ROM for instruction storage.
-- Author: Levy Elmescany
-- Date: 2025-08-11
-- License: MIT
-- Inputs: clk, addr
-- Outputs: q
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - Implements memory as a 2D array of words.
--   - Default data width parameter matches 32-bit RISC-V architecture.
--   - Default address width is 10 (1024 total addresses).
--   - ROM contents initialized to zero; can be modified for test programs.
-- Simulation: Verified via tb_InstMem testbench
-- Revision History:
--   Rev 1.0 - 2025-08-11 - Initial implementation
--   Rev 1.1 - 2025-08-12 - Changed address input to receive binary value (std_logic_vector);
--                          initializing with basic RARS program for simulation purposes
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
        clk     : in std_logic;                                   -- clock
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
        temp(0)  := x"00500093"; -- addi x1, x0, 5
        temp(1)  := x"00A00113"; -- addi x2, x0, 10
        temp(2)  := x"002081B3"; -- add x3, x1, x2
        temp(3)  := x"40110233"; -- sub x4, x2, x1
        temp(4)  := x"0020F2B3"; -- and x5, x1, x2
        temp(5)  := x"0020E333"; -- or  x6, x1, x2
        temp(6)  := x"0020A4B3"; -- slt x9, x1, x2
        temp(7)  := x"00208663"; -- beq x1, x2, 12
        temp(8)  := x"00100513"; -- addi x10, x0, 1
        temp(9)  := x"00000663"; -- beq x0, x0, 12
        temp(10) := x"00200513"; -- addi x10, x0, 2
        temp(11) := x"00A57593"; -- andi x11, x10, 10
        temp(12) := x"00000013"; -- addi x0, x0, 0 (NOP)
    return temp;
    end init_rom;   

    -- Declare the ROM signal and specify a default value.
    signal rom : memory_t := init_rom;

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            q <= rom(to_integer(unsigned(addr)));
        end if;
    end process;
end rtl;