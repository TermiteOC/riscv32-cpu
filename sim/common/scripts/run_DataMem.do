# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/data-memory/DataMem.vhd

# Compile testbench file
vcom -2008 common/tb/tb_DataMem.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_DataMem.wlf work.tb_DataMem
add wave *
run 20 ns

quit