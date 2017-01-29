#!/bin/sh -f
bin_path="/opt/Mentor/questasim/bin"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep source ./M1_M2_tb_compile.do 2>&1 | tee -a compile.log
