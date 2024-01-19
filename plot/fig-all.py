import sys
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from datetime import datetime, timedelta
import re
import numpy as np


def parse_mm(file_path):
    data = []
    
    pattern = r'(.+) \d+x\d+ matrices: (.+) seconds'

    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            # if(i % 100000 == 0):
            #     print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                latency = float(match.group(2))
                timestamp = match.group(1)
                data.append({"latency": latency, "time": datetime.strptime(timestamp, "%b %d %Y %H:%M:%S.%f")})
            i += 1
            
    return data

def parse_log_timestamps(file_path):

    data = []
    
    pattern = r'(\w\w\w \w\w\w .+)'
    
    with open(file_path, 'r') as file:
        i = 0
        for line in file:
            # if(i % 100000 == 0):
            #     print(i, "\% done")

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
            # if(i % 100000 == 0):
            #     print(i, "\% done")

            match = re.match(pattern, line)
            if match:
                latency = int(match.group(2))
                timestamp = match.group(1)
                data.append({"latency": latency, "time": datetime.strptime(timestamp, "%b %d %Y %H:%M:%S.%f")})
            i += 1
            
    
    return data

def plot_latency_over_time(data, log_times, mm_through, mult = False):

    
    fig, ax1 = plt.subplots()

    for x in log_times:
        plt.axvline(x=x["time"], color = "pink")
   

    #ax1.set_ylim([0,1.75*10**7])
    ax2 = ax1.twinx()
    ax2.plot([m["time"] for m in mm_through], [m["latency"] for m in mm_through], color = "orange", alpha = 0.6)
    #ax1.set_ylim([-1,1])

    if(not mult):
        ax1.plot([d["time"] for d in data], [d["latency"] for d in data])
    else:
        for d in data:
            ax1.plot([da["time"] for da in d], [da["latency"] for da in d], color = "blue")


    plt.xlabel('Time')
    ax1.set_ylabel('Latency (ns)')
    plt.title('Latency Over Time')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

def report_stats(data, log_times,fn,i):
    full = []
    for d in data:
        full.extend(d)
    data = full

    split_time = log_times[-1]["time"]
    start_time = log_times[0]["time"]+timedelta(0,2) # warmup time
    bin_before = [x["latency"]  for x in data if x["time"] < split_time and x["time"] > start_time]
    bin_after = [x["latency"]  for x in data if x["time"] > split_time]

    a = np.array(bin_before)
    print("P50:", np.percentile(a, 50) )
    print("P99:", np.percentile(a, 99) )
    print("P99.99:", np.percentile(a, 99.99) )

    plt.hist([bin_before],1000, density=True, cumulative=True,
         histtype='step', label = ["no BE - "+fn], color = ["C"+str(i)], linestyle = "dashed")

    plt.hist([bin_after],1000, density=True, cumulative=True,
         histtype='step', label = ["with BE - " + fn], color = ["C"+str(i)], linestyle = "solid")
    fix_hist_step_vertical_line_at_end(plt.gca())
    a = np.array(bin_after)
    print("P50:", np.percentile(a, 50) )
    print("P99:", np.percentile(a, 99) )
    print("P99.99:", np.percentile(a, 99.99) )

def fix_hist_step_vertical_line_at_end(ax):
    axpolygons = [poly for poly in ax.get_children() if isinstance(poly, patches.Polygon)]
    for poly in axpolygons:
        poly.set_xy(poly.get_xy()[:-1])


if __name__ == '__main__':
    if not len(sys.argv) >= 2:
        print('Usage: python script.py <folder_names>')
        sys.exit(1)


    folder_names = sys.argv[1:]
   
    import glob
    latencies = []
    i = 1
    for fn in folder_names:
        print(fn)
        for fp in glob.glob(f"../data/{fn}/client-*.out"):
            latencies.append(parse_latency_data(fp))
        try:
            log_times = parse_log_timestamps(f"../data/{fn}/server.out")
        except:
            pass
        
        try:
            log_times = parse_log_timestamps(f"../data/{fn}/server.log")
        except:
            pass
        report_stats(latencies, log_times,fn,i)
        i+=1
    plt.legend()


    plt.show()