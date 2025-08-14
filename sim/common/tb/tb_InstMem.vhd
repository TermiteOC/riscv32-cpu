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
--                          removed clock dependency and adjusted wait statements.
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
        -- Test case 1: Fetch address 0, expect (0x00500093)
        w_addr <= std_logic_vector(to_unsigned(0, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00500093"
        report "Error: Test case 1 - expected output = x'00500093'" severity error;

        -- Test case 2: Fetch address 1, expect (0x00A00113)
        w_addr <= std_logic_vector(to_unsigned(1, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00A00113"
        report "Error: Test case 2 - expected output = x'00A00113'" severity error;

        -- Test case 3: Fetch address 2, expect (0x002081B3)
        w_addr <= std_logic_vector(to_unsigned(2, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"002081B3"
        report "Error: Test case 3 - expected output = x'002081B3'" severity error;

        -- Test case 4: Fetch address 3, expect (0x40110233)
        w_addr <= std_logic_vector(to_unsigned(3, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"40110233"
        report "Error: Test case 4 - expected output = x'40110233'" severity error;

        -- Test case 5: Fetch address 4, expect (0x0020F2B3)
        w_addr <= std_logic_vector(to_unsigned(4, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"0020F2B3"
        report "Error: Test case 5 - expected output = x'0020F2B3'" severity error;

        -- Test case 6: Fetch address 5, expect (0x0020E333)
        w_addr <= std_logic_vector(to_unsigned(5, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"0020E333"
        report "Error: Test case 6 - expected output = x'0020E333'" severity error;

        -- Test case 7: Fetch address 6, expect (0x0020A4B3)
        w_addr <= std_logic_vector(to_unsigned(6, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"0020A4B3"
        report "Error: Test case 7 - expected output = x'0020A4B3'" severity error;

        -- Test case 8: Fetch address 7, expect (0x00208663)
        w_addr <= std_logic_vector(to_unsigned(7, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00208663"
        report "Error: Test case 8 - expected output = x'00208663'" severity error;

        -- Test case 9: Fetch address 8, expect (0x00100513)
        w_addr <= std_logic_vector(to_unsigned(8, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00100513"
        report "Error: Test case 9 - expected output = x'00100513'" severity error;

        -- Test case 10: Fetch address 9, expect (0x00000663)
        w_addr <= std_logic_vector(to_unsigned(9, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00000663"
        report "Error: Test case 10 - expected output = x'00000663'" severity error;

        -- Test case 11: Fetch address 10, expect (0x00200513)
        w_addr <= std_logic_vector(to_unsigned(10, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00200513"
        report "Error: Test case 11 - expected output = x'00200513'" severity error;

        -- Test case 12: Fetch address 11, expect (0x00A57593)
        w_addr <= std_logic_vector(to_unsigned(11, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00A57593"
        report "Error: Test case 12 - expected output = x'00A57593'" severity error;

        -- Test case 13: Fetch address 12, expect (0x00000013)
        w_addr <= std_logic_vector(to_unsigned(12, TB_ADDR_WIDTH));
        wait for 1 ns;
        assert w_q = x"00000013"
        report "Error: Test case 13 - expected output = x'00000013'" severity error;

        -- Clear inputs
        w_addr <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;