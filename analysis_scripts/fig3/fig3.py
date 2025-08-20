import re
import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np

# Directory for Input data files
dir_rand = "/code/reproduction/repro_results/fixedCT/L1512B.SeedRand"
dir_fixed = "/code/reproduction/repro_results/fixedCT/L1512B.SeedFixed"

# Input files
filenames_rand = []
filenames_fixed = []
for ct in ["CT1", "CT2", "CT3", "CT4"] :
    filenames_rand.append(f"/code/reproduction/repro_results/fixedCT/L1512B.SeedRand/{ct}/run_results.txt")
    filenames_fixed.append(f"/code/reproduction/repro_results/fixedCT/L1512B.SeedFixed/{ct}/run_results.txt")

# Regex to capture access time and ciphertext
pattern = re.compile(
        r"Attacker access time\(.*?\):\s*(\d+),\s*for ciphertext:\s*([0-9a-f ]+)",
        re.IGNORECASE
    )

##########
# Random
##########

data = defaultdict(list)

for filename_rand in filenames_rand :
    with open(filename_rand, "r") as f:
        for line in f:
            match = pattern.search(line)
            if match:
                time = int(match.group(1))
                ct = " ".join(match.group(2).split())  # normalize spaces
                data[ct].append(time)

#colors = plt.cm.tab20(np.linspace(0, 1, len(data.keys())))  # colormap with enough colors
color_list = ['red', 'green', 'blue', 'orange', 'purple', 'cyan', 'magenta', 'yellow']

# Plot histogram
plt.figure(figsize=(10, 6))
plt.ticklabel_format(style='plain', useOffset=False)

#bins = 20  # adjust as needed

for i, (ct, times) in enumerate(data.items()):
    #print(times)
    #plt.hist(times, alpha=0.6, label=f"Ciphertext {i+1}")
    plt.hist(times, alpha=0.6, label=ct, color=color_list[i%len(color_list)])
                
plt.xlabel("Access Time")
plt.ylabel("Frequency")
plt.title("Histogram of Access Times per Unique Ciphertext")
plt.legend()
plt.tight_layout()
plt.savefig("access_times_histogram.pdf")
#plt.show()

##########
## Fixed.
#########@

data_fixed = defaultdict(list)

for filename_fixed in filenames_fixed :
    with open(filename_fixed, "r") as f:
        for line in f:
            match = pattern.search(line)
            if match:
                time = int(match.group(1))
                ct = " ".join(match.group(2).split())  # normalize spaces
                data_fixed[ct].append(time)

cts = []
ct_time_fixed = []
freqs = []

for ct, times_list in data_fixed.items():
    cts.append(ct)
    ct_time_fixed.append(times_list[0])
    freqs.append(len(times_list))

# Group bars by their x position (access time)
groups = defaultdict(list)
for i, x in enumerate(ct_time_fixed):
    groups[x].append(i)

# Prepare figure
plt.figure(figsize=(12, 6))
plt.ticklabel_format(style='plain', useOffset=False)

bars = []

# Width and offset params
bar_width = 30
max_offset = bar_width * 0.8  # max total offset span

for x_val, indices in groups.items():
    n = len(indices)
    if n == 1:
        idx = indices[0]
        color = color_list[idx % len(color_list)]  # pick color based on index
        b = plt.bar(x_val, freqs[idx], width=bar_width, alpha=0.6, color=color, label=cts[idx])
        bars.append(b)
    else:
        offsets = np.linspace(-max_offset/2, max_offset/2, n)
        for i_offset, idx in enumerate(indices):
            color = color_list[idx % len(color_list)]
            b = plt.bar(x_val + offsets[i_offset], freqs[idx], width=bar_width * 0.9, alpha=0.6, color=color, label=cts[idx])
            bars.append(b)
            
plt.xticks(rotation=45, ha='right')
plt.xlabel("Access Time")
plt.ylabel("Frequency")

# Create legend without duplicates
handles, labels = plt.gca().get_legend_handles_labels()
by_label = dict(zip(labels, handles))
plt.legend(by_label.values(), by_label.keys(), title="Access Time", bbox_to_anchor=(1.05, 1), loc='upper left')

plt.tight_layout()
plt.savefig("access_times_histogram_f.pdf")
