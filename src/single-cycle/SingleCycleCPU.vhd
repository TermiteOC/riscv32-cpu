-------------------------------------------------------------------------------
-- Module: SingleCycleCPU
-- Description: 
--   - Single-cycle 32-bit RISC-V (RV32I subset) processor implementation.
--   - Supports the following instructions:
--       - Load/Store: LW, SW
--       - B-type: BEQ
--       - R-type: ADD, SUB, SLT, OR, AND
--       - I-type: ADDI, ORI, ANDI
--   - Implements a Harvard-style architecture with separate instruction and data memories.
--   - All instructions complete in a single clock cycle.
-- Author: Levy Elmescany
-- Date: 2026-01-16
-- License: MIT
-- Inputs:
--   - clk: System clock.
--   - rst: Synchronous reset signal. When asserted the program counter is reset.
-- Outputs: Outputs exist for debugging purposes.
--   - alu_out: Output of the ALU.
--   - pc_out: Current value of the program counter.
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes:
--   - Instruction and data memories are word-addressed and store up to
--     1024 words (2^10 locations).
--   - Since instructions and data are 32 bits wide, the two least significant
--     bits of the byte address are discarded when accessing memory
--     (addr = PC[11:2] or ALU_out[11:2]).
--   - Branch target addresses are computed by shifting the immediate left
--     by one bit and adding it to the current PC (the immediate of the BEQ
--     instruction is already a multiple of 2, therefore the instruction needs
--     to be doubled only once in order to become word-aligned).
--   - The immediates from B-type instructions are already 2-byte aligned, but
--     to obtain a word-aligned (4-byte-aligned) branch target address, a shift left
--     unit is used rather than making the immediate generator handle it.
-- Simulation: To be verified by tb_SingleCycleCPU testbench
-- Revision History:
--   Rev 1.0 - 2026-01-16 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SingleCycleCPU is
    port (
        clk     : in  std_logic;                     -- clock
        rst     : in  std_logic;                     -- reset
        alu_out : out std_logic_vector(31 downto 0); -- alu result
        pc_out  : out std_logic_vector(31 downto 0)  -- pc output
    );
end SingleCycleCPU;

architecture rtl of SingleCycleCPU is

    component PCReg is
        port (
            d   : in  std_logic_vector(31 downto 0); -- data input
            rst : in  std_logic;                     -- reset
            clk : in  std_logic;                     -- clock
            q   : out std_logic_vector(31 downto 0)  -- data output
        );
    end component;

    component InstMem is
        generic 
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );

        port 
        (
            addr : in std_logic_vector((ADDR_WIDTH - 1) downto 0); -- instruction address
            q    : out std_logic_vector((DATA_WIDTH - 1) downto 0) -- instruction output
        );
    end component;

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

    component RegFile is
        port (
            read_addr_1 : in  std_logic_vector(4 downto 0);  -- 1st read register address
            read_addr_2 : in  std_logic_vector(4 downto 0);  -- 2nd read register address
            write_addr  : in  std_logic_vector(4 downto 0);  -- write register address
            write_data  : in  std_logic_vector(31 downto 0); -- data input
            reg_write   : in  std_logic;                     -- write control flag
            clk         : in  std_logic;                     -- clock
            read_data_1 : out std_logic_vector(31 downto 0); -- 1st data output
            read_data_2 : out std_logic_vector(31 downto 0)  -- 2nd data output
        );
    end component;

    component ImmGen is
        port (
            inst : in  std_logic_vector(31 downto 0); -- instruction
            imm  : out std_logic_vector(31 downto 0)  -- sign-extended immediate value
        );
    end component;

    component ShiftLeft1 is
        port (
            d       : in  std_logic_vector(31 downto 0); -- data input
            shifted : out std_logic_vector(31 downto 0)  -- shifted output
        );
    end component;

    component ALUControl is
        port (
            alu_op : in  std_logic_vector(1 downto 0); -- main control generated bits
            f7     : in  std_logic;                    -- funct7[5] / instruction[30]
            f3     : in  std_logic_vector(2 downto 0); -- funct3 field from instruction
            sel    : out std_logic_vector(3 downto 0)  -- selected alu control lines
        );
    end component;

    component ALU_32Bit is
        port (
            a    : in  std_logic_vector(31 downto 0); -- 1st operand
            b    : in  std_logic_vector(31 downto 0); -- 2nd operand
            op   : in  std_logic_vector(3 downto 0);  -- operation selector
            zero : out std_logic;                     -- zero flag
            res  : out std_logic_vector(31 downto 0)  -- result
        );
    end component;

    component DataMem is
        generic 
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );

        port 
        (
            clk        : in  std_logic;                                 -- clock
            addr       : in  std_logic_vector((ADDR_WIDTH-1) downto 0); -- address
            write_data : in  std_logic_vector((DATA_WIDTH-1) downto 0); -- write input
            mem_write  : in  std_logic := '0';                          -- write control
            mem_read   : in  std_logic := '0';                          -- read control
            read_data  : out std_logic_vector((DATA_WIDTH -1) downto 0) -- read output
        );
    end component;

    component Adder_32Bit is
        port (
            a   : in  std_logic_vector(31 downto 0); -- 1st operand
            b   : in  std_logic_vector(31 downto 0); -- 2nd operand
            sum : out std_logic_vector(31 downto 0)  -- result of the sum
        );
    end component;

    component Mux2x1_32Bit is
        port (
            a   : in  std_logic_vector(31 downto 0); -- 1st input
            b   : in  std_logic_vector(31 downto 0); -- 2nd input
            sel : in  std_logic;                     -- selector
            res : out std_logic_vector(31 downto 0)  -- chosen output
        );
    end component;

    -- Datapath signals
    signal w_pc_out       : std_logic_vector(31 downto 0);
    signal w_inst         : std_logic_vector(31 downto 0);
    signal w_imm          : std_logic_vector(31 downto 0);
    signal w_read_1       : std_logic_vector(31 downto 0);
    signal w_read_2       : std_logic_vector(31 downto 0);
    signal w_alu_in       : std_logic_vector(31 downto 0);
    signal w_alu_out      : std_logic_vector(31 downto 0);
    signal w_read_data    : std_logic_vector(31 downto 0);
    signal w_write_data   : std_logic_vector(31 downto 0);
    signal w_offset       : std_logic_vector(31 downto 0);
    signal w_branch_inst  : std_logic_vector(31 downto 0);
    signal w_pc4          : std_logic_vector(31 downto 0);
    signal w_pc_in        : std_logic_vector(31 downto 0);

    -- Control signals
    signal w_reg_write    : std_logic;
    signal w_alu_op       : std_logic_vector(1 downto 0);
    signal w_alu_src      : std_logic;
    signal w_mem_write    : std_logic;
    signal w_mem_read     : std_logic;
    signal w_reg_src      : std_logic;
    signal w_branch       : std_logic;
    signal w_op           : std_logic_vector(3 downto 0);
    signal w_zero         : std_logic;
    signal w_branch_taken : std_logic;

begin
    -- Combinational Logic
    w_branch_taken <= w_branch and w_zero; -- Branch is taken only if it is a BEQ instruction and the ALU result is zero

    -- Expose ALU result and PC output for external observation
    alu_out <= w_alu_out;
    pc_out <= w_pc_out;

    -- Component Instantiations
    pc : PCReg
    port map (
        d   => w_pc_in,
        rst => rst,
        clk => clk,
        q   => w_pc_out
    );

    instruction_memory : InstMem
    generic map (
        DATA_WIDTH => 32,
        ADDR_WIDTH => 10
    )
    port map (
        addr => w_pc_out(11 downto 2),
        q    => w_inst
    );

    main_control : MainControl
    port map (
        opcode    => w_inst(6 downto 0),
        reg_write => w_reg_write,
        alu_op    => w_alu_op,
        alu_src   => w_alu_src,
        mem_write => w_mem_write,
        mem_read  => w_mem_read,
        reg_src   => w_reg_src,
        branch    => w_branch
    );

    register_file : RegFile
    port map (
        read_addr_1 => w_inst(19 downto 15),
        read_addr_2 => w_inst(24 downto 20),
        write_addr  => w_inst(11 downto 7),
        write_data  => w_write_data,
        reg_write   => w_reg_write,
        clk         => clk,
        read_data_1 => w_read_1,
        read_data_2 => w_read_2
    );

    immediate_generator : ImmGen
    port map (
        inst => w_inst,
        imm  => w_imm
    );

    shift_left_1 : ShiftLeft1
    port map (
        d       => w_imm,
        shifted => w_offset
    );

    alu_control : ALUControl
    port map (
        alu_op => w_alu_op,
        f7     => w_inst(30),
        f3     => w_inst(14 downto 12),
        sel    => w_op
    );

    alu : ALU_32Bit
    port map (
        a    => w_read_1,
        b    => w_alu_in,
        op   => w_op,
        zero => w_zero,
        res  => w_alu_out
    );

    data_memory : DataMem
    generic map (
        DATA_WIDTH => 32,
        ADDR_WIDTH => 10
    )
    port map (
        clk        => clk,
        addr       => w_alu_out(11 downto 2),
        write_data => w_read_2,
        mem_write  => w_mem_write,
        mem_read   => w_mem_read,
        read_data  => w_read_data
    );

    adder_pc4 : Adder_32Bit
    port map (
        a   => w_pc_out,
        b   => std_logic_vector(to_unsigned(4, 32)), -- 4 as unsigned 32 bit
        sum => w_pc4
    );

    adder_offset : Adder_32Bit
    port map (
        a   => w_pc_out,
        b   => w_offset,
        sum => w_branch_inst
    );

    mux_alu_in : Mux2x1_32Bit
    port map (
        a   => w_read_2,
        b   => w_imm,
        sel => w_alu_src,
        res => w_alu_in
    );

    mux_write_data : Mux2x1_32Bit
    port map (
        a   => w_read_data,
        b   => w_alu_out,
        sel => w_reg_src,
        res => w_write_data
    );

    mux_pc_in : Mux2x1_32Bit
    port map (
        a   => w_pc4,
        b   => w_branch_inst,
        sel => w_branch_taken,
        res => w_pc_in
    );
end rtl;
