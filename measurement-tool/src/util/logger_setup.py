import logging
from colorlog import ColoredFormatter


def setup_logging(log_file: str = "energy_measure.log", console_level=logging.INFO, file_level=logging.DEBUG):
    """
    Setups the logger with colored console output and file logging.

    :param log_file: Path to the log file.
    :param console_level: Log level for console output.
    :param file_level: Log level for file output.
    """
    # Root Logger
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    logger.info("Initializing logging...")

    # Clear existing handlers (prevents duplicate logs when re-running in notebooks/scripts)
    if logger.hasHandlers():
        logger.handlers.clear()

    # Formatter with colors for console
    console_formatter = ColoredFormatter(
        "%(log_color)s%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        log_colors={
            'DEBUG': 'cyan',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'red,bg_white',
        }
    )

    # Formatter for file (no color)
    file_formatter = logging.Formatter(
        "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )

    # Console Handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(console_level)
    console_handler.setFormatter(console_formatter)

    # File Handler
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(file_level)
    file_handler.setFormatter(file_formatter)

    # Add handlers to root logger
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)

    logger.info("Logging init complete")
