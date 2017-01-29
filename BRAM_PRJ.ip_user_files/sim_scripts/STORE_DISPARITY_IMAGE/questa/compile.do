vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"./../../../../BRAM_PRJ.srcs/sources_1/ip/STORE_DISPARITY_IMAGE/STORE_DISPARITY_IMAGE_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

