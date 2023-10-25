ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.out
./manager/monitor.sh &
# start server running
./tasks/tcp_server/server > fig1-server.out &

cgcreate -g *:group1
cgcreate -g *:group2

cgset -r cpu.shares=50 /cgroup/cpu_and_mem/group1
cgset -r cpu.shares=50 /cgroup/cpu_and_mem/group2

# start server running
cgexec -g cpu:group1 ./tasks/tcp_server/server > fig2-server.out &


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
    cgexec -g cpu:group2 ./tasks/matrix_multiplier/matrix $2 $2 $2&
    pids[${i}]=$!
    echo $(date)
    #sleep 10
done

echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)





