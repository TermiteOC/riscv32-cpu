# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/immediate-generator/ImmGen.vhd

# Compile testbench file
vcom -2008 common/tb/tb_ImmGen.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_ImmGen.wlf work.tb_ImmGen
add wave *
run 5 ns

quit