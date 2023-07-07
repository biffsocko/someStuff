#!/bin/bash
##########################################################################################
# TR Murphy
# collect-latency.sh
#
# uses: https://pypi.org/project/tcp-latency/
# put your own IP ADDRESS and PORT in below
#
# INSTRUCTIONS:
#   mkdir $HOME/dev
#   cd $HOME/dev
#   python3 -m venv `pwd`
#   pip3 install tcp-latency
#   chmod 755 ./collect-latency.sh
#
# ADD TO CRON:
# this will run every minute and will enable the logfile
# turnover
#
# * * * * * /home/unixsa/dev/collect-latency.sh
#
#
# OUTPUT:
# 12.192.234.186: tcp seq=0 port=22221 timeout=5 time=42.04943589866161 ms
# 12.192.234.186: tcp seq=1 port=22221 timeout=5 time=41.00338649004698 ms
# 12.192.234.186: tcp seq=2 port=22221 timeout=5 time=41.26440268009901 ms
# 12.192.234.186: tcp seq=3 port=22221 timeout=5 time=40.49915075302124 ms
# 12.192.234.186: tcp seq=4 port=22221 timeout=5 time=40.718947537243366 ms
#
# NOTES:
##########################################################################################

# source in the python environment to run tcp-latency
. /home/unixsa/dev/bin/activate


IPADDR="12.12.12.12"    # put remote IP here
PORT="1212"             #  put remote port here

VER=`date +"%H%M"`
DAY=`date -d "yesterday" +%A`
LOGFILE="/var/tmp/timelog"


# its a new day - start with a new log file
if [ $VER -eq "0000" ]
then
  if [ -f ${LOGFILE} ]
  then
    # if there is a log file from last week
    # this will overwrite it - we'll keep
    # a full week of logs this week without
    # overgrowning or having to do further cleanup
    mv -f  ${LOGFILE}  ${LOGFILE}.${DAY}
  fi
fi

tcp-latency ${IPADDR} --port ${PORT} | grep 'time='   >> ${LOGFILE}
exit 0
