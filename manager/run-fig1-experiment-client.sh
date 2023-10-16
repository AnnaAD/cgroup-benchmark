echo "connecting to $1"
echo "logging output to $2"

./tasks/tcp_server/client $1 > $2