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
ExecStep $bin_path/vsim -64  -do "do {M1_M2_tb_simulate.do}" -l simulate.log
