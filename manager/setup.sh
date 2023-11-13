#!/bin/bash
cd ~/cgroup-benchmark/

git pull
cd manager/

chmod +x monitor.sh
chmod +x run-fig1-experiment-server.sh
chmod +x run-fig1r-experiment-server.sh
chmod +x run-fig2-experiment-server.sh
chmod +x run-fig3-experiment-server.sh
chmod +x run-fig1-experiment-client.sh
chmod +x run-fig4-experiment-client.sh

sudo apt-get update
sudo apt-get install cgroup-tools
apt install python3.10-venv

cd ~/cgroup-benchmark/tasks/tcp_server
make clean; make

cd ~/cgroup-benchmark/tasks/multi_tcp_server
make clean; make

cd ~/cgroup-benchmark/tasks/matrix_multiplier
make clean; make venv

echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
