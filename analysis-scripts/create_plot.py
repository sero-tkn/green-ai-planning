import os
import glob
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

matplotlib.use("TkAgg")

planner_name = "cerberus_agl"
domain_name = "ricochet-robots"
modeling_aspect = "SC"
add_legend = False
mean_color = "tab:blue"
median_color = "tab:orange"
std_color = "tab:green"
duration_color = "tab:red"

csv_files = glob.glob("*.csv")
baseline_power = None  # Watt (J/s)

for file in csv_files:
    df = pd.read_csv(file)
    if "measure_baseline" in df["label"].values:
        baseline_row = df[df["label"] == "measure_baseline"].iloc[0]
        baseline_energy_j = baseline_row["pkg"] / 1e6  # µJ -> J
        baseline_time_s = baseline_row["duration"] / 1e6  # µs -> s
        baseline_power = baseline_energy_j / baseline_time_s
        print(f"Baseline {file}: {baseline_power:.4f} W")

if baseline_power is None:
    raise RuntimeError("No baseline file found")

data = {}
for file in csv_files:
    df = pd.read_csv(file)
    if "measure_planner" in df["label"].values:
        filename = os.path.splitext(os.path.basename(file))[0]
        if f"{domain_name}-" in filename and "_" in filename:
            variant_name = filename.split(f"{domain_name}-", 1)[1].split("_", 1)[0]
        else:
            variant_name = filename  # fallback

        energies, durations = [], []
        for _, row in df.iterrows():
            if row["label"] != "measure_planner":
                continue
            energy_j = row["pkg"] / 1e6  # µJ -> J
            dur_s = row["duration"] / 1e6  # µs -> s
            baseline_scaled = baseline_power * dur_s
            corrected = energy_j - baseline_scaled
            energies.append(corrected)
            durations.append(dur_s)

        if energies:
            data[variant_name] = {"energy": energies, "duration": durations}
            print(f"{filename}: {len(energies)} values for {variant_name}")

if not data:
    raise RuntimeError("No planner measurements found")

variants = sorted(data.keys())
x = np.arange(1, len(variants) + 1)
means_energy = np.array([np.mean(data[v]["energy"]) for v in variants], dtype=float)
medians_energy = np.array([np.median(data[v]["energy"]) for v in variants], dtype=float)
stds_energy = np.array([np.std(data[v]["energy"], ddof=1) if len(data[v]["energy"]) > 1 else 0.0
                        for v in variants], dtype=float)
means_duration = np.array([np.mean(data[v]["duration"]) for v in variants], dtype=float)

org_key = next((v for v in variants if v.upper() == "ORG"), variants[0])
org_energy = data[org_key]["energy"]

pearsons = {}
for v in variants:
    if v == org_key:
        pearsons[v] = np.nan
    else:
        y = data[v]["energy"]
        if len(org_energy) == len(y) and len(y) >= 2:
            pearsons[v] = float(np.corrcoef(org_energy, y)[0, 1])
        else:
            pearsons[v] = np.nan

fig, ax = plt.subplots(figsize=(18, 8))
bp = ax.boxplot([data[v]["energy"] for v in variants],
                showfliers=True,
                medianprops=dict(color=median_color, linewidth=2),
                flierprops=dict(marker="o", markersize=8, alpha=0.7))


ax.scatter(x, means_energy, marker="D", s=40, color=mean_color, zorder=3, label="Mean (energy)")
ax.errorbar(x, means_energy, yerr=stds_energy, fmt="none", elinewidth=1.5, capsize=6,
            ecolor=std_color, zorder=2, label="Std (energy)")

ax2 = ax.twinx()
ax2.scatter(x, means_duration, marker="o", s=36, color=duration_color, zorder=3, label="Mean duration")
ax2.set_ylabel("Seconds", fontsize=10)

ax.set_xticks(x)
ax.set_xticklabels(variants, rotation=45, fontsize=10, ha="right")
ax.set_ylabel("Joule", fontsize=10)
ax.grid(axis="y", linestyle="--", alpha=0.7)

if add_legend:
    handles_energy = [
        Line2D([0], [0], marker="D", color="none", markerfacecolor=mean_color, markersize=8, label="Energy mean"),
        Line2D([0], [0], color=median_color, lw=2, label="Energy median"),
        Line2D([0], [0], color=std_color, lw=2, label="Energy standard deviation"),
    ]
    handles_duration = [
        Line2D([0], [0], marker="o", color="none", markerfacecolor=duration_color, markersize=8, label="Duration mean"),
    ]
    handles = handles_energy + handles_duration
    ax.legend(handles=handles, loc="lower center", bbox_to_anchor=(0.5, 1.02),
              ncol=len(handles), frameon=True, fontsize=10)


def format_number(val: float) -> str:
    return f"{val:.1f}" if abs(val) >= 1000 else f"{val:.2f}"


for xi, v, m, s in zip(x, variants, means_energy, stds_energy):
    if v == org_key:
        text = f"μ={format_number(m)}\nσ={format_number(s)}"
    else:
        text = f"μ={format_number(m)}\nσ={format_number(s)}\nr={format_number(pearsons[v])}"
    ax.text(xi, -0.19, text,
            transform=ax.get_xaxis_transform(),
            ha="center", va="top", fontsize=9)

plt.subplots_adjust(bottom=0.28, top=0.88)
plt.savefig(f"boxplots-{planner_name}-{modeling_aspect}-{domain_name}.pdf", bbox_inches="tight")
