from pathlib import Path

# ============================================================
# Root project
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parent

TARGET_FOLDERS = {
    "vi",
    "zh",
}


# ============================================================
# Clear folder
# ============================================================

def clear_folder(folder: Path):

    count = 0

    for file in folder.rglob("*"):

        if file.is_file():
            file.unlink()
            count += 1

    print(f"[OK] {folder} : deleted {count} files")


# ============================================================
# Main
# ============================================================

def clear_all_vi_zh():

    total = 0

    for folder in PROJECT_ROOT.rglob("*"):

        if not folder.is_dir():
            continue

        if folder.name.lower() not in TARGET_FOLDERS:
            continue

        clear_folder(folder)
        total += 1

    print("--------------------------------")
    print(f"Processed {total} folders")
    print("Finished.")


if __name__ == "__main__":
    clear_all_vi_zh()