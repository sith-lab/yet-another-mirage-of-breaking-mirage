import matplotlib.pyplot as plt

# ----------------------------
# Data
# ----------------------------
traces = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000]

mirage_rco   = pd.read_csv("data/ge_mirage_rco.csv", header=None)[0].tolist()
mirage_repro_fixedseed_512B  = pd.read_csv("data/ge_mirage_repro_fixedseed_512B.csv", header=None)[0].tolist()
mirage_repro_randseed_512B   = pd.read_csv("data/ge_mirage_repro_randseed_512B.csv", header=None)[0].tolist()
mirage_repro_randseed_64kB   = pd.read_csv("data/ge_mirage_repro_randseed_64kB.csv", header=None)[0].tolist()

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

plt.plot(
    traces,
    mirage_rco,
    label="MIRAGE (RCO paper)",
    linewidth=3.2,
    color="blue",
    marker="o",
    markersize=7,
)
plt.plot(
    traces,
    mirage_repro_fixedseed_512B,
    label="MIRAGE (reproduced - Fixed Seed, 512B L1 Cache)",
    linewidth=3.2,
    color="red",
    marker="o",
    markersize=7,
)
plt.plot(
    traces,
    mirage_repro_randseed_512B,
    label="MIRAGE (bug fix - Random Seed, 512B L1 Cache)",
    linewidth=3.2,
    color="orange",
    marker="o",
    markersize=7,
)
plt.plot(
    traces,
    mirage_repro_randseed_64kB,
    label="MIRAGE (bug fix - Random Seed, 64KB L1 Cache)",
    linewidth=3.2,
    color="green",
    marker="o",
    markersize=7,
)

plt.xlabel("Number of Traces")
plt.ylabel("Guessing Entropy (GE)")
plt.grid(True, linestyle="--", linewidth=0.6, alpha=0.7)
plt.legend()
plt.tight_layout()
plt.savefig("fig4_ge.pdf")
plt.show()
