import asyncio
from pathlib import Path


from config import (
    CATEGORY_PROMPT,
    SUBCATEGORY_PROMPT,
    ENTITY_PROMPT
)


from path_builder import PathBuilder


from comfy_client import ComfyClient


from utils import (
    ensure_folder,
    file_exists,
    progress,
    success,
    warning,
    error
)



class ImageGenerator:


    def __init__(self):

        self.client = ComfyClient()



    # ======================================================
    # Build prompt
    # ======================================================

    def build_prompt(
            self,
            node_type,
            name
    ):


        if node_type == "category":

            return CATEGORY_PROMPT.format(
                name=name
            )


        if node_type == "subcategory":

            return SUBCATEGORY_PROMPT.format(
                name=name
            )


        return ENTITY_PROMPT.format(
            name=name
        )



    # ======================================================
    # Extract image
    # ======================================================

    def get_first_image(
            self,
            outputs
    ):


        for node_id in outputs:


            node_output = outputs[node_id]


            images = node_output.get(
                "images",
                []
            )


            if images:

                return images[0]


        return None



    # ======================================================
    # Generate single image
    # ======================================================

    def generate_image(
            self,
            node_type,
            node,
            folder
    ):


        image_path = PathBuilder.image_file(
            folder
        )


        # Skip

        if file_exists(image_path):

            warning(
                f"Skip image: {image_path}"
            )

            return PathBuilder.image_json_path(
                image_path
            )


        ensure_folder(
            image_path.parent
        )


        name = node["names"]["en"]


        prompt = self.build_prompt(
            node_type,
            name
        )


        try:

            outputs = self.client.generate(

                prompt

            )


            image_info = self.get_first_image(

                outputs

            )


            if image_info is None:

                raise Exception(
                    "No image returned"
                )


            self.client.download_image(

                image_info,

                image_path

            )


            return PathBuilder.image_json_path(

                image_path

            )


        except Exception as e:


            error(
                f"Image failed {name}: {e}"
            )


            return None



    # ======================================================
    # Category
    # ======================================================

    def process_category(
            self,
            category
    ):


        folder = PathBuilder.category(

            category

        )


        path = self.generate_image(

            "category",

            category,

            folder

        )


        if path:

            category["real_image"] = path



    # ======================================================
    # Subcategory
    # ======================================================

    def process_subcategory(
            self,
            category,
            subcategory
    ):


        folder = PathBuilder.subcategory(

            category,

            subcategory

        )


        path = self.generate_image(

            "subcategory",

            subcategory,

            folder

        )


        if path:

            subcategory["real_image"] = path



    # ======================================================
    # Entity
    # ======================================================

    def process_entity(
            self,
            category,
            subcategory,
            entity
    ):


        folder = PathBuilder.entity(

            category,

            subcategory,

            entity

        )


        path = self.generate_image(

            "entity",

            entity,

            folder

        )


        if path:

            entity["real_image"] = path



    # ======================================================
    # Main
    # ======================================================

    def generate_all(
            self,
            data
    ):


        total = 0


        for category in data["categories"]:

            total += 1

            for sub in category["subcategories"]:

                total += 1

                total += len(
                    sub["entities"]
                )


        progress.reset(
            total
        )


        for category in data["categories"]:


            self.process_category(

                category

            )


            progress.next(

                f"category {category['id']}"

            )


            for subcategory in category["subcategories"]:


                self.process_subcategory(

                    category,

                    subcategory

                )


                progress.next(

                    f"subcategory {subcategory['id']}"

                )


                for entity in subcategory["entities"]:


                    self.process_entity(

                        category,

                        subcategory,

                        entity

                    )


                    progress.next(

                        f"entity {entity['id']}"

                    )


        success(
            "Generate images completed"
        )