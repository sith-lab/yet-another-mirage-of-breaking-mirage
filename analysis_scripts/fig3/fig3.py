import re
import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np
from matplotlib.ticker import ScalarFormatter

# Directory for Input data files
dir_rand = "/code/reproduction/repro_results/fixedCT/L1512B.SeedRand"
dir_fixed = "/code/reproduction/repro_results/fixedCT/L1512B.SeedFixed"

# Input files
filenames_rand = []
filenames_fixed = []
for ct in ["ct1", "ct2", "ct3", "ct4"] :
    filenames_rand.append(f"/code/reproduction/repro_results/fixedCT/L1512B.SeedRand/{ct}/run_results.txt")
    filenames_fixed.append(f"/code/reproduction/repro_results/fixedCT/L1512B.SeedFixed/{ct}/run_results.txt")

    
# Input file
filename_rand = "L1512B.SeedRand/run_results.txt"
filename_fixed = "L1512B.SeedF/run_results.txt"

# Regex to capture access time and ciphertext
pattern = re.compile(
        r"Attacker access time\(.*?\):\s*(\d+),\s*for ciphertext:\s*([0-9a-f ]+)",
        re.IGNORECASE
    )


# Random
data = defaultdict(list)

data = defaultdict(list)

for filename_rand in filenames_rand :
    with open(filename_rand, "r") as f:
        for line in f:
            match = pattern.search(line)
            if match:
                time = int(match.group(1))
                ct = " ".join(match.group(2).split())  # normalize spaces
                data[ct].append(time)

# Color list
color_list = ["tab:blue", "tab:orange", "tab:green", "tab:red",
              "tab:purple", "tab:brown", "tab:pink", "tab:gray", "tab:olive", "tab:cyan"]

# --- Prepare data for fixed set ---
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

# Group bars with the same X value
groups = {}
for idx, x_val in enumerate(ct_time_fixed):
    groups.setdefault(x_val, []).append(idx)

# --- Create figure ---
fig, (ax2, ax1) = plt.subplots(1, 2, figsize=(10, 3))

"""
# ---- First plot: histogram for random ----
for i, (ct, times) in enumerate(data.items()):
    ax1.hist(times, alpha=0.6, label=f"Ciphertext {i+1}", color=color_list[i % len(color_list)])
ax1.set_xlabel("Access Time")
ax1.set_ylabel("Frequency")
ax1.set_title("Histogram of Access Times per Unique Ciphertext (Random)")
ax1.legend()
ax1.xaxis.set_major_formatter(ScalarFormatter())
ax1.ticklabel_format(style='plain', axis='x')  # disable scientific notation
"""

# ---- Second plot: bar chart for fixed ----
bar_width = 30
max_offset = bar_width * 0.8
for x_val, indices in groups.items():
    n = len(indices)
    if n == 1:
        idx = indices[0]
        color = color_list[idx % len(color_list)]
        ax2.bar(x_val, freqs[idx], width=bar_width, alpha=0.6,
                color=color, label=f"Ciphertext {idx+1}")
    else:
        offsets = np.linspace(-max_offset/2, max_offset/2, n)
        for i_offset, idx in enumerate(indices):
            color = color_list[idx % len(color_list)]
            ax2.bar(x_val + offsets[i_offset], freqs[idx], width=bar_width * 0.9, alpha=0.6,
                    color=color, label=f"Ciphertext {idx+1}")

#ax2.set_xticks(ct_time_fixed)
#ax2.set_xticklabels(ct_time_fixed, rotation=45, ha='right')
ax2.set_xlabel("Access Time (cycles)")
ax2.set_ylabel("Frequency")
ax2.set_title("(a) Fixed Seed for Global Evictions")
#ax2.tick_params(axis='x', rotation=45)

#ax2.ticklabel_format(style='plain', axis='x')  # disable scientific notation

# Remove duplicate legend entries in ax2
handles, labels = ax2.get_legend_handles_labels()
by_label = dict(zip(labels, handles))
#ax2.legend(by_label.values(), by_label.keys(), bbox_to_anchor=(1.05, 1), loc='upper left')
ax2.legend(by_label.values(), by_label.keys(), bbox_to_anchor=(0.85, 1), loc='upper right')
ax2.xaxis.set_major_formatter(ScalarFormatter())
ax2.ticklabel_format(style='plain', useOffset=False)
ax2.set_xlim(637693800, 637696800)
ax2.set_xticks(np.arange(637694000, 637697000, 1000))

           
# ---- First plot: histogram for random ----
for i, (ct, times) in enumerate(data.items()):
    ax1.hist(times, alpha=0.6, label=f"Ciphertext {i+1}", color=color_list[i % len(color_list)])
ax1.set_xlabel("Access Time (cycles)")
ax1.set_ylabel("Frequency")
ax1.set_title("(b) Random Seed for Global Evictions")
ax1.legend()
ax1.xaxis.set_major_formatter(ScalarFormatter())
ax1.ticklabel_format(style='plain', axis='x')  # disable scientific notation
ax1.set_xticks(np.arange(637600000, 637900000, 100000))

plt.tight_layout()
plt.savefig("access_times_histogram_combined.pdf")
