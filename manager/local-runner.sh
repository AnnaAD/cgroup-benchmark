#!/bin/bash

SERVER_NODE=annaad@ms1041.utah.cloudlab.us
CLIENT_NODE=annaad@ms1020.utah.cloudlab.us

kill_ssh () {
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./cgroup-benchmark/manager/
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./tasks
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f tasks/matrix_multiplier
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f tasks/matrix_multiplier
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo pkill -9 -f ./manager/monitor.sh
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group1
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group2
}

if [[ "$1" == "pull" ]];
then
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo git -C cgroup-benchmark/ clean  -d  -f .
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo git -C cgroup-benchmark/ clean  -d  -f .
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo git -C cgroup-benchmark/ reset --hard
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo git -C cgroup-benchmark/ reset --hard 
    ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo git -C cgroup-benchmark/ pull 
    ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo git -C cgroup-benchmark/ pull 
fi

if [[ $1 == "init" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
ssh -i ~/.ssh/cloudlab $CLIENT_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
source configure-kernel.sh $SERVER_NODE
source configure-kernel.sh $CLIENT_NODE
fi

if [[ $1 == "pull" ]] || [[ $1 == "setup" ]]
then
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/setup.sh
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/setup.sh
source setup-for-benchmarking.sh $SERVER_NODE
source setup-for-benchmarking.sh $CLIENT_NODE
fi

if [[ $1 == "fig1" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/ethtool.log

DST=fig1-affinity
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-server.sh 1 500 > ../data/$DST/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ethtool.log ../data/$DST/
fi

if [[ $1 == "fig1r" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1r-experiment-server.sh 1 500 > ../data/fig1r/server.out&
sleep 30
echo $(date)
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1r 1000 0&
sleep 30
echo $(date)

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig1r/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig1r/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig1r.out ../data/fig1r/
fi


if [[ $1 == "fig2" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig2.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm ~/cgroup-benchmark/mm-1.out

ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group1
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group2

DST=fig2-light
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig2-experiment-server.sh 1 500 weight 2048 1024 > ../data/$DST/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig2 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig2.out ../data/$DST/
fi

if [[ $1 == "fig2b" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf /users/annaad/cgroup-benchmark/client-\*fig2b.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group1
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group2

DST=fig2b-light
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig2-experiment-server.sh 1 500 max "max 100000" "50000 100000" > ../data/$DST/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig2b 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig2b.out ../data/$DST/
fi

if [[ $1 == "kill" ]]
then
kill_ssh
fi

if [[ $1 == "fig4" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig4.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm ~/cgroup-benchmark/mm-1.out

DST=fig4-light
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig4-experiment-server.sh 1 500 > ../data/$DST/server.out&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig4 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig4.out ../data/$DST/
fi

if [[ $1 == "fig2r" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig3-experiment-server.sh 1 500 weight 2048 1024 > ../data/$DST/server.out&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig3 100 0&
sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig2r/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig2r/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig3.out ../data/fig2r/
fi


if [[ $1 == "fig3" ]];
then

ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig3.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm ~/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group1
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group2

DST=fig3-light
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig3-experiment-server.sh 1 500 weight 2048 1024 > ../data/$DST/server.out&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig3 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig3.out ../data/$DST/
fi

if [[ $1 == "fig3b" ]];
then

ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig3b.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm ~/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group1
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo rmdir /sys/fs/cgroup/group2
DST=fig3b-100
mkdir ../data/$DST
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig3-experiment-server.sh 1 500 max "max 100000" "50000 100000" > ../data/$DST/server.out&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig3b 16 0&
sleep 60

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig3b.out ../data/$DST/
fi


if [[ $1 == "fig1rnm" ]];
then
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1rnm-experiment-server.sh > ../data/fig1rnm/server.out&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR fig1rnm 100 0&
sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/fig1rnm/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/fig1rnm/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*fig1rnm.out ../data/fig1rnm/
fi


if [[ $1 == "fig1-scale" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/ethtool.log

DST=fig1-scale
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-server.sh 1 500 > ../data/$DST/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR nobe-fig1 16 1&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR be-fig1 16 1&
sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*be-fig1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ethtool.log ../data/$DST/
fi

if [[ $1 == "fig2-scale" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig2.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/ethtool.log

DST=fig2-scale
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig2-experiment-server.sh 1 500 weight 2048 1024 > ../data/$DST/server.log&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR nobe-fig2 16 1&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR be-fig2 16 1&

sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*be-fig2.out ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ethtool.log ../data/$DST/
fi

if [[ $1 == "fig3-scale" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig3.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/ethtool.log

DST=fig3-scale
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig3-experiment-server.sh 1 500 weight 2048 1024 > ../data/$DST/server.out&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR nobe-fig3 16 1&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR be-fig3 16 1&
sleep 30


kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*be-fig3.out ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ethtool.log ../data/$DST/
fi

if [[ $1 == "fig4-scale" ]];
then
ssh -i ~/.ssh/cloudlab $CLIENT_NODE rm -rf ~/cgroup-benchmark/client-\*fig4.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/mm-1.out
ssh -i ~/.ssh/cloudlab $SERVER_NODE rm /users/annaad/cgroup-benchmark/ethtool.log

DST=fig4-scale
mkdir ../data/$DST 
IP_ADDR=`ssh -i ~/.ssh/cloudlab $SERVER_NODE hostname -I | cut -f2 -d' '`
echo $IP_ADDR
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/run-fig4-experiment-server.sh 1 500 > ../data/$DST/server.out&
sleep 1
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR nobe-fig4 16 1&
sleep 30
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo pkill -9 -f ./tasks
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/run-fig1-experiment-client.sh $IP_ADDR be-fig4 16 1&
sleep 30

kill_ssh

scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ps.log ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/mm-1.out ../data/$DST/
scp -i ~/.ssh/cloudlab $CLIENT_NODE:~/cgroup-benchmark/client-\*be-fig4.out ../data/$DST/
scp -i ~/.ssh/cloudlab $SERVER_NODE:~/cgroup-benchmark/ethtool.log ../data/$DST/
fi