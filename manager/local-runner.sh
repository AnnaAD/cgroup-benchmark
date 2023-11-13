SERVER_NODE=annaad@ms0909.utah.cloudlab.us
CLIENT_NODE=annaad@ms0914.utah.cloudlab.us

ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ reset --hard
ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ reset --hard 
ssh -i ~/.ssh/cloudlab $SERVER_NODE git -C cgroup-benchmark/ pull 
ssh -i ~/.ssh/cloudlab $CLIENT_NODE git -C cgroup-benchmark/ pull 

# ssh -i ~/.ssh/cloudlab $SERVER_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git
# ssh -i ~/.ssh/cloudlab $CLIENT_NODE git clone https://github.com/AnnaAD/cgroup-benchmark.git

ssh -i ~/.ssh/cloudlab $SERVER_NODE chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $SERVER_NODE sudo ./cgroup-benchmark/manager/setup.sh
ssh -i ~/.ssh/cloudlab $CLIENT_NODE chmod +x cgroup-benchmark/manager/setup.sh 
ssh -i ~/.ssh/cloudlab $CLIENT_NODE sudo ./cgroup-benchmark/manager/setup.sh
