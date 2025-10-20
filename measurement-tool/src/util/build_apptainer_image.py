import logging
import os
import subprocess

logger = logging.getLogger(__name__)


def build_apptainer_image(planner_dir: str, planner: str, apptainer_sif: str):
    """
    Builds the Apptainer image if it does not exist or if the user chooses to rebuild.

    :param planner_dir: Path to the planner directory.
    :param planner: Planner name.
    :param apptainer_sif: Path to the Apptainer .sif file.
    """
    if not os.path.isfile(apptainer_sif):
        logging.info(f"Container {apptainer_sif} does not exist. Building now...")
        subprocess.run(["apptainer", "build", f"{planner}.sif", f"Apptainer.{planner}"],
                       cwd=planner_dir,
                       check=True)
    else:
        logging.info(f"Container {apptainer_sif} already exists.")
        user_input = input("Do you want to rebuild the container? [y/N]: ").strip().lower()
        if user_input == "y":
            logging.info(f"Rebuilding {apptainer_sif} ...")
            subprocess.run(["apptainer", "build", "--force", f"{planner}.sif", f"Apptainer.{planner}"],
                           cwd=planner_dir,
                           check=True)
        else:
            logging.info(f"Using existing container {apptainer_sif}.")
