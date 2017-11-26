#!/bin/bash

usage()
{
  echo -e "This host has following services \n 1 Haproxy \n 2 twsagent \n 3 Relayserver \n 4 centralacess(ssh) \n 5 pptpd \n 6 glusterfs volumes \n 7 glusterfs Server \n"

}
usage
read -p "enter the service number to restart or enter 0 to exit : " v
case "$v" in
1)
        if ping -c 1 172.14.2.73 > /dev/null
        then
          echo -e "haproxy: ip assigned and start haproxy \n docker exec -it haproxy service haproxy restart"
        else
            echo -e "haproxy: ip is assigning and starting haproxy"
            pipework br0 -i eth0 haproxy 172.14.2.73/32@172.14.2.13
            docker exec -it haproxy service haproxy restart
        fi
        ;;


2)
        service twsagent restart
        ;;

3)
       if ps -ax | grep 'relay[srv]' > /dev/null
       then
                echo "relay server is running"
       else
         echo "starting relay server"
         /root/relay5/sqlwebd5 -w 8089 -u admin -p admin
         /root/relay5/relaysrv5 -n 8 -p 21080 -c 3000 -L 21081 -u 1701 -t 1701 -r 50000-60000 --listen
        fi
        ;;

4)
        docker restart centralacess
        pipework br0 -i eth0 centralaccess 172.14.2.4/32@172.14.2.13
        docker exec -i centralacess /opt/vimoservices restart
        ;;

5)
        service pptpd restart
        ;;

6)if ps -ax | grep '/usr/sbin/glusterfs --volfile-id=/vimo_volume --volfile-server=[0-9]*.[0-9]*.[0-9]*.[0-9]* /home/vimo/audiofiles' > /dev/null
        then
           echo "glusterfs audio volume there"
        else
                echo -e "starting glusterfs volume"
                fusermount -uz /home/vimo/audiofiles
                mkdir -p /home/vimo/audiofiles
                sudo mount -t glusterfs 172.14.3.14:/vimo_volume /home/vimo/audiofiles
        fi
        ;;

7)
        if ps -ax | grep '[g]lusterd.pid' > /dev/null
        then
          echo -e "glusterfs server is running"
        else
          echo -e "starting glusterfs server"
          service glusterfs-server restart
        fi
        ;;
0)
        exit 0
        ;;
        *)
    echo "select correct option"
    usage
    exit 0
    ;;
esac

                                                                                                                                                          78,0-1        Bot


