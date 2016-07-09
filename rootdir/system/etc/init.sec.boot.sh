#!/system/bin/sh

echo "init.sec.boot.sh: start" > /dev/kmsg

# start deferred initcalls
cat /proc/deferred_initcalls

## strace for system_server
#str=""
#while [ "$str" = "" ]; do
#  str=`ps | grep system_server`
#  sleep 0.1
#done
#
#pid=${str:10:4}
#echo "init.sec.boot.sh: strace -tt -T -o /data/log/strace.txt -p ${pid}" > /dev/kmsg
#strace -tt -T -o /data/log/strace.txt -p ${pid}

# Bring up core one or all depend on booting requirement
# As mpdecision is removed, there is core control hole between main<--->late_start service
echo 1 > /sys/devices/system/cpu/cpu1/online
#echo 1 > /sys/devices/system/cpu/cpu2/online
#echo 1 > /sys/devices/system/cpu/cpu3/online
