import matplotlib.pyplot as plt

# ----------------------------
# Data
# ----------------------------
traces = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000]

mirage_repro = pd.read_csv("data/ge_mirage_repro.csv", header=None)[0].tolist()
mirage_rco   = pd.read_csv("data/ge_mirage_rco.csv", header=None)[0].tolist()
ceasers_rco  = pd.read_csv("data/ge_ceasers_rco.csv", header=None)[0].tolist()
sass_rco     = pd.read_csv("data/ge_sass_rco.csv", header=None)[0].tolist()
scatter_rco  = pd.read_csv("data/ge_scatter_rco.csv", header=None)[0].tolist()


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
# Graph 1
# ----------------------------

plt.plot(
    traces,
    mirage_repro,
    label="MIRAGE (Reproduced)",
    linewidth=3.2,
    color="red",
    marker="o",
    markersize=9,
)
plt.plot(
    traces,
    mirage_rco,
    label="MIRAGE (RCO)",
    linewidth=3.2,
    color="blue",
    marker="o",
    markersize=9,
)
plt.plot(
    traces,
    ceaser_s_rco,
    label="CEASER-S (RCO)",
    linewidth=1.8,
    linestyle="--",
    color="#FFB380",
    marker="o",
    markersize=7,
)
plt.plot(
    traces,
    sass_rco,
    label="Sass (RCO)",
    linewidth=1.8,
    linestyle="--",
    color="lightgray",
    marker="o",
    markersize=7,
)
plt.plot(
    traces,
    scatter_rco,
    label="Scatter (RCO)",
    linewidth=1.8,
    linestyle="--",
    color="lightgreen",
    marker="o",
    markersize=7,
)

plt.xlabel("Number of Traces")
plt.ylabel("Guessing Entropy (GE)")
plt.grid(True, linestyle="--", linewidth=0.6, alpha=0.7)
plt.legend()
plt.tight_layout()
plt.savefig("fig1_ge.pdf")
plt.show()
