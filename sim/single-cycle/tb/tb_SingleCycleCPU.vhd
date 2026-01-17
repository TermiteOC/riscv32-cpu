-------------------------------------------------------------------------------
-- Module: tb_SingleCycleCPU
-- Description: 
--   - Testbench for SingleCycleCPU
--   - Simulates assembly program initialize in instruction memory.
-- Author: Levy Elmescany
-- Date: 2026-01-16
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - No stimuli generated.
--   - Check correct behavior of CPU under assembly program.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2026-01-16 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_SingleCycleCPU is
end tb_SingleCycleCPU;

architecture behavioral of tb_SingleCycleCPU is

    component SingleCycleCPU is
        port (
            clk     : in  std_logic;                     -- clock
            rst     : in  std_logic;                     -- reset
            alu_out : out std_logic_vector(31 downto 0); -- alu result
            pc_out  : out std_logic_vector(31 downto 0)  -- pc output
        );
    end component;
  
    -- DUT signals
    signal w_rst     : std_logic := '1';
    signal w_alu_out : std_logic_vector(31 downto 0);
    signal w_pc_out  : std_logic_vector(31 downto 0);

    -- Initialize clock
    signal w_clk : std_logic := '0';

    -- Clock period definition
    constant CLK_PERIOD : time := 1 ns;

begin
    -- DUT connection
    dut : SingleCycleCPU
    port map (
        clk     => w_clk,
        rst     => w_rst,
        alu_out => w_alu_out,
        pc_out  => w_pc_out
    );

    -- Clock process definition
    w_clk <= not w_clk after CLK_PERIOD/2;

    -- Stimulus process
    process
    begin
        -- Test case 1: addi x8, x0, 5
        w_rst <= '1';
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(5, 32))) -- 5 as signed 32-bit
        report "Error: Test case 1 - Expected ALU result = 5" severity error;
        assert (w_pc_out = x"00000000") -- address 0
        report "Error: Test case 1 - Expected PC address = 0" severity error;

        -- Test case 2: addi x9, x0, 10
        w_rst <= '0';
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(10, 32))) -- 10 as signed 32-bit
        report "Error: Test case 2 - Expected ALU result = 10" severity error;
        assert (w_pc_out = x"00000004") -- address 1
        report "Error: Test case 2 - Expected PC address = 1" severity error;

        -- Test case 3: add x5, x8, x9
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(15, 32))) -- 15 as signed 32-bit
        report "Error: Test case 3 - Expected ALU result = 15" severity error;
        assert (w_pc_out = x"00000008") -- address 2
        report "Error: Test case 3 - Expected PC address = 2" severity error;

        -- Test case 4: sub x6, x9, x8
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(5, 32))) -- 5 as signed 32-bit
        report "Error: Test case 4 - Expected ALU result = 5" severity error;
        assert (w_pc_out = x"0000000c") -- address 3
        report "Error: Test case 4 - Expected PC address = 3" severity error;

        -- Test case 5: and x7, x8, x9
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(0, 32))) -- 0 as signed 32-bit
        report "Error: Test case 5 - Expected ALU result = 0" severity error;
        assert (w_pc_out = x"00000010") -- address 4
        report "Error: Test case 5 - Expected PC address = 4" severity error;

        -- Test case 6: or x28, x8, x9
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(15, 32))) -- 15 as signed 32-bit
        report "Error: Test case 6 - Expected ALU result = 15" severity error;
        assert (w_pc_out = x"00000014") -- address 5
        report "Error: Test case 6 - Expected PC address = 5" severity error;

        -- Test case 7: slt x18, x8, x9
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(1, 32))) -- 1 as signed 32-bit
        report "Error: Test case 7 - Expected ALU result = 1" severity error;
        assert (w_pc_out = x"00000018") -- address 6
        report "Error: Test case 7 - Expected PC address = 6" severity error;

        -- Test case 8: addi x19, x0, 100
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(100, 32))) -- 100 as signed 32-bit
        report "Error: Test case 8 - Expected ALU result = 100" severity error;
        assert (w_pc_out = x"0000001c") -- address 7
        report "Error: Test case 8 - Expected PC address = 7" severity error;

        -- Test case 9: beq x18, x7, 0x0000000c
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(1, 32))) -- 1 as signed 32-bit
        report "Error: Test case 9 - Expected ALU result = 1" severity error;
        assert (w_pc_out = x"00000020") -- address 8
        report "Error: Test case 9 - Expected PC address = 8" severity error;

        -- Test case 10: addi x19, x0, 1
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(1, 32))) -- 1 as signed 32-bit
        report "Error: Test case 10 - Expected ALU result = 1" severity error;
        assert (w_pc_out = x"00000024") -- address 9
        report "Error: Test case 10 - Expected PC address = 9" severity error;

        -- Test case 11: beq x0, x7, 0x00000008
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(0, 32))) -- 0 as signed 32-bit
        report "Error: Test case 11 - Expected ALU result = 0" severity error;
        assert (w_pc_out = x"00000028") -- address 10
        report "Error: Test case 11 - Expected PC address = 10" severity error;

        -- Test case 12: andi x29, x19, 7
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(1, 32))) -- 1 as signed 32-bit
        report "Error: Test case 12 - Expected ALU result = 1" severity error;
        assert (w_pc_out = x"00000030") -- address 12
        report "Error: Test case 12 - Expected PC address = 12" severity error;

        -- Test case 13: ori x30, x19, 4
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(5, 32))) -- 5 as signed 32-bit
        report "Error: Test case 13 - Expected ALU result = 5" severity error;
        assert (w_pc_out = x"00000034") -- address 13
        report "Error: Test case 13 - Expected PC address = 13" severity error;

        -- Test case 14: addi x0, x0, 0 (NOP)
        wait for CLK_PERIOD;
        assert (w_alu_out = std_logic_vector(to_signed(0, 32))) -- 0 as signed 32-bit
        report "Error: Test case 14 - Expected ALU result = 0" severity error;
        assert (w_pc_out = x"00000038") -- address 14
        report "Error: Test case 14 - Expected PC address = 14" severity error;

        -- Clear inputs
        w_rst <= '0';
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;