#!/bin/bash

# USAGE: source ./run-fig1-experiment-client.sh <ip> <exp-name> <num clients> <delay>

cd cgroup-benchmark/

echo "connecting to $1"
echo "logging output to $2"

for i in $(eval echo {1..${3}})
do
    ./tasks/multi_tcp_server/client $1 > client-${i}${2}.out&
    sleep $4
end