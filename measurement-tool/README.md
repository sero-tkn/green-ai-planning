<a id="readme-top"></a>

# Energy Measurement Framework for Classical Planners

This framework provides a lightweight, automated solution for measuring and comparing the energy consumption of
classical planning systems. By leveraging Intel's RAPL (Running Average Power Limit) interface via the Python
library [pyRAPL](https://pypi.org/project/pyRAPL/), the tool captures power usage during both idle (baseline) and
active (planner) phases.
The main goal is to help researchers and developers evaluate the energy efficiency of different planners and domain
configurations. This can be particularly useful for energy-aware computing, sustainability analyses, and benchmarking
studies in classical planning research.

## Features

- **Baseline Measurement**: Measures idle energy consumption of the system.
- **Planner Measurement**: Measures energy used while executing a planner on multiple planning problems.
- **Combined Execution**: Runs both baseline and planner measurements sequentially.
- **System Idle Checker**: Automatically waits until the system is idle both before and after each measurement.
- **Automated CSV Output**: All measurement results are stored under `./result/` in CSV format.
- **Plan Output**: All generated plans are stored under `./plan/`.
- **Logging**: Persistent log file `energy_tool.log` with execution information and colored log output in the terminal.

## Requirements

### System Requirements

- Linux-based system with Intel CPU (RAPL interface required)
- [Python 3.8+](https://www.python.org/downloads/) must be installed and available in the system path
- [Apptainer](https://apptainer.org/) must be installed and available in the system path

### Install Apptainer on Linux

#### For Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y build-essential uuid-dev libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup runc
```

Install Go (required for Apptainer):

```bash
sudo apt install -y golang-go
```

Download and install Apptainer:

```bash
export VERSION=1.2.5  # Check for the latest version at https://github.com/apptainer/apptainer/releases
wget https://github.com/apptainer/apptainer/releases/download/v${VERSION}/apptainer-${VERSION}.tar.gz
tar -xzf apptainer-${VERSION}.tar.gz
cd apptainer-${VERSION}
./mconfig
make -C builddir
sudo make -C builddir install
```

Verify installation:

```bash
apptainer --version
```

### Python Dependencies

Install dependencies with:

```bash
pip install pyRAPL psutil colorlog
```

## Project Structure

The project expects the following directory layout:

```
project-root/
├── domain/
│   └── <domain-name>/
│       ├── domain.pddl
│       ├── problem01.pddl
│       ├── problem02.pddl
│       └── ...
├── plan/
├── planner/
│   └── <planner-name>/
│       ├── Apptainer.<planner-name>    
│       └── ...
├── result/
├── src/
│   ├── util/
│   │   └── ...
│   ├── measure_baseline_energy.py
│   ├── measure_planner_energy.py
│   └── ...
├── main.py
└── README.md
```

If the `./plan/` or `./result/` directories do not exist, they will be automatically created when running a measurement.

## Planner Execution Details

Planners are executed via Apptainer containers.

- Each planner must include an Apptainer definition file named `Apptainer.<planner-name>`.
- The `<planner-name>` must match the name of the planner’s directory inside the `planner/` folder.  
  For example, if the directory is `planner/ApxNoveltyTarski`, then the definition file must
  be `Apptainer.ApxNoveltyTarski`, and the resulting container will be `ApxNoveltyTarski.sif`.
- The container image `<planner-name>.sif` is built automatically before execution using:

```bash
apptainer build <planner-name>.sif Apptainer.<planner>
```

- Execution per problem is done via:

```bash
./<planner-name>.sif domain.pddl problem.pddl plan.txt
```

## Usage

Run the tool using `main.py`. Three subcommands are available:

### 1. Combined Measurement (Baseline + Planner)

```bash
python main.py run --planner <planner-name> --domain <domain-name>
```

**Optional:**

```bash
--duration-baseline TIME     # Sleep duration in seconds per run for baseline (e.g., '300s' or '300', default: 1s)
--runs-baseline NUMBER       # Number of baseline measurement-data runs (default: 1)
--time-limit-planner TIME    # Subprocess timeout in seconds per planner run (e.g. '1800' or '1800s', default: no limit)
--runs-planner NUMBER        # Number of planner runs per problem (default: 1)
```

### 2. Baseline Only

```bash
python main.py run-baseline
```

**Optional:**

```bash
--duration TIME              # Sleep duration in seconds per run (e.g., '300s' or '300', default: 1s)
--runs NUMBER                # Number of runs (default: 1)
```

### 3. Planner Only

```bash
python main.py run-planner --planner <planner-name> --domain <domain-name>
```

**Optional:**

```bash
--time-limit TIME            # Subprocess timeout in seconds per planner run (e.g. '1800' or '1800s', default: no limit)
--runs NUMBER                # Number of planner runs per problem (default: 1)
```

### 4. Configure System Idle Checker

```bash
python main.py config-idle
```

**Optional:**

```bash
--threshold FLOAT            # CPU idle threshold in % (default: 2.0)
--interval INT               # Check interval in seconds (e.g., '10s' or '10', default: 5)
--max-wait INT               # Max wait in seconds (e.g., '300s' or '300', default: 60)
--show                       # Display current idle checker configuration
```

### Example

```bash
python main.py run \
  --planner ApxNoveltyTarski \
  --domain test-domain \
  --duration-baseline 300s \
  --runs-baseline 2 \
  --time-limit-planner 1800s \
  --runs-planner 3
```

## Results

After execution, results are saved in the `./result/` directory as CSV files:

- `baseline_energy_measurement.csv`
- `<planner-name>_<domain>_energy_measurement.csv`

Each file contains the following columns:

- `label`: Measurement type (e.g. `measure_baseline` or `measure_planner`)
- `timestamp`: Time of measurement
- `duration`: Duration of the run
- `pkg`: Energy usage of the CPU package (in µJ)
- `dram`: Energy usage of RAM (in µJ)
- `socket`: CPU socket ID

Additionally, all generated plans are saved in the `./plan/` directory:

- `plan_{problem}_{domain-name}_{planner}.txt`

## Notes

- The planner is treated as a black-box unit during measurement.
  No internal phases (e.g., grounding, search, heuristic computation) are isolated or profiled individually.
- This tool requires systems with RAPL counters enabled. On unsupported CPUs, pyRAPL may not function properly.
- The planner is built inside an Apptainer container based on the `Apptainer.<planner>` recipe.
- After each problem run, the Apptainer cache is cleaned to avoid cached layer interference.
- The `time-limit` applies only to the subprocess execution. If set to `0s`, no timeout is applied.
- If multiple runs are specified (`--runs` or `--runs-planner`/`--runs-baseline`), the average energy consumption across
  runs is automatically computed by pyRAPL.
- If the `./plan/` or `./result/` directories do not exist when starting a measurement, they will be automatically
  created during execution.
- The idle checker ensures that the CPU load stays below a configurable threshold before starting measurements.
- All logs are stored in `energy_tool.log` in the project root.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

