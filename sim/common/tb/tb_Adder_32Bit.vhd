-------------------------------------------------------------------------------
-- Module: tb_Adder_32Bit
-- Description: Testbench for Adder_32Bit.
-- Author: Levy Elmescany
-- Date: 2025-07-29
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for positive and negative addition.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-07-29 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Adder_32Bit is
end tb_Adder_32Bit;

architecture behavioral of tb_Adder_32Bit is

    component Adder_32Bit is
        port (
            a   : in  std_logic_vector(31 downto 0); -- 1st operand
            b   : in  std_logic_vector(31 downto 0); -- 2nd operand
            sum : out std_logic_vector(31 downto 0)  -- result of the sum
        );
    end component;

    -- DUT signals
    signal w_a   : std_logic_vector(31 downto 0);
    signal w_b   : std_logic_vector(31 downto 0);
    signal w_sum : std_logic_vector(31 downto 0);

begin
    -- DUT Connection
    dut : Adder_32Bit
    port map (
        a   => w_a,
        b   => w_b,
        sum => w_sum
    );

    -- Stimulus process
    process
    begin

        --Test: 5 + 10 = 15
        w_a <= std_logic_vector(to_signed(5, 32));  -- 5 as signed 32-bit
        w_b <= std_logic_vector(to_signed(10, 32)); -- 10 as signed 32-bit
        wait for 1 ns;
        assert w_sum = std_logic_vector(to_signed(15, 32))
        report "Error: 5 + 10 failed - Expected result = 15" severity error;

        --Test: -16 + 16 = 0
        w_a <= std_logic_vector(to_signed(-16, 32));  -- -16 as signed 32-bit
        w_b <= std_logic_vector(to_signed(16, 32));   -- 16 as signed 32-bit
        wait for 1 ns;
        assert w_sum = std_logic_vector(to_signed(0, 32))
        report "Error: -16 + 16 failed - Expected result = 0" severity error;

        --Test: -3 + (-7) = -10
        w_a <= std_logic_vector(to_signed(-3, 32));  -- -3 as signed 32-bit
        w_b <= std_logic_vector(to_signed(-7, 32));  -- -7 as signed 32-bit
        wait for 1 ns;
        assert w_sum = std_logic_vector(to_signed(-10, 32))
        report "Error: -3 + (-7) failed - Expected result = -10" severity error;

        --Test: 24 + (-1) = 23
        w_a <= std_logic_vector(to_signed(24, 32));  -- 24 as signed 32-bit
        w_b <= std_logic_vector(to_signed(-1, 32));  -- -1 as signed 32-bit
        wait for 1 ns;
        assert w_sum = std_logic_vector(to_signed(23, 32))
        report "Error: 24 + (-1) failed - Expected result = 23" severity error;
        
        -- Clear inputs
        w_a <= (others => '0');
        w_b <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;