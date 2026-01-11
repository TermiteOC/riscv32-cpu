-------------------------------------------------------------------------------
-- Module: MainControl
-- Description: 
--   - Main control unit responsible for the control of CPU datapath and ALU control unit
--   - Provides control bits for the following modules:
--     - Register file
--     - Multiplexers
--     - ALU control
--     - Data memory
-- Author: Levy Elmescany
-- Date: 2026-01-10
-- License: MIT
-- Inputs: opcode
-- Outputs:
--   - reg_write: controls register file write
--   - alu_op: generates additional control signals for ALU control unit
--   - alu_src: selects ALU 2nd operand (0 = register, 1 = immediate)
--   - mem_write: controls data memory write
--   - mem_read: controls data memory read
--   - reg_src: mux select signal for write-back source (0 = data memory result, 1 = ALU result)
--   - branch: controls whether a branch will be taken
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: None.
-- Simulation: Verified via tb_MainControl testbench
-- Revision History:
--   Rev 1.0 - 2026-01-10 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MainControl is
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
end MainControl;

architecture rtl of MainControl is

    -- Instruction opcode encoding
    constant LW_INST     : std_logic_vector(6 downto 0) := "0000011";
    constant SW_INST     : std_logic_vector(6 downto 0) := "0100011";
    constant B_TYPE_INST : std_logic_vector(6 downto 0) := "1100011";
    constant R_TYPE_INST : std_logic_vector(6 downto 0) := "0110011";
    constant I_TYPE_INST : std_logic_vector(6 downto 0) := "0010011";

begin
    -- Combinational Logic
    process(opcode)
    begin
        case opcode is
            when LW_INST =>
                reg_write <= '1';  -- enables write-back of ALU result to register file
                alu_op    <= "00";
                alu_src   <= '1';  -- immediate as 2nd ALU operand
                mem_write <= '0';
                mem_read  <= '1';  -- asserts data memory read enable
                reg_src   <= '0';  -- data memory value as write-back source
                branch    <= '0';

            when SW_INST =>
                reg_write <= '0';
                alu_op    <= "00";
                alu_src   <= '1';  -- immediate as 2nd ALU operand
                mem_write <= '1';  -- asserts data memory write enable
                mem_read  <= '0';
                reg_src   <= '1';  -- defaults to 1, write-back source not used
                branch    <= '0';

            when B_TYPE_INST =>
                reg_write <= '0';
                alu_op    <= "01";
                alu_src   <= '0';  -- register value as 2nd ALU operand
                mem_write <= '0';
                mem_read  <= '0';
                reg_src   <= '1';  -- defaults to 1, write-back source not used
                branch    <= '1';  -- enables branch decision logic

            when R_TYPE_INST =>
                reg_write <= '1';  -- enables write-back of ALU result to register file
                alu_op    <= "10";
                alu_src   <= '0';  -- register value as 2nd ALU operand
                mem_write <= '0';
                mem_read  <= '0';
                reg_src   <= '1';  -- ALU result as write-back source
                branch    <= '0';

            when I_TYPE_INST =>
                reg_write <= '1';  -- enables write-back of ALU result to register file
                alu_op    <= "11";
                alu_src   <= '1';  -- immediate as 2nd ALU operand
                mem_write <= '0';
                mem_read  <= '0';
                reg_src   <= '1';  -- ALU result as write-back source
                branch    <= '0';

            when others =>
                -- defaults every control signal to 0
                reg_write <= '0';
                alu_op    <= "00";
                alu_src   <= '0';
                mem_write <= '0';
                mem_read  <= '0';
                reg_src   <= '0';
                branch    <= '0';
        end case;
    end process;
end rtl;