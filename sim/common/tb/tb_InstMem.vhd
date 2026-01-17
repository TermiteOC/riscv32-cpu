-------------------------------------------------------------------------------
-- Module: tb_InstMem
-- Description: 
--   - Testbench for InstMem
--   - Reads predefined instructions from the DUT and verifies correctness
-- Author: Levy Elmescany
-- Date: 2025-08-13
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for addresses 0 through 12.
--   - Compares DUT output with expected RARS-assembled instructions.
--   - Output works on combinational logic
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-08-13 - Initial testbench implementation
--   Rev 1.1 - 2025-08-14 - Updated testbench to match asynchronous InstMem design;
--                          removed clock dependency and adjusted wait statements
--   Rev 1.2 - 2026-01-16 - Changed testbench to reflect new initialized RARS program
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_InstMem is
end tb_InstMem;

architecture behavioral of tb_InstMem is

    -- Width of the data and address buses (match DUT parameters)
    constant TB_DATA_WIDTH : natural := 32;
    constant TB_ADDR_WIDTH : natural := 10;

    component InstMem is
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
    end component;

    -- DUT signals
    signal w_addr : std_logic_vector((TB_ADDR_WIDTH - 1) downto 0) := (others => '0');
    signal w_q    : std_logic_vector((TB_DATA_WIDTH - 1) downto 0) := (others => '0');

begin
    -- DUT connection
    dut : InstMem
    generic map (
        DATA_WIDTH => TB_DATA_WIDTH,
        ADDR_WIDTH => TB_ADDR_WIDTH
    )
    port map (
        addr => w_addr,
        q    => w_q
    );

    -- Stimulus process
    process
    begin
        -- Test case 1: Fetch address 0, expect (0x00500413)
        w_addr <= std_logic_vector(to_unsigned(0, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00500413"
        report "Error: Test case 1 - expected output = x'00500413'" severity error;

        -- Test case 2: Fetch address 1, expect (0x00a00493)
        w_addr <= std_logic_vector(to_unsigned(1, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00a00493"
        report "Error: Test case 2 - expected output = x'00a00493'" severity error;

        -- Test case 3: Fetch address 2, expect (0x009402b3)
        w_addr <= std_logic_vector(to_unsigned(2, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"009402b3"
        report "Error: Test case 3 - expected output = x'009402b3'" severity error;

        -- Test case 4: Fetch address 3, expect (0x40848333)
        w_addr <= std_logic_vector(to_unsigned(3, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"40848333"
        report "Error: Test case 4 - expected output = x'40848333'" severity error;

        -- Test case 5: Fetch address 4, expect (0x009473b3)
        w_addr <= std_logic_vector(to_unsigned(4, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"009473b3"
        report "Error: Test case 5 - expected output = x'009473b3'" severity error;

        -- Test case 6: Fetch address 5, expect (0x00946e33)
        w_addr <= std_logic_vector(to_unsigned(5, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00946e33"
        report "Error: Test case 6 - expected output = x'00946e33'" severity error;

        -- Test case 7: Fetch address 6, expect (0x00942933)
        w_addr <= std_logic_vector(to_unsigned(6, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00942933"
        report "Error: Test case 7 - expected output = x'00942933'" severity error;

        -- Test case 8: Fetch address 7, expect (0x06400993)
        w_addr <= std_logic_vector(to_unsigned(7, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"06400993"
        report "Error: Test case 8 - expected output = x'06400993'" severity error;

        -- Test case 9: Fetch address 8, expect (0x00790663)
        w_addr <= std_logic_vector(to_unsigned(8, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00790663"
        report "Error: Test case 9 - expected output = x'00790663'" severity error;

        -- Test case 10: Fetch address 9, expect (0x00100993)
        w_addr <= std_logic_vector(to_unsigned(9, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00100993"
        report "Error: Test case 10 - expected output = x'00100993'" severity error;

        -- Test case 11: Fetch address 10, expect (0x00700463)
        w_addr <= std_logic_vector(to_unsigned(10, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00700463"
        report "Error: Test case 11 - expected output = x'00700463'" severity error;

        -- Test case 12: Fetch address 11, expect (0x00200993)
        w_addr <= std_logic_vector(to_unsigned(11, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00200993"
        report "Error: Test case 12 - expected output = x'00200993'" severity error;

        -- Test case 13: Fetch address 12, expect (0x0079fe93)
        w_addr <= std_logic_vector(to_unsigned(12, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"0079fe93"
        report "Error: Test case 13 - expected output = x'0079fe93'" severity error;

        -- Test case 14: Fetch address 13, expect (0x0049ef13)
        w_addr <= std_logic_vector(to_unsigned(13, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"0049ef13"
        report "Error: Test case 14 - expected output = x'0049ef13'" severity error;

        -- Test case 15: Fetch address 14, expect (0x00000013)
        w_addr <= std_logic_vector(to_unsigned(14, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00000013"
        report "Error: Test case 15 - expected output = x'00000013'" severity error;

        -- Clear inputs
        w_addr <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;