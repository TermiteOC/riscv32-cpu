# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/instruction-memory/InstMem.vhd

# Compile testbench file
vcom -2008 common/tb/tb_InstMem.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_InstMem.wlf work.tb_InstMem
add wave *
run 30 ns

quit