-------------------------------------------------------------------------------
-- Module: tb_MainControl
-- Description: 
--   - Testbench for tb_MainControl.
--   - Simulates the main control unit behavior for different instruction opcodes.
-- Author: Levy Elmescany
-- Date: 2026-01-10
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for LW, SW, B-type, R-type and I-type instructions
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2026-01-10 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_MainControl is
end tb_MainControl;

architecture behavioral of tb_MainControl is

    -- Instruction opcode encoding
    constant LW_INST     : std_logic_vector(6 downto 0) := "0000011";
    constant SW_INST     : std_logic_vector(6 downto 0) := "0100011";
    constant B_TYPE_INST : std_logic_vector(6 downto 0) := "1100011";
    constant R_TYPE_INST : std_logic_vector(6 downto 0) := "0110011";
    constant I_TYPE_INST : std_logic_vector(6 downto 0) := "0010011";

    component MainControl is
        port (
            opcode    : in  std_logic_vector(6 downto 0); -- instruction opcode
            reg_write : out std_logic;                    -- register file write control
            alu_op    : out std_logic_vector(1 downto 0); -- 2-bit alu operation selector
            alu_src   : out std_logic;                    -- alu 2nd operand mux selector
            mem_write : out std_logic;                    -- data memory write control
            mem_read  : out std_logic;                    -- data memory read control
            reg_src   : out std_logic;                    -- register file write-back mux selector
            branch    : out std_logic                     -- branch flag
        );
    end component;

    -- DUT signals
    signal w_opcode    : std_logic_vector(6 downto 0);
    signal w_reg_write : std_logic;
    signal w_alu_op    : std_logic_vector(1 downto 0);
    signal w_alu_src   : std_logic;
    signal w_mem_write : std_logic;
    signal w_mem_read  : std_logic;
    signal w_reg_src   : std_logic;
    signal w_branch    : std_logic;

begin
    -- DUT connection
    dut : MainControl
    port map (
        opcode    => w_opcode,
        reg_write => w_reg_write,
        alu_op    => w_alu_op,
        alu_src   => w_alu_src,
        mem_write => w_mem_write,
        mem_read  => w_mem_read,
        reg_src   => w_reg_src,
        branch    => w_branch
    );

    -- Stimulus process
    process
    begin
        -- Test case 1:
        -- LW instruction
        w_opcode <= LW_INST;
        wait for 1 ns;
        assert w_reg_write = '1'
        report "Error: Test case 1 - expected reg_write = '1'" severity error;

        assert w_alu_op = "00"
        report "Error: Test case 1 - expected alu_op = 00" severity error;

        assert w_alu_src = '1'
        report "Error: Test case 1 - expected alu_src = '1'" severity error;

        assert w_mem_write = '0'
        report "Error: Test case 1 - expected mem_write = '0'" severity error;

        assert w_mem_read = '1'
        report "Error: Test case 1 - expected mem_read = '1'" severity error;

        assert w_reg_src = '0'
        report "Error: Test case 1 - expected reg_src = '0'" severity error;

        assert w_branch = '0'
        report "Error: Test case 1 - expected branch = '0'" severity error;

        -- Test case 2:
        -- SW instruction
        w_opcode <= SW_INST;
        wait for 1 ns;

        assert w_reg_write = '0'
        report "Error: Test case 2 - expected reg_write = '0'" severity error;

        assert w_alu_op = "00"
        report "Error: Test case 2 - expected alu_op = 00" severity error;

        assert w_alu_src = '1'
        report "Error: Test case 2 - expected alu_src = '1'" severity error;

        assert w_mem_write = '1'
        report "Error: Test case 2 - expected mem_write = '1'" severity error;

        assert w_mem_read = '0'
        report "Error: Test case 2 - expected mem_read = '0'" severity error;

        assert w_reg_src = '1'
        report "Error: Test case 2 - expected reg_src = '1'" severity error;

        assert w_branch = '0'
        report "Error: Test case 2 - expected branch = '0'" severity error;

        -- Test case 3:
        -- B-type instruction
        w_opcode <= B_TYPE_INST;
        wait for 1 ns;

        assert w_reg_write = '0'
        report "Error: Test case 3 - expected reg_write = '0'" severity error;

        assert w_alu_op = "01"
        report "Error: Test case 3 - expected alu_op = 01" severity error;

        assert w_alu_src = '0'
        report "Error: Test case 3 - expected alu_src = '0'" severity error;

        assert w_mem_write = '0'
        report "Error: Test case 3 - expected mem_write = '0'" severity error;

        assert w_mem_read = '0'
        report "Error: Test case 3 - expected mem_read = '0'" severity error;

        assert w_reg_src = '1'
        report "Error: Test case 3 - expected reg_src = '1'" severity error;

        assert w_branch = '1'
        report "Error: Test case 3 - expected branch = '1'" severity error;

        -- Test case 4:
        -- R-type instruction
        w_opcode <= R_TYPE_INST;
        wait for 1 ns;

        assert w_reg_write = '1'
        report "Error: Test case 4 - expected reg_write = '1'" severity error;

        assert w_alu_op = "10"
        report "Error: Test case 4 - expected alu_op = 10" severity error;

        assert w_alu_src = '0'
        report "Error: Test case 4 - expected alu_src = '0'" severity error;

        assert w_mem_write = '0'
        report "Error: Test case 4 - expected mem_write = '0'" severity error;

        assert w_mem_read = '0'
        report "Error: Test case 4 - expected mem_read = '0'" severity error;

        assert w_reg_src = '1'
        report "Error: Test case 4 - expected reg_src = '1'" severity error;

        assert w_branch = '0'
        report "Error: Test case 4 - expected branch = '0'" severity error;

        -- Test case 5:
        -- I-type instruction
        w_opcode <= I_TYPE_INST;
        wait for 1 ns;

        assert w_reg_write = '1'
        report "Error: Test case 5 - expected reg_write = '1'" severity error;

        assert w_alu_op = "11"
        report "Error: Test case 5 - expected alu_op = 11" severity error;

        assert w_alu_src = '1'
        report "Error: Test case 5 - expected alu_src = '1'" severity error;

        assert w_mem_write = '0'
        report "Error: Test case 5 - expected mem_write = '0'" severity error;

        assert w_mem_read = '0'
        report "Error: Test case 5 - expected mem_read = '0'" severity error;

        assert w_reg_src = '1'
        report "Error: Test case 5 - expected reg_src = '1'" severity error;

        assert w_branch = '0'
        report "Error: Test case 5 - expected branch = '0'" severity error;

        -- Clear inputs
        w_opcode <= (others => '0');
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;