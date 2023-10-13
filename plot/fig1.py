import sys
import matplotlib.pyplot as plt
from datetime import datetime
import re

def parse_latency_data(file_path):
    latencies = []
    timestamps = []
    
    pattern = r' - Latency : (\d+) ns (.+)'
    
    with open(file_path, 'r') as file:
        for line in file:
            print(line)
            match = re.match(pattern, line)
            if match:
                latency = int(match.group(1))
                latencies.append(latency)
    
    return latencies

def plot_latency_over_time(latencies):
    x = list(range(len(latencies)))
    
    plt.plot(x, latencies, marker='o')
    plt.xlabel('Time')
    plt.ylabel('Latency (ns)')
    plt.title('Latency Over Time')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: python script.py <file_path>')
        sys.exit(1)

    file_path = sys.argv[1]

    latencies = parse_latency_data(file_path)
    plot_latency_over_time(latencies)