######################################################################
#
# File name : M1_M2_tb_compile.do
# Created on: Fri Jul 29 14:23:24 CEST 2016
#
# Auto generated by Vivado for 'post-synthesis' simulation
#
######################################################################
vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -64 -incr -work xil_defaultlib  \
"./M1_M2_tb_func_synth.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/READ_FILE_BRAM_TB.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/READ_FILE_TB_PAR.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/TB_tmp.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/tb_statem.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/Top_tb.v" \
"./../../../../BRAM_PRJ.srcs/sim_1/new/M1_M2_tb.v" \


# compile glbl module
vlog -work xil_defaultlib "glbl.v"

