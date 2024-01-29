while true; do (echo "%CPU %MEM ARGS $(date)" && ps -e -T -o pcpu,pmem,args,psr --sort=pcpu) >> ps.log; sleep 1; done &
# while true; do (echo "$(date)" && ethtool -S eno1d1 ) >> ethtool.log; sleep 1; done
