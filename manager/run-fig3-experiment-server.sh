#!/bin/bash

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.out
./manager/monitor.sh &

sudo mkdir /sys/fs/cgroup/group1
sudo mkdir /sys/fs/cgroup/group2

echo $3 > /sys/fs/cgroup/group1/cpu.weight
echo $4 > /sys/fs/cgroup/group2/cpu.weight

# start server running
./tasks/multi_tcp_server/server > fig3-server.out &
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
    tasks/matrix_multiplier/venv/bin/python tasks/matrix_multiplier/matrix.py $2 > mm-${i}.out &
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