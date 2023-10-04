vlib work
vlog -sv +define+XIL_TIMING dut_tb.sv pipe_tb.sv mem_read_A.sv mem_read_B.sv
vlog post-par.v 
vlog -novopt +define+XIL_TIMING /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/FDRE.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/FDSE.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT1.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT2.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT6.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT4.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT3.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/LUT5.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/CARRY4.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/DSP48E1.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/unisims/GND.v /opt/Xilinx/Vivado/2022.1/data/verilog/src/glbl.v
vsim -GM=4 -GN=4 -novopt work.glbl dut_tb
log -r /*
add wave sim:/dut_tb/*
config wave -signalnamewidth 1
run 200000000 ps
