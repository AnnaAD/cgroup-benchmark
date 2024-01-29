#!/bin/bash

#!/bin/bash

cd cgroup-benchmark/

ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.log
./manager/monitor.sh &

sudo mkdir /sys/fs/cgroup/group1
sudo mkdir /sys/fs/cgroup/group2

sudo echo $4 > /sys/fs/cgroup/group1/cpu.$3
sudo echo $5 > /sys/fs/cgroup/group2/cpu.$3

sudo echo /sys/fs/cgroup/group1/cpu.$3
sudo echo /sys/fs/cgroup/group2/cpu.$3

sudo cat /sys/fs/cgroup/group1/cpu.$3
sudo cat /sys/fs/cgroup/group2/cpu.$3

# start server running
./tasks/multi_tcp_server/server_mm > fig2-server.out &
echo $! > /sys/fs/cgroup/group1/cgroup.procs

until [[ $(wc -l < fig2-server.out) -gt 5 ]]
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
    echo $! > /sys/fs/cgroup/group2/cgroup.procs
    echo $(date)
    cat /sys/fs/cgroup/group2/cgroup.procs
    #sleep 10
done

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)