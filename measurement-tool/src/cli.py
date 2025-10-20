import argparse
import os
import time
import logging
import re

from src.measure_baseline_energy import run_baseline_measurement
from src.measure_planner_energy import run_planner_measurement
from src.util.logger_setup import setup_logging
from src.util.system_idle_checker import update_idle_config, print_idle_config

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def parse_time(time_string: str) -> int:
    """
    Converts a time string like '300' or '300s' into an integer number of seconds.

    :param time_string: Time input as a string (e.g. '300' or '300s')
    :return: Time in seconds as integer
    :raises ValueError: If the format is invalid or the value is negative
    """
    match = re.fullmatch(r'(\d+)(s)?', time_string.strip().lower())
    if not match:
        raise ValueError(f"Invalid time format: {time_string} (Allowed formats: '300' or '300s')")

    return int(match.group(1))


def ensure_directories():
    """
    Ensures that result and plan directories exist.
    """
    base_dir = os.path.dirname(os.path.abspath(__file__))
    result_dir = os.path.join(base_dir, "..", "result")
    plan_dir = os.path.join(base_dir, "..", "plan")
    os.makedirs(result_dir, exist_ok=True)
    os.makedirs(plan_dir, exist_ok=True)


def parse_arguments():
    """
    Parses command line arguments.
    """
    parser = argparse.ArgumentParser(description="Energy measurement-data tool for Classical Planner")
    subparsers = parser.add_subparsers(dest="command", required=True, help="Available commands")

    # Subparser: run both baseline and planner
    run = subparsers.add_parser("run", help="Run baseline and planner measurement-data")
    run.add_argument("--duration-baseline", type=str, default="1s",
                     help="Sleep duration per baseline run (e.g., '300s') (default: 1s)")
    run.add_argument("--runs-baseline", type=int, default=1,
                     help="Number of baseline measurement-data runs (default: 1)")
    run.add_argument("--planner", type=str, required=True,
                     help="Planner name (e.g., 'ApxNoveltyTarski')")
    run.add_argument("--domain", type=str, required=True,
                     help="Domain name (e.g., 'rubiks-cube')")
    run.add_argument("--time-limit-planner", type=str, default="0s",
                     help="Planner time limit (e.g., '1800s') (default: 0s = no limit)")
    run.add_argument("--runs-planner", type=int, default=1,
                     help="Number of planner measurement-data runs (default: 1)")

    # Subparser: only baseline
    baseline_parser = subparsers.add_parser("run-baseline", help="Run baseline energy measurement-data")
    baseline_parser.add_argument("--duration", type=str, default="1s",
                                 help="Sleep duration per run (e.g., '300s') (default: 1s)")
    baseline_parser.add_argument("--runs", type=int, default=1,
                                 help="Number of runs (default: 1)")

    # Subparser: only planner
    planner_parser = subparsers.add_parser("run-planner", help="Run planner energy measurement-data")
    planner_parser.add_argument("--planner", type=str, required=True,
                                help="Planner name (e.g., 'ApxNoveltyTarski')")
    planner_parser.add_argument("--domain", type=str, required=True,
                                help="Domain name (e.g., 'rubiks-cube')")
    planner_parser.add_argument("--time-limit", type=str, default="0s",
                                help="Planner time limit (e.g., '1800s') (default: 0s = no limit)")
    planner_parser.add_argument("--runs", type=int, default=1,
                                help="Number of runs (default: 1)")

    # Subparser: configure idle checker
    idle_parser = subparsers.add_parser("config-idle", help="Configure system idle checker")
    idle_parser.add_argument("--threshold", type=float,
                             help="CPU idle threshold in percent(default: 100.0)")
    idle_parser.add_argument("--interval", type=str,
                             help="Check interval in seconds (e.g., '10s') (default: 5s)")
    idle_parser.add_argument("--max-wait", type=str,
                             help="Max wait in seconds (e.g., '300s') (default: 10s)")
    idle_parser.add_argument("--show", action="store_true",
                             help="Show current configuration")

    return parser.parse_args()


def handle_command(args):
    """
    Handles the command based on parsed arguments.
    """
    start_time = time.time()

    try:
        if args.command == "run-baseline":
            duration = parse_time(args.duration)

            logging.info("Running baseline measurement-data...")
            run_baseline_measurement(duration=duration, runs=args.runs)
            logging.info(f"Baseline measurement-data completed in {time.time() - start_time:.2f} seconds")

        elif args.command == "run-planner":
            time_limit = parse_time(args.time_limit)

            logging.info("Running planner measurement-data...")
            run_planner_measurement(planner=args.planner, domain=args.domain, time_limit=time_limit, runs=args.runs)
            logging.info(f"Planner measurement-data completed in {time.time() - start_time:.2f} seconds")

        elif args.command == "run":
            duration_baseline = parse_time(args.duration_baseline)
            time_limit_planner = parse_time(args.time_limit_planner)

            logging.info("Running combined measurement-data...")
            logging.info("[1/2] Running baseline measurement-data...")
            run_baseline_measurement(duration=duration_baseline, runs=args.runs_baseline)
            logging.info("Baseline measurement-data completed")
            logging.info("[2/2] Running planner measurement-data...")
            run_planner_measurement(planner=args.planner, domain=args.domain, time_limit=time_limit_planner,
                                    runs=args.runs_planner)
            logging.info(f"Combined measurement-data completed in {time.time() - start_time:.2f} seconds")

        elif args.command == "config-idle":
            interval = parse_time(args.interval) if args.interval is not None else None
            max_wait = parse_time(args.max_wait) if args.max_wait is not None else None

            if args.show:
                print_idle_config()
            else:
                update_idle_config(threshold=args.threshold, interval=interval, max_wait=max_wait)

    except ValueError as e:
        logging.critical(e, exc_info=True)


def run_cli():
    """
    Entry point for the CLI module.
    """
    setup_logging()
    logger.info("")
    logger.info("")
    logger.info("")
    ensure_directories()
    args = parse_arguments()
    handle_command(args)
    logger.info("Logging completed")
