# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/shift-left-1/ShiftLeft1.vhd

# Compile testbench file
vcom -2008 common/tb/tb_ShiftLeft1.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_ShiftLeft1.wlf work.tb_ShiftLeft1
add wave *
run 5 ns

quit