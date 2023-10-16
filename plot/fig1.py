import sys
import matplotlib.pyplot as plt
from datetime import datetime
import re

def parse_log_timestamps(file_path):

    data = []
    
    pattern = r'(\w\w\w \w\w\w .+)'
    
    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            if(i % 100000 == 0):
                print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                t = match.group(1)
                data.append({"time": t})
            i += 1
            
    
    return data

def parse_latency_data(file_path):
    data = []
    
    pattern = r' - Latency : (\d+) ns (.+)'
    
    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            if(i % 100000 == 0):
                print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                latency = int(match.group(1))
                timestamp = match.group(2)
                data.append({"latency": latency, "time": timestamp})
            i += 1
            
    
    return data

def plot_latency_over_time(data, log_times):
    x_lat = list(range(len(data)))

    timestamp_points = []
    for l in log_times:

        # look for x value to plot what time key log times occured
        for i,d in enumerate(data):
            if(d["time"][:-5] == l["time"][:len(d["time"])-5]):
                timestamp_points.append(i)
                break

    print(timestamp_points)
    
    

    for x in timestamp_points:
        plt.axvline(x=x, color = "pink")
   
    plt.plot(x_lat, [d["latency"] for d in data])


    plt.xlabel('Time')
    plt.ylabel('Latency (ns)')
    plt.title('Latency Over Time')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: python script.py <file_path> <server_log_file_path>')
        sys.exit(1)

    file_path = sys.argv[1]
    file_path2 = sys.argv[2]

    latencies = parse_latency_data(file_path)
    log_times = parse_log_timestamps(file_path2)
    plot_latency_over_time(latencies, log_times)