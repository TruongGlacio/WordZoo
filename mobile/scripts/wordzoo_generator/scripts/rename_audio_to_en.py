from pathlib import Path
import shutil

from json_utils import (
    load_json,
    save_json,
    iter_categories,
    iter_subcategories,
    iter_entities,
)

# ============================================================
# Config
# ============================================================

AUDIO_ROOT = Path(
    "wordzoo"
)
# ============================================================
# Rename helper
# ============================================================

def rename_audio(audio: dict):

    en = audio.get("en")
    vi = audio.get("vi")
    zh = audio.get("zh")

    if not en:
        return

    en_name = Path(en).name

    # ------------------------
    # VI
    # ------------------------

    if vi:

        vi_old = AUDIO_ROOT / Path(vi)

        vi_new = vi_old.parent / en_name

        if vi_old.exists():

            if vi_old != vi_new:

                shutil.move(
                    vi_old,
                    vi_new,
                )

        audio["vi"] = str(
            Path(vi).parent / en_name
        ).replace("\\", "/")

    # ------------------------
    # ZH
    # ------------------------

    if zh:

        zh_old = AUDIO_ROOT / Path(zh)

        zh_new = zh_old.parent / en_name

        if zh_old.exists():

            if zh_old != zh_new:

                shutil.move(
                    zh_old,
                    zh_new,
                )

        audio["zh"] = str(
            Path(zh).parent / en_name
        ).replace("\\", "/")


# ============================================================
# Main
# ============================================================

def rename_all_audio(data):

    # data = load_json()

    for category in iter_categories(data):

        rename_audio(
            category["audio"]
        )

    for _, subcategory in iter_subcategories(data):

        rename_audio(
            subcategory["audio"]
        )

    for _, _, entity in iter_entities(data):

        rename_audio(
            entity["audio"]
        )

    #save_json(data)

    print("Rename completed.")
    return  data


if __name__ == "__main__":

    rename_all_audio()