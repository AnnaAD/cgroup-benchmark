#!/bin/bash

SERVER_NODE=annaad@ms0909.utah.cloudlab.us
CLIENT_NODE=annaad@ms0914.utah.cloudlab.us

kill_ssh () {
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./tasks
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f tasks/matrix_multiplier
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f tasks/matrix_multiplier
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./manager/monitor.sh
}

if [[ "$1" == "pull" ]];
then
    ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ reset --hard
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ reset --hard 
    ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ pull 
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ pull 
fi

if [[ $1 == "init" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
ssh -i ~/.ssh/cloudlab $CLIENT_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
fi

if [[ $1 == "pull" ]] || [[ $1 == "setup" ]]
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
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-server.sh 1 2000 > ../data/fig1-new/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1 1 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig1-new/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig1-new/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-1fig1.out ../data/fig1-new/
fi

if [[ $1 == "fig1r" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1r-experiment-server.sh 1 2000 > ../data/fig1r/server.out&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1r 100 0&
sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig1r/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig1r/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-*fig1r.out ../data/fig1r/
fi


if [[ $1 == "fig2" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig2-experiment-server.sh 1 2000 weight 2048 1024 > ../data/fig2-new/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig2 1 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig2-new/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig2-new/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-1fig2.out ../data/fig2-new/
fi

if [[ $1 == "fig2b" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig2-experiment-server.sh 1 2000 max "1 1" "50 100" > ../data/fig2b-new/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig2b 1 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig2b-new/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig2b-new/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-1fig2b.out ../data/fig2b-new/
fi

if [[ $1 == "kill" ]]
then
kill_ssh
fi
