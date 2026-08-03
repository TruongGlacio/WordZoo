import json
import time
import uuid
import requests
from pathlib import Path

from config import (
    COMFY_URL,
    WORKFLOW_FILE,
    MAX_RETRY,
    RETRY_DELAY
)

from utils import (
    info,
    success,
    warning,
    error
)



class ComfyClient:


    def __init__(self):

        self.base_url = COMFY_URL



    # ======================================================
    # Load workflow
    # ======================================================

    def load_workflow(self):

        with open(
                WORKFLOW_FILE,
                "r",
                encoding="utf-8"
        ) as f:

            return json.load(f)



    # ======================================================
    # Update prompt
    # ======================================================

    def set_prompt(
            self,
            workflow,
            prompt,
            positive_node="6"
    ):

        """
        positive_node:
        node id chứa CLIP Text Encode

        cần chỉnh theo workflow của bạn
        """


        if positive_node in workflow:

            workflow[positive_node]["inputs"]["text"] = prompt


        return workflow



    # ======================================================
    # Queue prompt
    # ======================================================

    def queue_prompt(
            self,
            workflow
    ):


        client_id = str(
            uuid.uuid4()
        )


        payload = {

            "prompt": workflow,

            "client_id": client_id

        }


        url = (

                self.base_url

                +

                "/prompt"

        )


        response = requests.post(

            url,

            json=payload,

            timeout=60

        )


        response.raise_for_status()


        return response.json()



    # ======================================================
    # Check history
    # ======================================================

    def get_history(
            self,
            prompt_id
    ):


        url = (

                self.base_url

                +

                f"/history/{prompt_id}"

        )


        response = requests.get(

            url,

            timeout=60

        )


        response.raise_for_status()


        return response.json()



    # ======================================================
    # Wait complete
    # ======================================================

    def wait_result(
            self,
            prompt_id
    ):


        info(
            f"Waiting ComfyUI: {prompt_id}"
        )


        while True:


            history = self.get_history(

                prompt_id

            )


            if prompt_id in history:


                data = history[prompt_id]


                outputs = data.get(

                    "outputs",

                    {}

                )


                return outputs



            time.sleep(2)



    # ======================================================
    # Download image
    # ======================================================

    def download_image(
            self,
            image_info,
            output_path
    ):


        filename = image_info["filename"]

        subfolder = image_info.get(
            "subfolder",
            ""
        )

        folder_type = image_info.get(
            "type",
            "output"
        )


        url = (

                self.base_url

                +

                "/view"

        )


        params = {

            "filename": filename,

            "subfolder": subfolder,

            "type": folder_type

        }


        response = requests.get(

            url,

            params=params,

            timeout=120

        )


        response.raise_for_status()


        with open(

                output_path,

                "wb"

        ) as f:

            f.write(

                response.content

            )


        success(

            f"Saved image: {output_path}"

        )



    # ======================================================
    # Generate image
    # ======================================================

    def generate(
            self,
            prompt
    ):


        workflow = self.load_workflow()


        workflow = self.set_prompt(

            workflow,

            prompt

        )


        result = self.queue_prompt(

            workflow

        )


        prompt_id = result["prompt_id"]


        outputs = self.wait_result(

            prompt_id

        )


        return outputs