ifconfig | grep 'inet ' | cut -d: -f2

rm -rf ps.out
./manager/monitor.sh &
# start server running
./tasks/multi_tcp_server/server > fig1-server.out &


until [[ $(wc -l < fig1-server.out) -gt 5 ]]
do
    echo "waiting for client..."
    sleep 1
done

# time check experiment start, wait to start chaos.
echo $(date)
sleep 30

echo $(date)


echo "waiting for multiplies"
# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
echo $(date)
