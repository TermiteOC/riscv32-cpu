# Change to simulation directory
cd sim

# Create work library if missing
if {![file exists work]} {
    vlib work
}
vmap work work

# Compile source files
vcom -2008 ../src/common/main-control/MainControl.vhd

# Compile testbench file
vcom -2008 common/tb/tb_MainControl.vhd

# Run simulation and save waveform
vsim -wlf waveforms/tb_MainControl.wlf work.tb_MainControl
add wave *
run 10 ns

quit