-------------------------------------------------------------------------------
-- Module: tb_ShiftLeft1
-- Description: 
--   - Testbench for ShiftLeft1.
--   - Simulates logical shift left.
-- Author: Levy Elmescany
-- Date: 2025-08-09
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for sample inputs.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-08-09 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ShiftLeft1 is
end tb_ShiftLeft1;

architecture behavioral of tb_ShiftLeft1 is

    component ShiftLeft1 is
        port (
            d     : in  std_logic_vector(31 downto 0);   -- data input
            shifted : out std_logic_vector(31 downto 0)  -- shifted output
        );
    end component;

    -- DUT signals
    signal w_d       : std_logic_vector(31 downto 0);
    signal w_shifted : std_logic_vector(31 downto 0);

begin
    -- DUT connection
    dut : ShiftLeft1
    port map (
        d       => w_d,
        shifted => w_shifted
    );

    -- Stimulus process
    process
    begin
        -- Test case 1:
        -- Shift left binary value 5 (same as multiply by 2)
        w_d <= std_logic_vector(to_signed(5, 32)); -- 5 as signed 32-bit
        wait for 1 ns;
        assert w_shifted = std_logic_vector(to_signed(10, 32))
        report "Error: Test case 1 - Expected output = 10" severity error;

        -- Test case 2:
        -- Shift left binary value with MSB set (overflow, result zero)
        w_d <= "10000000000000000000000000000000";
        wait for 1 ns;
        assert w_shifted = std_logic_vector(to_signed(0, 32))
        report "Error: Test case 2 - Expected output = 0" severity error;

        -- Clear inputs
        w_d <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;