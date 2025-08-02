# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/pkg/CommonTypes.vhd
vcom -2008 ../src/common/register-file/RegDecoder.vhd
vcom -2008 ../src/common/register-file/Reg_32Bit.vhd
vcom -2008 ../src/common/register-file/Mux32x1_32Bit.vhd
vcom -2008 ../src/common/register-file/RegFile.vhd

# Compile testbench file
vcom -2008 common/tb/tb_RegFile.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_RegFile.wlf work.tb_RegFile
add wave *
run 15 ns

quit