#!/bin/bash
#############################################
# TR Murphy
# collect-latency.sh
#
# put your own IP ADDRESS and PORT in below
#
# INSTRUCTIONS:
#   mkdir $HOME/dev
#   cd $HOME/dev
#   python3 -m venv `pwd`
#   pip3 install tcp-latency
#   chmod 755 ./collect-latency.sh
#   nohup ./collect-latency.sh &
#
# OUTPUT:
# 12.192.234.186: tcp seq=0 port=22221 timeout=5 time=42.04943589866161 ms
# 12.192.234.186: tcp seq=1 port=22221 timeout=5 time=41.00338649004698 ms
# 12.192.234.186: tcp seq=2 port=22221 timeout=5 time=41.26440268009901 ms
# 12.192.234.186: tcp seq=3 port=22221 timeout=5 time=40.49915075302124 ms
# 12.192.234.186: tcp seq=4 port=22221 timeout=5 time=40.718947537243366 ms
#############################################

. $HOME/dev/bin/activate

LOGFILE="/var/tmp/timelog"
IPADDY="12.12.12.12"
PORT="1212"

while [ true ]
do
  VER=`date +"%H%M"`
  DAY=`date +"%A"`

  if [ $VER -eq "0000" ]
  then
    if [ -f ${LOGFILE} ]
    then
      mv ${LOGFILE}  ${LOGFILE}.OLD
    fi
  fi

  tcp-latency ${IPADDY} --port ${PORT} | grep 'time='   >> ${LOGFILE}
  sleep 25
done

exit 0
