"""
Generate animal sounds for entities.

Only entities recognized by animal_sound_library
will have AnimalSound/idle.mp3 generated.

The generated path will be written back to:

entity["animal_sound"]

Example:

wordzoo/
    animals/
        sub_categorys/
            wild_animals/
                entitys/
                    lion/
                        AnimalSound/
                            idle.mp3
"""

import asyncio

import edge_tts

from config import (
    ANIMAL_SOUND_FOLDER,
    ANIMAL_SOUND_FILE_NAME,
    ANIMAL_SOUND_EXTENSION,
    MAX_RETRY,
    RETRY_DELAY,
    ANIMAL_SOUND_VOICE,
)

from path_builder import PathBuilder

from animal_sound_library import (
    get_animal_sound,
)

from utils import (
    ensure_folder,
    file_exists,
    retry_async,
    progress,
    success,
    warning,
)

from json_utils import (
    iter_all_nodes,
)


# ============================================================
# Generate one animal sound
# ============================================================

@retry_async()
async def generate_sound(
        sound,
        output_file,
):

    communicate = edge_tts.Communicate(

        text=sound.text,

        voice= ANIMAL_SOUND_VOICE,

        rate=sound.rate,

        pitch=sound.pitch,

        volume=sound.volume,

    )

    await communicate.save(

        str(output_file)

    )


# ============================================================
# Json Path
# ============================================================

def json_path(path):

    return str(path).replace("\\", "/")


# ============================================================
# Process Entity
# ============================================================

async def process_entity(

        category,

        subcategory,

        entity,

):

    animal = get_animal_sound(

        entity["id"]

    )

    if animal is None:

        return False


    base = PathBuilder.entity(

        category,

        subcategory,

        entity,

    )


    folder = (

            base

            /

            ANIMAL_SOUND_FOLDER

    )


    ensure_folder(

        folder

    )


    output_file = (

            folder

            /

            (

                    ANIMAL_SOUND_FILE_NAME

                    +

                    ANIMAL_SOUND_EXTENSION

            )

    )


    if file_exists(output_file):

        warning(

            f"Skip animal sound: {output_file}"

        )

        entity["animal_sound"] = json_path(

            output_file

        )

        return True


    await generate_sound(

        animal,

        output_file,

    )


    entity["animal_sound"] = json_path(

        output_file

    )


    return True


# ============================================================
# Count
# ============================================================

def count_total_entities(data):

    total = 0

    for (
            node_type,
            category,
            subcategory,
            entity,
    ) in iter_all_nodes(data):

        if node_type != "entity":

            continue

        if get_animal_sound(

                entity["id"]

        ) is None:

            continue

        total += 1

    return total
# ============================================================
# Generate All Animal Sounds
# ============================================================

async def generate_all_animal_sound(data):

    total = count_total_entities(data)

    progress.reset(total)

    success(
        f"Found {total} animal sounds."
    )

    generated = 0
    skipped = 0
    failed = 0

    for (
            node_type,
            category,
            subcategory,
            entity,
    ) in iter_all_nodes(data):

        if node_type != "entity":
            continue

        animal = get_animal_sound(
            entity["id"]
        )

        if animal is None:
            continue

        try:

            base = PathBuilder.entity(
                category,
                subcategory,
                entity,
            )

            folder = (
                    base
                    / ANIMAL_SOUND_FOLDER
            )

            ensure_folder(folder)

            output_file = (
                    folder
                    /
                    (
                            ANIMAL_SOUND_FILE_NAME
                            +
                            ANIMAL_SOUND_EXTENSION
                    )
            )

            if file_exists(output_file):

                entity["animal_sound"] = json_path(
                    output_file
                )

                skipped += 1

                progress.next(
                    f"Skip: {entity['id']}"
                )

                continue

            await generate_sound(

                animal,

                output_file,

            )

            entity["animal_sound"] = json_path(
                output_file
            )

            generated += 1

            progress.next(
                f"Generated: {entity['id']}"
            )

        except Exception as e:

            failed += 1

            warning(
                f"{entity['id']} : {e}"
            )

            progress.next(
                f"Failed: {entity['id']}"
            )

    print()

    success(
        "Animal sound generation completed."
    )

    print(
        f"Generated : {generated}"
    )

    print(
        f"Skipped   : {skipped}"
    )

    print(
        f"Failed    : {failed}"
    )


# ============================================================
# Entry
# ============================================================

async def run(data):

    await generate_all_animal_sound(
        data
    )


# ============================================================
# Debug
# ============================================================

if __name__ == "__main__":

    from json_utils import (
        load_json,
        save_json,
    )

    data = load_json()

    asyncio.run(

        run(data)

    )

    save_json(data)

    success(
        "categories.json updated."
    )