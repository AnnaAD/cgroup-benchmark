#!/bin/bash

cd cgroup-benchmark/

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.log
./manager/monitor.sh &
# start server running
./tasks/multi_tcp_server/server_mm > fig1-server.out &
#taskset -p -c 0-7 $!


until [[ $(wc -l < fig1-server.out) -gt 5 ]]
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
    ./tasks/matrix_multiplier/matrix $2 $2 $2 1 > mm-${i}.out&
    pids[${i}]=$!
    #taskset -p -c 8-15 $(pids[${i}])
    echo $(date)
    #sleep 10
done

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)
