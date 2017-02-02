#!/bin/bash -f
xv_path="/home/ghazi/Documents/Vivado/2015.3"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 425eabcb872c4ae09d82e9c2e207ebd8 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot TOP_tb_synchronized_behav xil_defaultlib.TOP_tb_synchronized xil_defaultlib.glbl -log elaborate.log
