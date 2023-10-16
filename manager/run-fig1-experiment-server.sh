ifconfig | grep 'inet addr:' | cut -d: -f2

# start server running
./tasks/tcp_server/server > fig1-server.out &


until [[ $(wc -l < fig1-server.out) -gt 5 ]]
do
    echo "waiting for client..."
    sleep 1
done

# time check experiment start, wait to start chaos.
echo $(date)
sleep 30 

echo $(date)
echo "starting matrix multiply"


for i in {1..$1}
do
    ./tasks/matrix_multiplier/matrix 1000 1000 1000&
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





