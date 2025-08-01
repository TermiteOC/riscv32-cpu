-------------------------------------------------------------------------------
-- Module: tb_PCReg
-- Description: Testbench for PCReg.
-- Author: Levy Elmescany
-- Date: 2025-08-01
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-07-30 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_PCReg is
end tb_PCReg;

architecture behavioral of tb_PCReg is

    component PCReg is
        port (
            d   : in  std_logic_vector(31 downto 0); -- data input
            rst : in  std_logic;                     -- reset
            clk : in  std_logic;                     -- clock
            q   : out std_logic_vector(31 downto 0)  -- data output
        );
    end component;

    -- DUT signals
    signal w_d   : std_logic_vector(31 downto 0);
    signal w_rst : std_logic;
    signal w_q   : std_logic_vector(31 downto 0);

    -- Initialize clock
    signal w_clk : std_logic := '0';

    -- Clock period definition
    constant CLK_PERIOD : time := 1 ns;

begin
    -- DUT connection
    dut : PCReg
    port map (
        d   => w_d,
        rst => w_rst,
        clk => w_clk,
        q   => w_q
    );

    -- Clock process definition
    w_clk <= not w_clk after CLK_PERIOD/2;

    -- Stimulus process
    process
    begin

        -- Reset register and verify output = 0
        w_rst <= '1';
        wait for CLK_PERIOD;
        assert w_q = std_logic_vector(to_unsigned(0, 32))
        report "Error: Reset failed - Expected output = 0 when rst = 1" severity error;

        -- Deactivate reset
        w_rst <= '0';

        -- Test case: input = 4
        w_d <= std_logic_vector(to_unsigned(4, 32)); -- 4 as unsigned 32-bit
        wait for CLK_PERIOD;
        assert w_q = std_logic_vector(to_unsigned(4, 32))
        report "Error: Input = 4 failed - Expected output = 4" severity error;

        -- Test case: input = 8
        w_d <= std_logic_vector(to_unsigned(8, 32)); -- 8 as unsigned 32-bit
        wait for CLK_PERIOD;
        assert w_q = std_logic_vector(to_unsigned(8, 32))
        report "Error: Input = 8 failed - Expected output = 8" severity error;

        -- Test case: input = 16
        w_d <= std_logic_vector(to_unsigned(16, 32)); -- 16 as unsigned 32-bit
        wait for CLK_PERIOD;
        assert w_q = std_logic_vector(to_unsigned(16, 32))
        report "Error: Input = 16 failed - Expected output = 16" severity error;

        -- Clear inputs
        w_d   <= (others => '0');
        w_rst <= '0';
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;
