<a id="readme-top"></a>

# Green AI Planning — Experimental Artifact

This repository contains the complete experimental artifact accompanying the study “The Energy Impact of Domain Model
Design Choices in Classical Planning: An Empirical Analysis”. It provides all components required to reproduce the
measurement procedure, evaluate energy usage, and generate the plots and statistics used in the analysis. The artifact
is designed for scientific use and is aligned with the submission
to [CAIN 2026](https://conf.researchr.org/home/cain-2026). The repository includes the measurement
tool for automated baseline and planner energy measurements, the planner container definitions, the benchmark domain
models with systematically generated variants, the collected measurement data, and the analysis scripts used to
transform raw logs into visual and statistical results.

## Directory Overview

The repository is structured into several components. The `measurement-tool/` directory contains the complete
measurement framework, including the baseline module, the planner measurement module, supporting wrapper scripts, and
documentation. Within this framework, the `measurement-tool/domain/` directory provides the original benchmark domains
as well as all systematically generated variants. In parallel, the `measurement-tool/planner/` directory contains the
Apptainer-based planner container definitions.

All recorded results are stored under `measurement-data/`. For each planner–domain combination, a dedicated subdirectory
is created that contains the raw measurement logs, the generated plans, and the corresponding execution logs.
The `analysis-scripts/` directory includes Python scripts for aggregating and visualizing the collected data, while the
resulting plots are placed in `analysis-figures/`. Finally, the `instance-generators/` directory contains helper scripts
that were used to provide randomly sampled parameter values to the official instance generators of selected domains.

## Notes

In the accompanying paper, the variant prefix categories are denoted as **SSC-**, **MRC-** and **TDC-**. Within this
repository, however, the corresponding legacy prefixes **SV-**, **MI-**, and **SC-** remain in use.

To avoid confusion, the mapping between paper notation and repository notation is as follows:

- `SV-` → `SSC-` (Syntactic Structure Choices)
- `MI-` → `MRC-` (Modeling Redundancy Choices)
- `SC-` → `TDC-` (Task Design Choices)
- `MI-RPR2` → `MI-RPR`
- `MI-REF2` → `MI-REF`

Please note that this is purely a naming difference. The semantics, configuration logic, and experimental meaning of the
variants remain fully aligned with the definitions provided in the paper.

## Reproducing the Experiment

If you want to reproduce the experiment exactly as described in the paper, please note that the full execution is
orchestrated via the script `run_measurement.sh`, which is located in `measurement-tool/`.
This script automates the complete measurement campaign, running the selected planner across all domain variants with
the correct number of repetitions and timeouts. It uses the same configuration that was applied to generate the dataset
stored in `measurement-data/`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
