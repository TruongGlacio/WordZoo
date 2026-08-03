import asyncio
from animal_sound_generator import generate_all_animal_sound
from animal_sound_validator import (
    validate_animal_sound,
)
from json_utils import (
    load_json,
    save_json,
    statistics
)


from tts import (
    generate_all_audio
)
from resize_real_images import resize_all_images

from image_generator import ImageGenerator


from utils import (
    info,
    success,
    error
)
from download_real_image import generate_all_real_images


# ============================================================
# Print statistics
# ============================================================

def print_statistics(data):

    stats = statistics(data)


    print()
    print("==============================")
    print(" WordZoo Generator Statistics ")
    print("==============================")

    print(
        f"Categories     : {stats['categories']}"
    )

    print(
        f"Subcategories  : {stats['subcategories']}"
    )

    print(
        f"Entities       : {stats['entities']}"
    )

    print(
        f"Audio files    : {stats['audios']}"
    )

    print(
        f"Images         : {stats['images']}"
    )

    print("==============================")
    print()



# ============================================================
# Pipeline
# ============================================================


async def main():
    try:
        info(
            "Loading categories.json"
        )
        data = load_json()
        print_statistics(
            data
        )
        # ============================================
    # Validate animal sound library
    # ============================================

        missing = validate_animal_sound(data)
        if missing:
            print()
            print("Please complete animal_sound_library.py first.")
            print("Generation stopped.")

            return
        # ==============================================
        # AUDIO
        # ==============================================
        info(
            "Starting audio generation..."
        )
        await generate_all_audio(data)
        success(
            "Audio generation finished"
        )
        # Tiếng kêu động vật
        await generate_all_animal_sound(data)
        success(
            "generate_all_animal_sound finished"
        )
        # ==============================================
        # IMAGE
        # ==============================================
        info(
            "Starting image generation..."
        )
        #generator = ImageGenerator()
        #generator.generate_all( data )
        await generate_all_real_images(data)
        success(
            "Image generation finished"
        )

        resize_all_images()

        # ==============================================
        # SAVE JSON
        # ==============================================
        info(
            "Saving updated json..."
        )
        save_json( data )
        success(
            "Saved categories_updated.json"
        )

    except Exception as e:


        error(

            f"Pipeline failed: {e}"

        )

        raise



# ============================================================
# Entry
# ============================================================


if __name__ == "__main__":


    asyncio.run(

        main()

    )