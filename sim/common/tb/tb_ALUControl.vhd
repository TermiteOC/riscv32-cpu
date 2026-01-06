-------------------------------------------------------------------------------
-- Module: tb_ALUControl
-- Description: 
--   - Testbench for ALUControl.
--   - Simulates correct ALU operation selection based on alu_op,
--     funct3, and funct7 fields
-- Author: Levy Elmescany
-- Date: 2026-01-05
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for LW, SW, BEQ, R-type and I-type instructions
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2026-01-05 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALUControl is
end tb_ALUControl;

architecture behavioral of tb_ALUControl is

    -- ALU operation encoding
    constant ALU_AND     : std_logic_vector(3 downto 0) := "0000";
    constant ALU_OR      : std_logic_vector(3 downto 0) := "0001";
    constant ALU_ADD     : std_logic_vector(3 downto 0) := "0010";
    constant ALU_SLT     : std_logic_vector(3 downto 0) := "0011";
    constant ALU_SUB     : std_logic_vector(3 downto 0) := "0110";
    constant ALU_DEFAULT : std_logic_vector(3 downto 0) := "1111";

    component ALUControl is
        port (
            alu_op : in  std_logic_vector(1 downto 0); -- main control generated bits
            f7     : in  std_logic;                    -- funct7[5] / instruction[30]
            f3     : in  std_logic_vector(2 downto 0); -- funct3 field
            sel     : out std_logic_vector(3 downto 0) -- selected alu control lines
        );
    end component;

    -- DUT signals
    signal w_alu_op : std_logic_vector(1 downto 0);
    signal w_f7     : std_logic;
    signal w_f3     : std_logic_vector(2 downto 0);
    signal w_sel    : std_logic_vector(3 downto 0);

begin
    -- DUT connection
    dut : ALUControl
    port map (
        alu_op => w_alu_op,
        f7     => w_f7,
        f3     => w_f3,
        sel    => w_sel
    );

    -- Stimulus process
    process
    begin
        -- Test case 1:
        -- LW/SW instruction
        w_alu_op <= "00";
        w_f7     <= '0';
        w_f3     <= "010";
        wait for 1 ns;
        assert (w_sel = ALU_ADD)
        report "Error: Test case 1 - Expected selected operation = 0010" severity error;

        -- Test case 2:
        -- LW/SW instruction, changing funct7 field bit
        w_alu_op <= "00";
        w_f7     <= '1';
        w_f3     <= "010";
        wait for 1 ns;
        assert (w_sel = ALU_ADD)
        report "Error: Test case 2 - Expected selected operation = 0010" severity error;

        -- Test case 3:
        -- BEQ instruction
        w_alu_op <= "01";
        w_f7     <= '0';
        w_f3     <= "000";
        wait for 1 ns;
        assert (w_sel = ALU_SUB)
        report "Error: Test case 3 - Expected selected operation = 0110" severity error;

        -- Test case 4:
        -- BEQ instruction with incorrect funct3 field
        w_alu_op <= "01";
        w_f7     <= '0';
        w_f3     <= "011";
        wait for 1 ns;
        assert (w_sel = ALU_DEFAULT)
        report "Error: Test case 4 - Expected selected operation = 1111" severity error;

        -- Test case 5:
        -- ADD instruction
        w_alu_op <= "10";
        w_f7     <= '0';
        w_f3     <= "000";
        wait for 1 ns;
        assert (w_sel = ALU_ADD)
        report "Error: Test case 5 - Expected selected operation = 0010" severity error;

        -- Test case 6:
        -- SUB instruction
        w_alu_op <= "10";
        w_f7     <= '1';
        w_f3     <= "000";
        wait for 1 ns;
        assert (w_sel = ALU_SUB)
        report "Error: Test case 6 - Expected selected operation = 0110" severity error;

        -- Test case 7:
        -- SLT instruction with wrong funct7 field bit
        w_alu_op <= "10";
        w_f7     <= '1';
        w_f3     <= "010";
        wait for 1 ns;
        assert (w_sel = ALU_DEFAULT)
        report "Error: Test case 7 - Expected selected operation = 1111" severity error;

        -- Test case 8:
        -- SLT instruction with correct inputs
        w_alu_op <= "10";
        w_f7     <= '0';
        w_f3     <= "010";
        wait for 1 ns;
        assert (w_sel = ALU_SLT)
        report "Error: Test case 8 - Expected selected operation = 0011" severity error;

        -- Test case 9:
        -- OR instruction
        w_alu_op <= "10";
        w_f7     <= '0';
        w_f3     <= "110";
        wait for 1 ns;
        assert (w_sel = ALU_OR)
        report "Error: Test case 9 - Expected selected operation = 0001" severity error;

        -- Test case 10:
        -- AND instruction
        w_alu_op <= "10";
        w_f7     <= '0';
        w_f3     <= "111";
        wait for 1 ns;
        assert (w_sel = ALU_AND)
        report "Error: Test case 10 - Expected selected operation = 0000" severity error;

        -- Test case 11:
        -- AND instruction with incorrect funct7 field
        w_alu_op <= "10";
        w_f7     <= '1';
        w_f3     <= "111";
        wait for 1 ns;
        assert (w_sel = ALU_DEFAULT)
        report "Error: Test case 11 - Expected selected operation = 1111" severity error;

        -- Test case 12:
        -- ADDI instruction
        w_alu_op <= "11";
        w_f7     <= '0';
        w_f3     <= "000";
        wait for 1 ns;
        assert (w_sel = ALU_ADD)
        report "Error: Test case 12 - Expected selected operation = 0010" severity error;

        -- Test case 13:
        -- ADDI instruction with different funct7 field bit (does not change result)
        w_alu_op <= "11";
        w_f7     <= '1';
        w_f3     <= "000";
        wait for 1 ns;
        assert (w_sel = ALU_ADD)
        report "Error: Test case 13 - Expected selected operation = 0010" severity error;

        -- Test case 14:
        -- ORI
        w_alu_op <= "11";
        w_f3     <= "110";
        wait for 1 ns;
        assert (w_sel = ALU_OR)
        report "Error: Test case 14 - Expected selected operation = 0001" severity error;

        -- Test case 15:
        -- ANDI
        w_alu_op <= "11";
        w_f3     <= "111";
        wait for 1 ns;
        assert (w_sel = ALU_AND)
        report "Error: Test case 15 - Expected selected operation = 0000" severity error;

        -- Clear inputs
        w_alu_op <= (others => '0');
        w_f7     <= '0';
        w_f3     <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;