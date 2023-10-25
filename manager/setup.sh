chmod +x monitor.sh
chmod +x run-fig1-experiment-server.sh

apt-get install cgroup-tools

cd tasks/tcp_server
make clean; make

cd ../matrix_multiplier
make clean; make

cd ../../
