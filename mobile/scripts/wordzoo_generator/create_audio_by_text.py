import json
import asyncio
import edge_tts
import os
import re


JSON_FILE = "scripts/data_version1.json"

OUTPUT_ROOT = "wordzoo"


VOICES = {
    "vi": "vi-VN-HoaiMyNeural",
    "en": "en-US-JennyNeural",
    "zh": "zh-CN-XiaoxiaoNeural"
}



def clean_filename(name):

    # bỏ ký tự không hợp lệ Windows
    name = re.sub(
        r'[<>:"/\\|?*]',
        '',
        name
    )

    return name.strip()



async def generate_audio(
        text,
        lang,
        output
):

    if os.path.exists(output):
        print(
            "Skip:",
            output
        )
        return


    communicate = edge_tts.Communicate(
        text=text,
        voice=VOICES[lang]
    )


    await communicate.save(
        output
    )


    print(
        "Created:",
        output
    )



async def create_localized_audio(
        base_path,
        names
):

    for lang in [
        "vi",
        "en",
        "zh"
    ]:

        folder = os.path.join(
            base_path,
            "LocalizedNames",
            lang
        )

        os.makedirs(
            folder,
            exist_ok=True
        )


        filename = (
                clean_filename(
                    names[lang]
                )
                +
                ".wav"
        )


        path = os.path.join(
            folder,
            filename
        )


        await generate_audio(
            names[lang],
            lang,
            path
        )



async def process_json():

    with open(
            JSON_FILE,
            encoding="utf-8"
    ) as f:

        data = json.load(f)



    for category in data["categories"]:


        category_path = os.path.join(
            OUTPUT_ROOT,
            category["id"]
        )


        #
        # CATEGORY AUDIO
        #

        await create_localized_audio(
            category_path,
            category["names"]
        )



        #
        # SUBCATEGORY
        #

        for sub in category["subcategories"]:


            sub_path = os.path.join(
                category_path,
                "sub_categorys",
                sub["id"]
            )


            await create_localized_audio(
                sub_path,
                sub["names"]
            )



            #
            # ENTITY
            #

            for entity in sub["entities"]:


                entity_path = os.path.join(
                    sub_path,
                    "entitys",
                    entity["id"]
                )


                await create_localized_audio(
                    entity_path,
                    entity["names"]
                )




if __name__ == "__main__":

    asyncio.run(
        process_json()
    )