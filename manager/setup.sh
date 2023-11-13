cd ~/cgroup-benchmark/

git pull
cd manager/

chmod +x monitor.sh
chmod +x run-fig1-experiment-server.sh
chmod +x run-fig2-experiment-server.sh
chmod +x run-fig3-experiment-server.sh
chmod +x run-fig1-experiment-client.sh

sudo apt-get update
sudo apt-get install cgroup-tools

cd ../tasks/tcp_server
make clean; make

cd ../tasks/multi_tcp_server
make clean; make

cd ../tasks/matrix_multiplier
make clean; make

cd ../../

echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
