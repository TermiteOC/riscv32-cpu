-------------------------------------------------------------------------------
-- Module: tb_Mux2x1_32Bit
-- Description: Testbench for Mux2x1_32Bit.
-- Author: Levy Elmescany
-- Date: 2025-07-30
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

entity tb_Mux2x1_32Bit is
end tb_Mux2x1_32Bit;

architecture behavioral of tb_Mux2x1_32Bit is

    component Mux2x1_32Bit is
        port (
            a      : in  std_logic_vector(31 downto 0); -- 1st input
            b      : in  std_logic_vector(31 downto 0); -- 2nd input
            sel    : in  std_logic;                     -- selector
            res    : out std_logic_vector(31 downto 0)  -- chosen output
        );
    end component;

    -- DUT signals
    signal w_a   : std_logic_vector(31 downto 0);
    signal w_b   : std_logic_vector(31 downto 0);
    signal w_sel : std_logic;
    signal w_res : std_logic_vector(31 downto 0);

begin
    -- DUT connection
    dut : Mux2x1_32Bit
    port map (
        a   => w_a,
        b   => w_b,
        sel => w_sel,
        res => w_res
    );

    -- Stimulus process
    process
    begin

        -- Test case: verify mux selects 511 when sel = 0
        w_a   <= std_logic_vector(to_signed(511, 32));  -- 511 as signed 32-bit
        w_b   <= std_logic_vector(to_signed(1023, 32)); -- 1023 as signed 32-bit
        w_sel <= '0';
        wait for 1 ns;
        assert w_res = std_logic_vector(to_signed(511, 32))
        report "Error: MUX failed - Expected result = 511 when sel = 0" severity error;

        -- Test case: verify mux selects 1023 when sel = 1
        w_a   <= std_logic_vector(to_signed(511, 32));  -- 511 as signed 32-bit
        w_b   <= std_logic_vector(to_signed(1023, 32)); -- 1023 as signed 32-bit
        w_sel <= '1';
        wait for 1 ns;
        assert w_res = std_logic_vector(to_signed(1023, 32))
        report "Error: MUX failed - Expected result = 1023 when sel = 1" severity error;

        -- Test case: verify mux selects 3 when sel = 1
        w_a   <= std_logic_vector(to_signed(0, 32)); -- 0 as signed 32-bit
        w_b   <= std_logic_vector(to_signed(3, 32)); -- 3 as signed 32-bit
        w_sel <= '1';
        wait for 1 ns;
        assert w_res = std_logic_vector(to_signed(3, 32))
        report "Error: MUX failed - Expected result = 3 when sel = 1" severity error;

        -- Test case: verify mux selects 3 when sel = 0
        w_a   <= std_logic_vector(to_signed(3, 32)); -- 3 as signed 32-bit
        w_b   <= std_logic_vector(to_signed(0, 32)); -- 0 as signed 32-bit
        w_sel <= '0';
        wait for 1 ns;
        assert w_res = std_logic_vector(to_signed(3, 32))
        report "Error: MUX failed - Expected result = 3 when sel = 0" severity error;
        
        -- Clear inputs
        w_a   <= (others => '0');
        w_b   <= (others => '0');
        w_sel <= '0';
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;