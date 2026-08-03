import asyncio
import functools
import os
import re
import shutil
from pathlib import Path

from config import MAX_RETRY
from config import RETRY_DELAY


# ============================================================
# Console Color
# ============================================================

GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"
CYAN = "\033[96m"
RESET = "\033[0m"


# ============================================================
# Print
# ============================================================

def info(msg):
    print(f"{CYAN}[INFO]{RESET} {msg}")


def success(msg):
    print(f"{GREEN}[OK]{RESET} {msg}")


def warning(msg):
    print(f"{YELLOW}[WARNING]{RESET} {msg}")


def error(msg):
    print(f"{RED}[ERROR]{RESET} {msg}")


# ============================================================
# Folder
# ============================================================

def ensure_folder(path):

    Path(path).mkdir(
        parents=True,
        exist_ok=True
    )


def remove_folder(path):

    if os.path.exists(path):

        shutil.rmtree(path)


# ============================================================
# File
# ============================================================

def file_exists(path):

    return Path(path).exists()


def delete_file(path):

    if file_exists(path):

        os.remove(path)


# ============================================================
# Filename
# ============================================================

INVALID = r'[<>:"/\\|?*]'


def clean_filename(name: str):

    """
    Windows filename
    """

    name = re.sub(
        INVALID,
        "",
        name
    )

    name = name.strip()

    name = name.rstrip(".")

    return name


# ============================================================
# Retry
# ============================================================

def retry_async(max_retry=MAX_RETRY):

    def decorator(func):

        @functools.wraps(func)

        async def wrapper(*args, **kwargs):

            last_exception = None

            for i in range(max_retry):

                try:

                    return await func(
                        *args,
                        **kwargs
                    )

                except Exception as e:

                    last_exception = e

                    warning(
                        f"{func.__name__} retry {i+1}/{max_retry}"
                    )

                    await asyncio.sleep(
                        RETRY_DELAY
                    )

            raise last_exception

        return wrapper

    return decorator


# ============================================================
# Progress
# ============================================================

class Progress:

    def __init__(self):

        self.total = 0

        self.current = 0


    def reset(self, total):

        self.total = total

        self.current = 0


    def next(self, message=""):

        self.current += 1

        print(
            f"[{self.current}/{self.total}] {message}"
        )


progress = Progress()


# ============================================================
# Json
# ============================================================

def update_json_audio(obj, language, path):

    if "audio" not in obj:

        obj["audio"] = {}

    obj["audio"][language] = path


def update_json_image(obj, path):

    obj["real_image"] = path


# ============================================================
# Count
# ============================================================

def count_total_audio(data):

    """
    category
    +
    subcategory
    +
    entity

    x 3 languages
    """

    count = 0

    for category in data["categories"]:

        count += 3

        for sub in category["subcategories"]:

            count += 3

            for entity in sub["entities"]:

                count += 3

    return count


def count_total_images(data):

    count = 0

    for category in data["categories"]:

        count += 1

        for sub in category["subcategories"]:

            count += 1

            count += len(
                sub["entities"]
            )

    return count