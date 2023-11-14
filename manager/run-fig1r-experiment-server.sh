#!/bin/bash

cd cgroup-benchmark/

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.out
./manager/monitor.sh &
# start server running
./tasks/multi_tcp_server/server > fig1-server.out &

echo $(date)
echo "starting matrix multiply"


for i in $(eval echo {1..${1}})
do
    tasks/matrix_multiplier/venv/bin/python tasks/matrix_multiplier/matrix.py $2 > mm-${i}.out&
    pids[${i}]=$!
    echo $(date)
    #sleep 10
done

echo $(date)

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)


