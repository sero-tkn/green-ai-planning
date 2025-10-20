import logging
import time

import pyRAPL

from src.util.system_idle_checker import wait_for_system_idle

logger = logging.getLogger(__name__)


def run_baseline_measurement(duration: int, runs: int):
    """
    Measures baseline energy consumption by sleeping for a given duration. Results are saved in ./result/baseline_energy_measurement.csv.

    :param duration: Duration (in seconds) to sleep in each measurement-data run.
    :param runs: Number of measurement-data runs; pyRAPL will compute the average internally.
    """
    try:
        logger.info(f"Setting up baseline measurement-data with duration {duration} seconds and {runs} runs")
        pyRAPL.setup()
        csv_output = pyRAPL.outputs.CSVOutput("result/baseline_energy_measurement.csv", append=True)

        @pyRAPL.measureit(number=runs, output=csv_output)
        def measure_baseline():
            time.sleep(duration)

        try:
            wait_for_system_idle()
            logging.info(f"Starting baseline energy measurement-data: sleeping for {duration} seconds "
                         f"({runs} consecutive runs, estimated total duration: {duration * runs} seconds)...")
            measure_baseline()
            logger.info(f"Baseline measurement-data completed successfully.")
            wait_for_system_idle()
            csv_output.save()
            logging.info("Baseline measurement-data saved to baseline_energy_measurement.csv")
        except Exception as e:
            logger.error(f"Baseline measurement-data failed: {e}", exc_info=True)

    except Exception as e:
        logger.critical(f"Critical error setting up baseline measurement-data: {e}", exc_info=True)
