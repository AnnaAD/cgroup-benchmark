#!/bin/bash

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.out
./manager/monitor.sh &

sudo mkdir /sys/fs/cgroup/group1
sudo mkdir /sys/fs/cgroup/group2

echo $3 > /sys/fs/cgroup/group1/cpu.weight
echo $4 > /sys/fs/cgroup/group2/cpu.weight

# start server running
./tasks/tcp_server/server > fig3-server.out &
echo $! > /sys/fs/cgroup/group1/cgroup.procs

until [[ $(wc -l < fig3-server.out) -gt 5 ]]
do
    echo "waiting for client..."
    sleep 1
done

# time check experiment start, wait to start chaos.
echo $(date)
sleep 30

echo $(date)
echo "starting matrix multiply"


for i in $(eval echo {1..${1}})
do
    ./tasks/matrix_multiplier/matrix $2 $2 $2&
    pids[${i}]=$!
    chrt -i echo $! > /sys/fs/cgroup/group2/cgroup.procs
    echo $(date)
    #sleep 10
done

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)