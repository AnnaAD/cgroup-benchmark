#!/bin/bash

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 address"
  exit 1
fi

DIR=~/.ssh/cloudlab

ssh -i $DIR $1 <<'ENDSSH'

sudo apt-get install cpufrequtils

# Turn off turbo boost.
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

# Disable CPU frequency scaling.
# sudo cpupower frequency-set -g performance
sudo cpufreq-set -g performance -c 0
sudo cpufreq-set -g performance -c 1
sudo cpufreq-set -g performance -c 2
sudo cpufreq-set -g performance -c 3
sudo cpufreq-set -g performance -c 4
sudo cpufreq-set -g performance -c 5
sudo cpufreq-set -g performance -c 6
sudo cpufreq-set -g performance -c 7
sudo cpufreq-set -g performance -c 8
sudo cpufreq-set -g performance -c 9
sudo cpufreq-set -g performance -c 10
sudo cpufreq-set -g performance -c 11
sudo cpufreq-set -g performance -c 12
sudo cpufreq-set -g performance -c 13
sudo cpufreq-set -g performance -c 14
sudo cpufreq-set -g performance -c 15
ENDSSH

echo "== TO LOGIN TO VM INSTANCE USE: =="
echo "ssh $1"
echo "============================="
