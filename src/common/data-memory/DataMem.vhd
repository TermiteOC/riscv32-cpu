-------------------------------------------------------------------------------
-- Module: DataMem
-- Description: Single-Port RAM with separate read and write control signals.
-- Author: Levy Elmescany
-- Date: 2025-08-14
-- License: MIT
-- Inputs: clk, addr, write_data, mem_write, mem_read
-- Outputs: read_data
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - Implements memory as a 2D array of words.
--   - Read operation is asynchronous; output updates immediately with address changes.
--   - Write operation is synchronous; occurs only on the rising clock edge.
--   - Default data width matches 32-bit RISC-V architecture.
--   - Default address width is 10 (1024 total addresses).
--   - Output defaults to 0 when read control signal is deasserted.
--   - Memory contents initialized to zero.
-- Simulation: Verified via tb_DataMem testbench
-- Revision History:
--   Rev 1.0 - 2025-08-14 - Initial implementation
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMem is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10
    );

    port 
    (
        clk        : in  std_logic;                                 -- clock
        addr       : in  std_logic_vector((ADDR_WIDTH-1) downto 0); -- address
        write_data : in  std_logic_vector((DATA_WIDTH-1) downto 0); -- write input
        mem_write  : in  std_logic := '0';                          -- write control
        mem_read   : in  std_logic := '0';                          -- read control
        read_data  : out std_logic_vector((DATA_WIDTH -1) downto 0) -- read output
    );
end DataMem;

architecture rtl of DataMem is

    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Declare the RAM signal.
    signal ram : memory_t := (others => (others => '0'));

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Write operation (synchronous): store data on rising edge if write control is high
            if mem_write = '1' then
                ram(to_integer(unsigned(addr))) <= write_data;
            end if;
        end if;
    end process;

    -- Read operation (asynchronous): output immediately updates when address changes and read control is high
    read_data <= ram(to_integer(unsigned(addr))) when mem_read = '1' else (others => '0'); -- If read control is deasserted, output becomes 0
end rtl;

