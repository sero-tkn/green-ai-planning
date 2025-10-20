import logging
import os

logger = logging.getLogger(__name__)


def resolve_paths(project_root: str, planner: str, domain: str) -> dict:
    """
    Resolves and validates necessary paths for the planner and domain.

    :param project_root: Project root directory.
    :param planner: Planner name.
    :param domain: Domain name.
    :return: Dictionary with resolved paths.
    :raises FileNotFoundError: If essential files are missing.
    """
    planner_dir = os.path.join(project_root, f"../planner/{planner}")
    apptainer_recipe = os.path.join(planner_dir, f"Apptainer.{planner}")
    apptainer_sif = os.path.join(planner_dir, f"{planner}.sif")
    domain_dir = os.path.join(project_root, f"../domain/{domain}")
    domain_file = os.path.join(domain_dir, "domain.pddl")

    # Validate critical files
    if not os.path.isfile(apptainer_recipe):
        raise FileNotFoundError(f"Apptainer recipe not found: {apptainer_recipe}")
    if not os.path.isfile(domain_file):
        raise FileNotFoundError(f"Domain file not found: {domain_file}")

    # Find problem files
    problem_files = sorted([
        f for f in os.listdir(domain_dir)
        if f.startswith("problem") and f.endswith(".pddl")
    ])

    if not problem_files:
        raise FileNotFoundError(f"No problem files found in {domain_dir}")

    logger.info(f"Found {len(problem_files)} problem files for domain {domain}")

    return {
        "project_root": project_root,
        "planner_dir": planner_dir,
        "apptainer_recipe": apptainer_recipe,
        "apptainer_sif": apptainer_sif,
        "domain_dir": domain_dir,
        "domain_file": domain_file,
        "problem_files": problem_files
    }
