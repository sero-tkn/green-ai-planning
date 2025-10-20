import json
import logging
import os

import psutil

logger = logging.getLogger(__name__)

# Path to the idle configuration file
CONFIG_FILE = os.path.join(os.path.dirname(__file__), 'config', 'idle_config.json')
# Default configuration values
DEFAULT_CONFIG = {
    "cpu_idle_threshold": 100.0,
    "check_interval_seconds": 5,
    "max_wait_seconds": 10
}


def load_config():
    """
    Loads the idle checker configuration from a JSON file.
    If the file does not exist, returns the default configuration.
    """
    if os.path.isfile(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            return json.load(file)
    else:
        return DEFAULT_CONFIG.copy()


def save_config(config):
    """
    Saves the given configuration to the JSON file.
    """
    with open(CONFIG_FILE, 'w') as file:
        json.dump(config, file, indent=4)


def wait_for_system_idle():
    """
    Waits until the system is considered idle based on the CPU usage threshold.
    Checks CPU usage periodically until either the CPU usage drops below the threshold or the maximum wait time is exceeded.
    """
    config = load_config()
    threshold = config["cpu_idle_threshold"]
    interval = config["check_interval_seconds"]
    max_wait = config["max_wait_seconds"]
    logging.info(f"Waiting for system to be idle (CPU usage < {threshold}%)...")

    waited = 0
    while waited < max_wait:
        cpu = psutil.cpu_percent(interval=interval)
        mem = psutil.virtual_memory()
        used_gb = mem.used / (1024 ** 3)
        avail_gb = mem.available / (1024 ** 3)
        mem_percent = mem.percent

        if cpu < threshold:
            logging.info(f"System is idle. CPU: {cpu:.2f}%, RAM used: {used_gb:.2f} GB, "
                         f"available: {avail_gb:.2f} GB ({mem_percent:.2f}%). Continuing...")
            return
        else:
            waited += interval
            logging.info(f"CPU usage: {cpu:.2f}%, RAM used: {used_gb:.2f} GB, "
                         f"available: {avail_gb:.2f} GB ({mem_percent:.2f}%). Waiting...")

    logging.warning(f"Max wait time ({max_wait} seconds) exceeded. Continuing anyway...")


def update_idle_config(threshold: float, interval: int, max_wait: int):
    """
    Updates the idle checker configuration.
    If a parameter is None, the previous value is kept.
    The updated configuration is saved to the JSON file.
    """
    config = load_config()
    if threshold is not None:
        config["cpu_idle_threshold"] = threshold
    if interval is not None:
        config["check_interval_seconds"] = interval
    if max_wait is not None:
        config["max_wait_seconds"] = max_wait

    save_config(config)
    logging.info("Idle configuration updated:")
    logging.info(json.dumps(config, indent=4))


def print_idle_config():
    """
    Prints the current idle checker configuration.
    """
    config = load_config()
    logging.info("Current Idle Checker Configuration:")
    logging.info(json.dumps(config, indent=4))
