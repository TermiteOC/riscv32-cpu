# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/pkg/CommonTypes.vhd

vcom -2008 ../src/common/pc/PCReg.vhd

vcom -2008 ../src/common/instruction-memory/InstMem.vhd

vcom -2008 ../src/common/main-control/MainControl.vhd

vcom -2008 ../src/common/pkg/CommonTypes.vhd
vcom -2008 ../src/common/register-file/RegDecoder.vhd
vcom -2008 ../src/common/register-file/Reg_32Bit.vhd
vcom -2008 ../src/common/register-file/Mux32x1_32Bit.vhd
vcom -2008 ../src/common/register-file/RegFile.vhd

vcom -2008 ../src/common/immediate-generator/ImmGen.vhd

vcom -2008 ../src/common/shift-left-1/ShiftLeft1.vhd

vcom -2008 ../src/common/alu-control/ALUControl.vhd

vcom -2008 ../src/common/alu/Mux2x1_1Bit.vhd
vcom -2008 ../src/common/alu/Mux4x1_1Bit.vhd
vcom -2008 ../src/common/components/FullAdder_1Bit.vhd
vcom -2008 ../src/common/alu/ALU_1Bit.vhd
vcom -2008 ../src/common/alu/ALU_32Bit.vhd

vcom -2008 ../src/common/data-memory/DataMem.vhd

vcom -2008 ../src/common/adder/Adder_32Bit.vhd

vcom -2008 ../src/common/multiplexer/Mux2x1_32Bit.vhd

vcom -2008 ../src/single-cycle/SingleCycleCPU.vhd

# Compile testbench file
vcom -2008 single-cycle/tb/tb_SingleCycleCPU.vhd

# Save waveform
vsim -wlf waveforms/tb_SingleCycleCPU.wlf work.tb_SingleCycleCPU

# Add every internal signal wave of top entity
add wave -position end  sim:/tb_singlecyclecpu/dut/clk
add wave -position end  sim:/tb_singlecyclecpu/dut/rst
add wave -position end  sim:/tb_singlecyclecpu/dut/alu_out
add wave -position end  sim:/tb_singlecyclecpu/dut/pc_out
add wave -position end  sim:/tb_singlecyclecpu/dut/w_pc_out
add wave -position end  sim:/tb_singlecyclecpu/dut/w_inst
add wave -position end  sim:/tb_singlecyclecpu/dut/w_imm
add wave -position end  sim:/tb_singlecyclecpu/dut/w_read_1
add wave -position end  sim:/tb_singlecyclecpu/dut/w_read_2
add wave -position end  sim:/tb_singlecyclecpu/dut/w_alu_in
add wave -position end  sim:/tb_singlecyclecpu/dut/w_alu_out
add wave -position end  sim:/tb_singlecyclecpu/dut/w_read_data
add wave -position end  sim:/tb_singlecyclecpu/dut/w_write_data
add wave -position end  sim:/tb_singlecyclecpu/dut/w_offset
add wave -position end  sim:/tb_singlecyclecpu/dut/w_branch_inst
add wave -position end  sim:/tb_singlecyclecpu/dut/w_pc4
add wave -position end  sim:/tb_singlecyclecpu/dut/w_pc_in
add wave -position end  sim:/tb_singlecyclecpu/dut/w_reg_write
add wave -position end  sim:/tb_singlecyclecpu/dut/w_alu_op
add wave -position end  sim:/tb_singlecyclecpu/dut/w_alu_src
add wave -position end  sim:/tb_singlecyclecpu/dut/w_mem_write
add wave -position end  sim:/tb_singlecyclecpu/dut/w_mem_read
add wave -position end  sim:/tb_singlecyclecpu/dut/w_reg_src
add wave -position end  sim:/tb_singlecyclecpu/dut/w_branch
add wave -position end  sim:/tb_singlecyclecpu/dut/w_op
add wave -position end  sim:/tb_singlecyclecpu/dut/w_zero
add wave -position end  sim:/tb_singlecyclecpu/dut/w_branch_taken
add wave -position end  sim:/tb_singlecyclecpu/dut/alu/w_carry
add wave -position end  sim:/tb_singlecyclecpu/dut/alu/w_set_out
add wave -position end  sim:/tb_singlecyclecpu/dut/alu/w_less_in

# Run simulation
run 20 ns

quit