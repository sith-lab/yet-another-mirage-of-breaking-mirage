import matplotlib.pyplot as plt
import pandas as pd

# ----------------------------
# Data
# ----------------------------
traces = list(range(100, 3301, 100))

mirage_repro_old = pd.read_csv("data_old/ge_mirage_repro.csv",header=None,delim_whitespace=True)[5].astype(float).tolist()
mirage_rco_old   = pd.read_csv("data_old/ge_mirage_rco.csv", header=None,delim_whitespace=True)[5].astype(float).tolist()
ceasers_rco_old  = pd.read_csv("data_old/ge_ceasers_rco.csv",header=None, delim_whitespace=True)[5].astype(float).tolist()
sass_rco_old     = pd.read_csv("data_old/ge_sass_rco.csv",   header=None, delim_whitespace=True)[5].astype(float).tolist()
scatter_rco_old  = pd.read_csv("data_old/ge_scatter_rco.csv",header=None, delim_whitespace=True)[5].astype(float).tolist()

mirage_repro = pd.read_csv("data/ge_mirage_repro.csv", header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
mirage_rco   = pd.read_csv("data/ge_mirage_rco.csv",   header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
ceasers_rco  = pd.read_csv("data/ge_ceasers_rco.csv",  header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
sass_rco     = pd.read_csv("data/ge_sass_rco.csv",     header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
scatter_rco  = pd.read_csv("data/ge_scatter_rco.csv",  header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()

# ----------------------------
# Plot styling
# ----------------------------
plt.rcParams.update(
    {
        "font.size": 26,
        "axes.labelsize": 26,
        "legend.fontsize": 20,
        "xtick.labelsize": 18,
        "ytick.labelsize": 18,
    }
)

# --- Subplot 1: Data with Buggy Analysis.py ---
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(15, 10), sharex=True)

ax1.plot(traces, mirage_repro_old, label="MIRAGE (Reproduced)", linewidth=3.2, color="blue", marker="o", markersize=9)
ax1.plot(traces, mirage_rco_old,   label="MIRAGE (RCO)",        linewidth=3.2, color="red", marker="o", markersize=9)
ax1.plot(traces, ceasers_rco_old,  label="CEASER-S (RCO)",      linewidth=1.8, linestyle="--", color="#FFB380", marker="o", markersize=7)
ax1.plot(traces, sass_rco_old,     label="Sass (RCO)",          linewidth=1.8, linestyle="--", color="lightgray", marker="o", markersize=7)
ax1.plot(traces, scatter_rco_old,  label="Scatter (RCO)",       linewidth=1.8, linestyle="--", color="lightgreen", marker="o", markersize=7)

ax1.set_ylabel("Guessing Entropy (GE)")
ax1.grid(True, linestyle="--", linewidth=0.6, alpha=0.7)
#ax1.legend()
ax1.set_title("(a) Original Analysis in RCO Paper")

# --- Subplot 2: Data with Updated Analysis.py ---
ax2.plot(traces, mirage_repro, label="MIRAGE (Reproduced)", linewidth=3.2, color="blue", marker="o", markersize=9)
ax2.plot(traces, mirage_rco,   label="MIRAGE (RCO)",        linewidth=3.2, color="red", marker="o", markersize=9)
ax2.plot(traces, ceasers_rco,  label="CEASER-S (RCO)",      linewidth=1.8, linestyle="--", color="#FFB380", marker="o", markersize=7)
ax2.plot(traces, sass_rco,     label="Sass (RCO)",          linewidth=1.8, linestyle="--", color="lightgray", marker="o", markersize=7)
ax2.plot(traces, scatter_rco,  label="Scatter (RCO)",       linewidth=1.8, linestyle="--", color="lightgreen", marker="o", markersize=7)

ax2.set_xlabel("Number of Traces")
ax2.set_ylabel("Guessing Entropy (GE)")
ax2.grid(True, linestyle="--", linewidth=0.6, alpha=0.7)
ax2.legend()
ax2.set_title("(b) Fixed Analysis Bug")

# --- save figure ---
plt.tight_layout()
plt.savefig("fig1_ge.pdf")
