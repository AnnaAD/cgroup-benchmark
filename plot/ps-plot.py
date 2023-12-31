import matplotlib.pyplot as plt
import numpy as np
import sys

def parse_ps_log(file_path):
    data = {}
    with open(file_path, 'r') as file:
        lines = file.readlines()
        
        # Split the lines into groups
        groups = {}
        current_group = []
        time_stamp = ""
        for line in lines:
            if line.startswith('%CPU %MEM ARGS'):
                if current_group:
                    groups[time_stamp] = current_group
                time_stamp = line.split('ARGS')[1].strip()
                current_group = []
            current_group.append(line.strip())
        if current_group:
            groups[time_stamp]  = current_group


        for key,group in groups.items():
            # Skip groups with insufficient data
            if len(group) < 4:
                continue
            
            # Parse the process data
            process_data = group[1:]
            cpu_data = []
            mem_data = []
            process_names = []

            for line in process_data:
                fields = line.split()
                if len(fields) < 3:
                    continue
                cpu = float(fields[0])
                mem = float(fields[1])
                args = ' '.join(fields[2:])
                if cpu > 10.0 and "matrix" in args or "server" in args:
                    process_names.append(args)
                    cpu_data.append(cpu)
                    mem_data.append(mem)

            data[key] = (process_names, cpu_data, mem_data)
    return data

def create_combined_bar_plot(data):
    fig, ax = plt.subplots(figsize=(12, 8))
    
    # Calculate the number of groups and the width of each bar
    num_groups = len(data)
    bar_width = 1
    
    
    # Create a color map for bars
    color_map = plt.get_cmap('tab20')
    x_ticks = []
    x_tick_names = []

    offset = 0
    for key,(names, cpu_data, mem_data) in data.items():
        if(cpu_data and mem_data):
            print(names, cpu_data, mem_data)
            x = np.arange(len(names))
            
            # Plot CPU% bars
            ax.bar(x*bar_width + offset, cpu_data, bar_width, label = names, alpha=0.6, color=["red" if "server" in n else "blue"  for n in names])
            
            # Plot MEM% bars
            #ax.bar(x + offset + bar_width/2, mem_data, bar_width, label = names,alpha=0.6, color=[color_map(hash(n)%10) for n in names])
            offset += len(names)*bar_width + .5*bar_width
            # Set the x-axis ticks and labels
            x_ticks.append(offset)
            x_tick_names.append(key)

        ax.set_xticks(x_ticks)
        ax.set_xticklabels(x_tick_names, rotation=45)
        plt.setp(ax.get_xticklabels()[::2], visible=False)
    
    # Set the axis labels and title
    ax.set_xlabel('Processes')
    ax.set_ylabel('% Usage')
    ax.set_title('Combined Usage Summary')
    
    handles, labels = plt.gca().get_legend_handles_labels()
    by_label = dict(zip(labels, handles))
    ax.legend(by_label.values(), by_label.keys())
    # Show the plot
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    file_path = sys.argv[1]  # Replace with your file path
    data = parse_ps_log(file_path)
    create_combined_bar_plot(data)