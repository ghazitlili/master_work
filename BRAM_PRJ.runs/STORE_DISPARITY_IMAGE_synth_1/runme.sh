#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/ghazi/Documents/SDK/2015.3/bin:/home/ghazi/Documents/Vivado/2015.3/ids_lite/ISE/bin/lin64:/home/ghazi/Documents/Vivado/2015.3/bin
else
  PATH=/home/ghazi/Documents/SDK/2015.3/bin:/home/ghazi/Documents/Vivado/2015.3/ids_lite/ISE/bin/lin64:/home/ghazi/Documents/Vivado/2015.3/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/home/ghazi/Documents/Vivado/2015.3/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/ghazi/Documents/Vivado/2015.3/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD=/home/ghazi/Desktop/master_work/BRAM_PRJ/BRAM_PRJ.runs/STORE_DISPARITY_IMAGE_synth_1
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log STORE_DISPARITY_IMAGE.vds -m64 -mode batch -messageDb vivado.pb -notrace -source STORE_DISPARITY_IMAGE.tcl
