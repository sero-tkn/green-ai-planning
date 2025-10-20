import logging
import os
import subprocess
import time

import pyRAPL

from src.util.system_idle_checker import wait_for_system_idle
from src.util.planner_path_resolver import resolve_paths
from src.util.build_apptainer_image import build_apptainer_image

logger = logging.getLogger(__name__)


def run_planner_measurement(planner: str, domain: str, time_limit: int, runs: int):
    """
    Measures the energy consumption of an AI planner executed via Apptainer containers across multiple planning problems using pyRAPL.
    Results are saved in ./result/planner_domain_energy_measurement.csv.
    The time_limit applies only to the subprocess execution (i.e., the container run), not as an internal parameter for the planner itself.
    After each run, the Apptainer cache is cleaned to avoid cached layer interference.

    :param planner: Name of the planner directory inside the 'planner' folder.
    :param domain: Name of the domain subfolder inside 'domain'.
    :param time_limit: Time limit (in seconds) for each subprocess execution.
    :param runs: Number of measurement-data runs for each problem; pyRAPL will compute the average internally.
    """
    try:
        logger.info(f"Initializing planner measurement-data for planner {planner} in domain {domain}")
        time_limit = None if time_limit == 0 else time_limit
        planner = planner.strip()
        domain = domain.strip()

        project_root = os.path.dirname(os.path.abspath(__file__))
        paths = resolve_paths(project_root, planner, domain)
        logger.info(f"Resolved paths for planner '{planner}' and domain '{domain}'")
        build_apptainer_image(
            planner_dir=paths["planner_dir"],
            planner=planner,
            apptainer_sif=paths["apptainer_sif"]
        )

        pyRAPL.setup()
        csv_output = pyRAPL.outputs.CSVOutput(f"result/{domain}_{planner}_energy_measurement.csv", append=True)

        for problem in paths["problem_files"]:
            logger.info(f"Preparing to run planner on problem '{problem}'")
            logger.info("Cleaning Apptainer cache to avoid layer caching...")
            subprocess.run('apptainer cache clean -f', shell=True, check=True)

            problem_path = os.path.join(paths["domain_dir"], problem)
            apptainer_command = [
                paths['apptainer_sif'],
                paths['domain_file'],
                problem_path,
                f"plan/plan_{problem}_{domain}_{planner}.txt"
            ]

            @pyRAPL.measureit(number=runs, output=csv_output)
            def measure_planner():
                start_time = time.time()

                try:
                    subprocess.run(apptainer_command,
                                   timeout=time_limit,
                                   check=True)
                    logger.info(f"Planner completed successfully for problem {problem} "
                                f"Elapsed time: {time.time() - start_time:.2f} seconds")
                except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as sub:
                    logger.warning(f"Planner execution terminates on {problem} without solution: {sub}. "
                                   f"Elapsed time: {time.time() - start_time:.2f} seconds")

            try:
                wait_for_system_idle()
                logger.info(f"Running planner command: {apptainer_command}")
                measure_planner()
                wait_for_system_idle()
                csv_output.save()
                logger.info(f"Measurement for problem {problem} completed and saved")
            except Exception as e:
                logger.error(f"Planner measurement-data failed for {problem}, no measurement-data possible: {e}", exc_info=True)

        logging.info(f"Planner measurement-data saved to result/{domain}_{planner}_energy_measurement.csv")
        subprocess.run('apptainer cache clean -f', shell=True, check=True)
    except Exception as e:
        logger.critical(f"Critical error during setup or execution: {e}", exc_info=True)
