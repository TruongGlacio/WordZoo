"""
Global configuration for WordZoo Generator
"""

from pathlib import Path

# ==========================================================
# Project
# ==========================================================

PROJECT_ROOT = Path(__file__).resolve().parent

INPUT_JSON = PROJECT_ROOT / "data_version1.json"

OUTPUT_JSON = PROJECT_ROOT / "data_version1_final.json"

OUTPUT_DIR = PROJECT_ROOT / "wordzoo"

# ==========================================================
# Folder names
# ==========================================================

LOCALIZED_FOLDER = "LocalizedNames"

IMAGE_FOLDER = ""

SUBCATEGORY_FOLDER = "sub_categorys"

ENTITY_FOLDER = "entitys"

# ==========================================================
# Audio
# ==========================================================

AUDIO_EXTENSION = ".mp3"

VOICE_MAP = {

    "vi": "vi-VN-HoaiMyNeural",

    "en": "en-US-JennyNeural",

    "zh": "zh-CN-XiaoxiaoNeural"
}
# ==========================================================
# Animal Sound
# ==========================================================

ENABLE_ANIMAL_SOUND = True

ANIMAL_SOUND_FOLDER = "AnimalSound"

ANIMAL_SOUND_FILE_NAME = "idle"

ANIMAL_SOUND_EXTENSION = ".mp3"

ANIMAL_SOUND_VOICE = "en-US-GuyNeural"

# ==========================================================
# Image
# ==========================================================

IMAGE_EXTENSION = ".png"

IMAGE_FILE_NAME = "real"

# ==========================================================
# ComfyUI
# ==========================================================

COMFY_HOST = "127.0.0.1"

COMFY_PORT = 8188

COMFY_URL = f"http://{COMFY_HOST}:{COMFY_PORT}"

WORKFLOW_FILE = PROJECT_ROOT / "workflow_api.json"

# ==========================================================
# Retry
# ==========================================================

MAX_RETRY = 3

RETRY_DELAY = 3

# ==========================================================
# Prompt
# ==========================================================

ENTITY_PROMPT = (
    "A realistic photo of {name}, "
    "isolated object, centered, "
    "white background, "
    "high quality, "
    "8k, "
    "educational"
)

SUBCATEGORY_PROMPT = (
    "A realistic educational illustration of {name}, "
    "multiple representative objects, "
    "white background, "
    "high quality, "
    "8k"
)

CATEGORY_PROMPT = (
    "A realistic educational illustration of {name}, "
    "multiple representative objects, "
    "white background, "
    "high quality, "
    "8k"
)