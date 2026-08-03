from pathlib import Path

from config import (
    OUTPUT_DIR,
    LOCALIZED_FOLDER,
    IMAGE_FOLDER,
    SUBCATEGORY_FOLDER,
    ENTITY_FOLDER,
    AUDIO_EXTENSION,
    IMAGE_EXTENSION,
    IMAGE_FILE_NAME,
    ANIMAL_SOUND_FOLDER,
)


class PathBuilder:

    # ======================================================
    # Base
    # ======================================================

    @staticmethod
    def category(category):

        return OUTPUT_DIR / category["id"]


    @staticmethod
    def subcategory(category, subcategory):

        return (
                PathBuilder.category(category)
                / SUBCATEGORY_FOLDER
                / subcategory["id"]
        )


    @staticmethod
    def entity(category, subcategory, entity):

        return (
                PathBuilder.subcategory(category, subcategory)
                / ENTITY_FOLDER
                / entity["id"]
        )

    # ======================================================
    # Localized Folder
    # ======================================================

    @staticmethod
    def localized_folder(base: Path, language: str):

        return (
                base
                / LOCALIZED_FOLDER
                / language
        )

    # ======================================================
    # Audio
    # ======================================================

    @staticmethod
    def audio_file(base: Path, language: str, display_name: str):

        return (
                PathBuilder.localized_folder(base, language)
                / f"{display_name}{AUDIO_EXTENSION}"
        )

    # ======================================================
    # Image
    # ======================================================

    @staticmethod
    def image_folder(base: Path):

        return ( base/ IMAGE_FOLDER )


    @staticmethod
    def image_file(base: Path, filename:str):

        print(f"filename is : {filename}")
        return (
                PathBuilder.image_folder(base)
                / f"{filename}{IMAGE_EXTENSION}"
        )

    # ======================================================
    # Json Path
    # ======================================================

    @staticmethod
    def image_json_path(path: Path):

        """
        Convert absolute path
        to relative json path.

        Example

        D:/project/wordzoo/animals/...

        =>

        wordzoo/animals/...
        """

        return str(
            path.relative_to(
                OUTPUT_DIR.parent
            )
        ).replace("\\", "/")

    @staticmethod
    def audio_json_path(path: Path):

        return str(
            path.relative_to(
                OUTPUT_DIR.parent
            )
        ).replace("\\", "/")
    # ============================================================
# Animal Sound Folder
# ============================================================

    @staticmethod
    def animal_sound_folder(base_path):

        """
        Example:

        lion/

            AnimalSound/

        """

        return (base_path/ANIMAL_SOUND_FOLDER)