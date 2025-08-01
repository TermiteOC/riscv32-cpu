# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/alu/Mux2x1_1Bit.vhd
vcom -2008 ../src/common/alu/Mux4x1_1Bit.vhd
vcom -2008 ../src/common/components/FullAdder_1Bit.vhd
vcom -2008 ../src/common/alu/ALU_1Bit.vhd
vcom -2008 ../src/common/alu/ALU_32Bit.vhd

# Compile testbench file
vcom -2008 common/tb/tb_ALU_32Bit.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_ALU_32Bit.wlf work.tb_ALU_32Bit
add wave *
run -all

quit