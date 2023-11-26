import sys
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
import re
import numpy as np

def parse_mm(file_path):
    data = []
    
    pattern = r'(.+) \d+x\d+ matrices: (.+) seconds'

    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            if(i % 100000 == 0):
                print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                latency = float(match.group(2))
                timestamp = match.group(1)
                data.append({"latency": latency, "time": datetime.strptime(timestamp, "%b %d %Y %H:%M:%S.%f")})
            i += 1

    print(data)    
    return data

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
                data.append({"time": datetime.strptime(t.replace("MST", ""), "%a %b %d %I:%M:%S %p %Y")})
            i += 1
            
    return data

def parse_latency_data(file_path):
    data = []
    
    pattern = r'LOG: (.+) Round trip time: (.+) ns'

    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            if(i % 100000 == 0):
                print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                latency = int(match.group(2))
                timestamp = match.group(1)
                data.append({"latency": latency, "time": datetime.strptime(timestamp, "%b %d %Y %H:%M:%S.%f")})
            i += 1
            
    
    return data

def plot_latency_over_time(data, log_times, mm_through):

    
    fig, ax1 = plt.subplots()

    for x in log_times:
        plt.axvline(x=x["time"], color = "pink")
   

    ax1.set_ylim([0,1.2*10**7])
    ax2 = ax1.twinx()
    ax2.plot([m["time"] for m in mm_through], [m["latency"] for m in mm_through], color = "orange", alpha = 0.6)
    ax1.plot([d["time"] for d in data], [d["latency"] for d in data])

    plt.xlabel('Time')
    ax1.set_ylabel('Latency (ns)')
    plt.title('Latency Over Time')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

def report_stats(data, log_times):
    split_time = log_times[-1]["time"]
    bin_before = [x["latency"]  for x in data if x["time"] < split_time]
    bin_after = [x["latency"]  for x in data if x["time"] > split_time]

    a = np.array(bin_before)
    print("P50:", np.percentile(a, 50) )
    print("P99:", np.percentile(a, 99) )

    a = np.array(bin_after)
    print("P50:", np.percentile(a, 50) )
    print("P99:", np.percentile(a, 99) )

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Usage: python script.py <file_path> <server_log_file_path> <mm_path>')
        sys.exit(1)

    file_path = sys.argv[1]
    file_path2 = sys.argv[2]
    file_path3 = sys.argv[3]

    latencies = parse_latency_data(file_path)
    log_times = parse_log_timestamps(file_path2)
    mm_through = parse_mm(file_path3)
    plot_latency_over_time(latencies, log_times, mm_through)
    report_stats(latencies, log_times)