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
ExecStep $xv_path/bin/xsim TOP_tb_synchronized_behav -key {Behavioral:sim_1:Functional:TOP_tb_synchronized} -tclbatch TOP_tb_synchronized.tcl -log simulate.log
