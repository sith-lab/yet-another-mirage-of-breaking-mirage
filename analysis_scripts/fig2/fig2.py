import os
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from collections import defaultdict
from matplotlib.colors import TwoSlopeNorm
from pathlib import Path
from mpl_toolkits.axes_grid1 import make_axes_locatable

mpl.rcParams["axes.formatter.useoffset"] = False

profiling_key = [0x20, 0x5E, 0x87, 0x2E, 0x1E, 0xFC, 0x8F, 0x27, 0x10, 0xC4, 0x82, 0x43, 0xAF, 0x1C, 0xDB, 0xA1]

victim_key = [0xDE, 0x94, 0x73, 0x5A, 0x1A, 0x2E, 0x6B, 0x06, 0xE7, 0xAA, 0xEC, 0xED, 0x8B, 0x81, 0x5A, 0xE6]


def pretty(title):
    return Path(title).stem.replace("_", " ")


def process_trace_file(filepath, key):
    access_times_by_index = defaultdict(list)
    with open(filepath) as f:
        for line in f:
            if "Attacker access" not in line:
                continue
            parts = line.strip().split()
            try:
                time = int(parts[3].rstrip(","))
                ciphertext = [int(byte, 16) for byte in parts[6:22]]
                for i in range(16):
                    index = ciphertext[i] ^ key[i]
                    access_times_by_index[index].append(time)
            except:
                continue
    avg_times = np.full(256, np.nan, dtype=float)
    for i in range(256):
        if access_times_by_index[i]:
            avg_times[i] = np.mean(access_times_by_index[i])
    return avg_times.reshape(16, 16)


base_dir = "data"
subfolders = ["profiled", "victim"]
file_paths = []
for sub in subfolders:
    sub_dir = os.path.join(base_dir, sub)
    for file in sorted(os.listdir(sub_dir)):
        if file.endswith(".txt"):
            file_paths.append((os.path.join(sub_dir, file), file, sub))
print(file_paths)

mats, titles, groups, meds = [], [], [], []
for path, title, subfolder in file_paths:
    key = profiling_key if subfolder == "profiled" else victim_key
    mat = process_trace_file(path, key)
    mats.append(mat)
    titles.append(title)
    meds.append(np.nanmedian(mat))

    t_low = title.lower()
    if "random" in t_low:
        groups.append("random")
    elif "fixed" in t_low:
        groups.append("fixed")
    else:
        groups.append("other")  # exported only if you call plot_group("other", ...)


def plot_group(target_group: str, out_pdf: str, out_png: str = None):
    sel = [
        (m, t, g, med)
        for m, t, g, med in zip(mats, titles, groups, meds)
        if g == target_group
    ]
    if not sel:
        print(f"No items for group '{target_group}'. Skipping.")
        return

    num = len(sel)
    cols = 2
    rows = (num + cols - 1) // cols

    fig, axes = plt.subplots(rows, cols, figsize=(14, 6 * rows))
    plt.subplots_adjust(
        left=0.2, right=0.85, top=0.95, bottom=0.05, wspace=0.6, hspace=0.6
    )
    axes = np.atleast_2d(axes)

    cmap = plt.colormaps["coolwarm"].copy()
    cmap.set_bad(color="black")
    nticks = 7

    for i, (data, title, _g, med) in enumerate(sel):
        ax = axes[i // cols, i % cols]
        data_centered = data - med
        vals = data_centered[np.isfinite(data_centered)]

        if vals.size == 0:
            vmin, vmax = -1.0, 1.0
        else:
            vmin = float(np.nanmin(vals))
            vmax = float(np.nanmax(vals))
            # ensure 0 lies within range and avoid zero-span
            if vmax <= 0:
                vmax = 0.0
            if vmin >= 0:
                vmin = 0.0
            if not np.isfinite(vmin) or not np.isfinite(vmax) or vmin == vmax:
                eps = 1.0
                vmin, vmax = -eps, eps

        norm = TwoSlopeNorm(vmin=vmin, vcenter=0.0, vmax=vmax)

        mask = np.ma.masked_invalid(data_centered)
        im = ax.imshow(mask, cmap=cmap, norm=norm)
        ax.set_title(f"{pretty(title)}", fontsize=20)
        ax.set_xlabel("Byte Index (0-15)", fontsize=20)
        ax.set_ylabel("Byte Row Index (0-15)", fontsize=20)
        ax.set_xticks(np.arange(0, 16, 1))
        ax.set_yticks(np.arange(0, 16, 1))
        ax.tick_params(axis="both", which="major", labelsize=10)

        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size="3%", pad=0.18)
        cb = fig.colorbar(im, cax=cax)
        cb.set_label(
            f"Δ access time (cycles)\n(center = median {med:.0f})", fontsize=18
        )
        cb.set_ticks(np.linspace(vmin, vmax, nticks))
        cb.ax.tick_params(labelsize=12)

    # Hide empty axes
    for j in range(num, rows * cols):
        axes[j // cols, j % cols].axis("off")
    fig.tight_layout()
    fig.savefig(out_pdf)
    if out_png:
        fig.savefig(out_png, dpi=200)
    plt.close(fig)


plot_group("random", "heatmaps_random.pdf", "heatmaps_random.png")
plot_group("fixed", "heatmaps_fixed.pdf", "heatmaps_fixed.png")
