import matplotlib.pyplot as plt
import pandas as pd

# ----------------------------
# Data
# ----------------------------
traces = list(range(100, 3301, 100))

## MIRAGE Reproduced.
mirage_rco                   = pd.read_csv("data/ge_mirage_rco.csv",                  header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
mirage_repro_fixedseed_512B  = pd.read_csv("data/ge_mirage_repro_fixedseed_512B.csv", header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
mirage_repro_randseed_512B   = pd.read_csv("data/ge_mirage_repro_randseed_512B.csv",  header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()
mirage_repro_randseed_64kB   = pd.read_csv("data/ge_mirage_repro_randseed_64kB.csv",  header=None, delim_whitespace=True, skiprows=1)[5].astype(float).tolist()

## RCO Data.
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

plt.figure(figsize=(15, 10))


# ----------------------------
# Graph Fig-4
# ----------------------------

#plt.plot(traces, mirage_rco, label="MIRAGE (RCO paper)", linewidth=3.2, color="blue", marker="o", markersize=7)
plt.plot(traces, mirage_repro_fixedseed_512B, label="MIRAGE (reproduced) - Fixed Seed, 512B L1 Cache", linewidth=3.2, color="red", marker="o", markersize=7)
plt.plot(traces, mirage_repro_randseed_512B, label="MIRAGE (bug fix) - Random Seed, 512B L1 Cache", linewidth=3.2, color="blue", marker="o", markersize=7)
plt.plot(traces, mirage_repro_randseed_64kB, label="MIRAGE (bug fix) - Random Seed, 64KB L1 Cache", linewidth=3.2, color="black", marker="o", markersize=7)
plt.plot(traces, ceasers_rco,  label="CEASER-S (RCO)",      linewidth=1.8, linestyle="--", color="#FFB380", marker="o", markersize=7, zorder=-1)
plt.plot(traces, sass_rco,     label="Sass (RCO)",          linewidth=1.8, linestyle="--", color="lightgray", marker="o", markersize=7,zorder=-1)
plt.plot(traces, scatter_rco,  label="Scatter (RCO)",       linewidth=1.8, linestyle="--", color="lightgreen", marker="o", markersize=7,zorder=-1)


plt.xlabel("Number of Traces")
plt.ylabel("Guessing Entropy (GE)")
plt.gca().set_ylim(bottom=20)   # only lower limit updated


plt.grid(True, linestyle="--", linewidth=0.6, alpha=0.7)
plt.legend()
plt.tight_layout()
plt.savefig("fig4_ge.pdf")
plt.show()
