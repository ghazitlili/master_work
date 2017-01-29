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
ExecStep source ./TOP_tb_synchronized_elaborate.do 2>&1 | tee -a elaborate.log