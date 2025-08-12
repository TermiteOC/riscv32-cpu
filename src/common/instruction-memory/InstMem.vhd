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
-- Simulation: To be verified via tb_InstMem testbench
-- Revision History:
--   Rev 1.0 - 2025-08-11 - Initial implementation
--   Rev 1.1 - 2025-08-12 - Changed address input to receive binary value (std_logic_vector)
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
    begin
        return (others => (others => '0'));
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

