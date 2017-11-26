#!/bin/bash

numofprocess=0
processid()
{
  a=$(ps aux | grep 'clientedge/trunk/app.js' | grep -v grep | awk '{print $2}')
  set -f
  array=(${a// / })
  echo -ne $a
  numofprocess=${#array[@]}
}

status_service()
{
        processid
        if [[ $numofprocess -ge 1 ]]
        then
            echo " :clientedge service is running"
        else
            echo "clientedge service is not running"
        fi
}
start_service()
{
   processid
   if [[ $numofprocess -ge 1 ]]
   then
            echo "  :clientedge service is already running"
   else
        nohup nodejs /home/vimo/components/clientedge/trunk/app.js > /home/vimo/contlogs/clientedge.log 2>&1 &
        echo -ne "process started and PID : "
        processid
        echo ""

   fi
}

stop_service()
{
         processid
         if [[ $numofprocess == 0 ]]
         then
               echo "process is not running"
         else
              echo " :stopping process"
              kill -9 $(ps aux | grep 'clientedge/trunk/app.js' | grep -v grep | awk '{print $2}')
        fi
}
                                                                                                                                                          1,1           Top
case "$1" in
start)
        start_service
        ;;
status)
        status_service
        ;;
restart)
        stop_service
        start_service
        ;;

stop)
        stop_service
        ;;
*)
    echo "Usage: $0 {satrt|status|stop|restart}" >&2
    exit 0
    ;;
esac

exit $rc
