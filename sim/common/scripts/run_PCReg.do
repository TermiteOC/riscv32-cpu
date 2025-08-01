# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/pc/PCReg.vhd

# Compile testbench file
vcom -2008 common/tb/tb_PCReg.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_PCReg.wlf work.tb_PCReg
add wave *
run 10 ns

quit