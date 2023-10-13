
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


for i in {1..5}
do
    ./tasks/matrix_multiplier/matrix 1000 100000 100000&
    echo $(date)
    sleep 10
done

sleep 200




