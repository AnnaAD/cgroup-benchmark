#!/bin/bash
cd cgroup-benchmark/

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.log
./manager/monitor.sh &

sudo mkdir /sys/fs/cgroup/group1
sudo mkdir /sys/fs/cgroup/group2

echo $4 > /sys/fs/cgroup/group1/cpu.$3
echo $5 > /sys/fs/cgroup/group2/cpu.$3

echo /sys/fs/cgroup/group1/cpu.$3
echo /sys/fs/cgroup/group2/cpu.$3

cat /sys/fs/cgroup/group1/cpu.$3
cat /sys/fs/cgroup/group2/cpu.$3


# start server running
./tasks/multi_tcp_server/server_mm > fig3-server.out &
echo $! > /sys/fs/cgroup/group1/cgroup.procs

# time check experiment start, wait to start chaos.
echo $(date)
sleep 30

echo $(date)
echo "starting matrix multiply"


for i in $(eval echo {1..${1}})
do
    ./tasks/matrix_multiplier/matrix $2 $2 $2 1 > mm-${i}.out &
    pids[${i}]=$!
    echo ${pids[${i}]} > /sys/fs/cgroup/group2/cgroup.procs
    chrt -i -p 0 ${pids[${i}]}
    echo ${pids[${i}]}
    echo $(date)
    #sleep 10
done

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)