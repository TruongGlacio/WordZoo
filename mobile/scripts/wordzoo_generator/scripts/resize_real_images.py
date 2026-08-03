from pathlib import Path

from PIL import Image

# ============================================================
# Config
# ============================================================

IMAGE_ROOT = Path(
    "wordzoo"
)

TARGET_HEIGHT = 192

SUPPORTED = {
    ".jpg",
    ".jpeg",
    ".png",
    ".webp",
}

# ============================================================
# Resize
# ============================================================

def resize_image(file: Path):

    with Image.open(file) as img:

        width, height = img.size

        # Đã đúng chiều cao
        if abs(height - TARGET_HEIGHT) <= 1:
            print(f"Skip: {file.name}")
            return False

        scale = TARGET_HEIGHT / height

        new_width = round(width * scale)

        img = img.resize(
            (new_width, TARGET_HEIGHT),
            Image.Resampling.LANCZOS,
        )

        img.save(
            file,
            optimize=True,
        )

    return True
# ============================================================
# Main
# ============================================================

def resize_all_images():

    files = []

    for ext in SUPPORTED:
        files.extend(
            IMAGE_ROOT.rglob(f"*{ext}")
        )

    total = len(files)
    resized = 0

    print(f"Found {total} images")

    for index, file in enumerate(files, start=1):

        try:

            if resize_image(file):
                resized += 1
                print(f"[{index}/{total}] resized {file.name}")

        except Exception as e:

            print(
                f"[ERROR] {file}: {e}"
            )

    print("--------------------------------")
    print(f"Total    : {total}")
    print(f"Resized  : {resized}")
    print("Done.")


if __name__ == "__main__":
    resize_all_images()