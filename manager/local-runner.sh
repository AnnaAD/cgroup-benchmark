#!/bin/bash

SERVER_NODE=annaad@ms0909.utah.cloudlab.us
CLIENT_NODE=annaad@ms0914.utah.cloudlab.us

if [[ "$1" == "pull" ]];
then
    ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ reset --hard
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ reset --hard 
    ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ pull 
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ pull 
fi

if [[ $1 == "pull" || $1 == "setup" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
ssh -i ~/.ssh/cloudlab $CLIENT_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
fi

if [[ $1 == "pull" || $1 == "setup" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/setup.sh
ssh -i ~/.ssh/cloudlab $CLIENT_NODE chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/setup.sh
fi

if [[ $1 == "fig1" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-server.sh 1 1000&
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1 1
fi

if [[ $1 == "kill" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./tasks
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./monitor
fi
