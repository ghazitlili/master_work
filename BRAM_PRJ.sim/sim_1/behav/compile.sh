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
echo "xvlog -m64 --relax -prj TOP_tb_synchronized_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj TOP_tb_synchronized_vlog.prj 2>&1 | tee compile.log
