-------------------------------------------------------------------------------
-- Module: tb_ImmGen
-- Description: 
--   - Testbench for ImmGen.
--   - Simulates immediate generation.
-- Author: Levy Elmescany
-- Date: 2025-08-09
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for R-type, I-type and B-type instructions.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-08-09 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ImmGen is
end tb_ImmGen;

architecture behavioral of tb_ImmGen is

    component ImmGen is
        port (
            inst  : in  std_logic_vector(31 downto 0); -- instruction
            imm   : out std_logic_vector(31 downto 0)  -- sign-extended immediate value
        );
    end component;

    -- DUT signals
    signal w_inst : std_logic_vector(31 downto 0);
    signal w_imm  : std_logic_vector(31 downto 0);

begin
    -- DUT connection
    dut : ImmGen
    port map (
        inst => w_inst,
        imm  => w_imm
    );

    -- Stimulus process
    process
    begin
        -- Test case 1:
        -- R-type instruction (incompatible, no immediate field)
        w_inst <= x"006283B3"; -- add x7, x5, x6
        wait for 1 ns;
        assert w_imm = std_logic_vector(to_signed(0, 32))
        report "Error: Test case 1 - Expected immediate = 0" severity error;

        -- Test case 2:
        -- I-type
        w_inst <= x"00a00293"; -- addi x5, x0, 10
        wait for 1 ns;
        assert w_imm = std_logic_vector(to_signed(10, 32))
        report "Error: Test case 2 - Expected immediate = 10" severity error;

        -- Test case 3:
        -- B-type
        w_inst <= x"00628663"; -- beq  x5, x6, label (label = offset immediate = 6)
        wait for 1 ns;
        assert w_imm = std_logic_vector(to_signed(6, 32))
        report "Error: Test case 3 - Expected immediate = 6" severity error;

        -- Clear inputs
        w_inst <= (others => '0');
        assert false report "Succesful test." severity note;
        wait;
    end process;
end behavioral;