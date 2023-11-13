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

sleep 30

# time check experiment start, wait to start chaos.
echo $(date)


