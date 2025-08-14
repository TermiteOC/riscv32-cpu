-------------------------------------------------------------------------------
-- Module: tb_DataMem
-- Description:
--   - Testbench for DataMem.
--   - Verifies asynchronous read and synchronous write operations.
-- Author: Levy Elmescany
-- Date: 2025-08-14
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Performs write to specific address with write control signal asserted.
--   - Reads back data with read control signal asserted to confirm write success.
--   - Verifies that data output is zero when read control signal is deasserted, and when
--     address has not yet been written to.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-08-14 - Initial testbench implementation
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DataMem is
end tb_DataMem;

architecture behavioral of tb_DataMem is

    constant TB_DATA_WIDTH : natural := 32;
    constant TB_ADDR_WIDTH : natural := 10;

    component DataMem is
        generic 
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
        port 
        (
            clk        : in  std_logic;
            addr       : in  std_logic_vector((ADDR_WIDTH-1) downto 0);
            write_data : in  std_logic_vector((DATA_WIDTH-1) downto 0);
            mem_write  : in  std_logic := '0';
            mem_read   : in  std_logic := '0';
            read_data  : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    signal w_addr       : std_logic_vector((TB_ADDR_WIDTH-1) downto 0) := (others => '0');
    signal w_write_data : std_logic_vector((TB_DATA_WIDTH-1) downto 0) := (others => '0');
    signal w_mem_write  : std_logic := '0';
    signal w_mem_read   : std_logic := '0';
    signal w_read_data  : std_logic_vector((TB_DATA_WIDTH-1) downto 0);
    signal w_clk        : std_logic := '0';
    constant CLK_PERIOD : time := 1 ns;

begin
    dut : DataMem
        generic map (DATA_WIDTH => TB_DATA_WIDTH, ADDR_WIDTH => TB_ADDR_WIDTH)
        port map (clk => w_clk, addr => w_addr, write_data => w_write_data,
                  mem_write => w_mem_write, mem_read => w_mem_read, read_data => w_read_data);

    w_clk <= not w_clk after CLK_PERIOD/2;

    process
    begin
        -- Test case 1: Write to address 5, then read back
        w_addr       <= std_logic_vector(to_unsigned(5, TB_ADDR_WIDTH));
        w_write_data <= x"AAAAAAAA";
        w_mem_write  <= '1';
        wait until rising_edge(w_clk); -- write occurs
        w_mem_write <= '0';
        w_mem_read <= '1';
        wait for CLK_PERIOD*0.25; -- Hold time for assert
        assert w_read_data = x"AAAAAAAA"
        report "Error: Test case 1 - Expected instruction = AAAAAAAA" severity error;
        wait until rising_edge(w_clk);

        -- Test case 2: Read when read control signal is deasserted
        w_mem_read <= '0';
        wait until rising_edge(w_clk);
        assert w_read_data = x"00000000"
        report "Error: Test 2 - Expected instruction = 00000000" severity error;
        wait until rising_edge(w_clk);

        -- Test case 3: Read and write from the same address in the same clock
        w_addr       <= std_logic_vector(to_unsigned(5, TB_ADDR_WIDTH));
        w_write_data <= x"EEEEEEEE";
        w_mem_write  <= '1';
        w_mem_read   <= '1';
        wait until rising_edge(w_clk); -- write and read occurs in the same address
        wait for CLK_PERIOD*0.25; -- Hold time for assert
        assert w_read_data = x"EEEEEEEE"
        report "Error: Test 3 - Expected EEEEEEEE" severity error;
        wait until rising_edge(w_clk);

        -- Test case 4: Read from address with no data (returns 0)
        w_addr       <= std_logic_vector(to_unsigned(127, TB_ADDR_WIDTH));
        w_mem_read   <= '1';
        wait until rising_edge(w_clk);
        assert w_read_data = x"00000000"
        report "Error: Test case 4 - Expected instruction = 00000000" severity error;
        wait until rising_edge(w_clk);

        -- Clear inputs
        w_addr       <= (others => '0');
        w_write_data <= (others => '0');
        w_mem_write  <= '0';
        w_mem_read   <= '0';
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;