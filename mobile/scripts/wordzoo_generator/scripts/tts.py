import asyncio

import edge_tts
from pathlib import Path
from config import (
    VOICE_MAP,
    AUDIO_EXTENSION
)

from path_builder import PathBuilder

from utils import (
    ensure_folder,
    file_exists,
    clean_filename,
    retry_async,
    progress,
    info,
    success,
    warning
)

from json_utils import (
    iter_all_nodes,
    iter_languages
)


# ============================================================
# Generate single audio
# ============================================================


@retry_async()
async def generate_audio(
        text: str,
        language: str,
        output_path
):

    communicate = edge_tts.Communicate(

        text=text,

        voice=VOICE_MAP[language]

    )


    await communicate.save(

        str(output_path)

    )


# ============================================================
# Process node
# ============================================================


async def process_node_audio(
        node,
        base_path
):

    """
    node:

    category

    subcategory

    entity

    """

    audio_result = {}


    tasks = []

    # luôn dùng tên tiếng Anh làm tên file
    english_name = clean_filename(
        node["names"]["en"]
    )
    for language, text in iter_languages(node):


        filename = ( english_name +  AUDIO_EXTENSION  )


        folder = PathBuilder.localized_folder(

            base_path,

            language

        )


        ensure_folder(folder)


        output_file = (

                folder

                /

                filename

        )


        json_path = build_audio_json_path(
            base_path,
            output_file,
        )

        audio_result[language] = json_path



        # Skip

        if file_exists(output_file):

            warning(

                f"Skip audio: {output_file}"

            )

            continue



        tasks.append(

            generate_audio(

                text,

                language,

                output_file

            )

        )


    if tasks:

        await asyncio.gather(

            *tasks

        )


    return audio_result



# ============================================================
# Category
# ============================================================


async def process_category_audio(
        category
):

    path = PathBuilder.category(

        category

    )


    return await process_node_audio(

        category,

        path

    )



# ============================================================
# Subcategory
# ============================================================


async def process_subcategory_audio(
        category,
        subcategory
):

    path = PathBuilder.subcategory(

        category,

        subcategory

    )


    return await process_node_audio(

        subcategory,

        path

    )



# ============================================================
# Entity
# ============================================================


async def process_entity_audio(
        category,
        subcategory,
        entity
):

    path = PathBuilder.entity(

        category,

        subcategory,

        entity

    )


    return await process_node_audio(

        entity,

        path

    )


# ============================================================
# Main TTS Pipeline
# ============================================================


async def generate_all_audio(data):


    total = 0


    for category, subcategory, entity in []:

        pass


    # count

    for node_type, category, subcategory, entity in iter_all_nodes(data):

        total += 3



    progress.reset(total)



    for (
            node_type,
            category,
            subcategory,
            entity
    ) in iter_all_nodes(data):


        if node_type == "category":


            result = await process_category_audio(

                category

            )


            category["audio"] = result



        elif node_type == "subcategory":


            result = await process_subcategory_audio(

                category,

                subcategory

            )


            subcategory["audio"] = result



        elif node_type == "entity":


            result = await process_entity_audio(

                category,

                subcategory,

                entity

            )


            entity["audio"] = result



        progress.next(

            f"{node_type}: {entity['id'] if entity else category['id']}"

        )


    success(

        "Generate audio completed"

    )

def build_audio_json_path(
        base_path,
        output_file,
):
    """
    Convert absolute audio path into
    WordZoo relative path.

    Example:

    D:/.../scripts/wordzoo_generator/scripts/wordzoo/
    plants/sub_categorys/flowers/entitys/rose/
    LocalizedNames/vi/Rose.mp3

    ->

    wordzoo/plants/sub_categorys/flowers/entitys/rose/
    LocalizedNames/vi/Rose.mp3
    """

    try:

        # Find "wordzoo" folder
        parts = output_file.parts

        index = parts.index("wordzoo")

        relative = Path(
            *parts[index:]
        )

        return str(
            relative
        ).replace("\\", "/")

    except ValueError:

        # fallback
        return str(
            output_file
        ).replace("\\", "/")