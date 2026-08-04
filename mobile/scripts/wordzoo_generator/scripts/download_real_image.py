import asyncio
import requests

from utils import (
    ensure_folder,
    file_exists,
    retry_async,
    progress,
    warning,
    success,
)

from path_builder import PathBuilder

from json_utils import (
    iter_categories,
    iter_subcategories,
    iter_entities,
)

from image_provider import (
    get_provider,
    ImageProvider,
)
from flaticon_api import (
    search_flaticon,
    download_flaticon,
)
# ============================================================
# Wikimedia Commons
# ============================================================

COMMONS_API = "https://commons.wikimedia.org/w/api.php"

HEADERS = {
    "User-Agent": "WordZoo/1.0"
}

CATEGORY_CONTEXT = {

    "animals": "animal",

    "plants": "plants",

    "vehicles": "vehicle",

    "human_relations": "human",

}
IMAGE_EXTENSIONS = (
    ".jpg",
    ".jpeg",
    ".png",
    ".webp",
)

BAD_KEYWORDS = [

    "logo",
    "icon",
    "symbol",
    "emoji",
    "flag",
    "map",
    "vector",
    "svg",
    "drawing",
    "illustration",
    "clipart",
    "cartoon",

]

# ============================================================
# Keyword Builder
# ============================================================

def build_category_keywords(category):

    name = category["names"]["en"]

    context = CATEGORY_CONTEXT.get(
        category["id"],
        ""
    )

    return [

        #name,

        f"{context}",
        #f"{name} {context}",

        #category["id"].replace("_", " "),

    ]


def build_subcategory_keywords(

        category,
        subcategory,

):

    context = CATEGORY_CONTEXT.get(

        category["id"],

        ""

    )

    return [
        f'{subcategory["names"]["en"]} {context}',

        #subcategory["names"]["en"],

        #subcategory["id"].replace("_", " "),


    ]


def build_entity_keywords(

        category,
        subcategory,
        entity,

):

    context = CATEGORY_CONTEXT.get(

        category["id"],

        ""

    )

    return [

        f'{entity["names"]["en"]} {context}',

        #f'{entity["names"]["en"]} {category["names"]["en"]}',

        #entity["names"]["en"],

        #entity["id"].replace("_", " "),


    ]


# ============================================================
# Wikimedia Search
# ============================================================

@retry_async()
async def search_wikimedia(keyword):

    params = {

        "action": "query",

        "generator": "search",

        "gsrsearch": keyword,

        "gsrnamespace": 6,

        "gsrlimit": 20,

        "prop": "imageinfo|categories",

        "iiprop": "url",

        "iiurlwidth": 512,

        "cllimit": 20,

        "format": "json",

    }
    response = requests.get(

        COMMONS_API,

        params=params,

        headers=HEADERS,

        timeout=30,

    )

    response.raise_for_status()

    data = response.json()

    pages = data.get(

        "query",

        {}

    ).get(

        "pages",

        {}

    )

    if not pages:

        return None

    best_score = -999

    best_url = None

    for page in pages.values():

        infos = page.get(

            "imageinfo",

            []

        )

        if not infos:

            continue

        info = infos[0]

        url = info.get("thumburl") or info.get("url")
        if not url.lower().endswith(

                IMAGE_EXTENSIONS

        ):

            continue

        score = 0

        title = page.get(

            "title",

            ""

        ).lower()

        categories = " ".join(

            c["title"]

            for c in page.get(

                "categories",

                []

            )

        ).lower()

        text = title + " " + categories

        #
        # Positive
        #

        positives = [

            "photograph",

            "animals",

            "plants",

            "birds",

            "mammals",

            "fish",

            "reptiles",

            "flowers",

            "trees",

        ]

        for p in positives:

            if p in text:

                score += 20

        #
        # Negative
        #

        for bad in BAD_KEYWORDS:

            if bad in text:

                score -= 100

        if score > best_score:

            best_score = score

            best_url = url

    return best_url


# ============================================================
# Provider Search
# ============================================================

async def search_pexels(keywords):

    return None


async def search_pixabay(keywords):

    return None


async def search_best_image(

        provider,

        keywords,

):

    for keyword in keywords:

        print(f"search keyword is: {keyword}")
        try:

            if provider == ImageProvider.WIKIMEDIA:

                url = await search_wikimedia(keyword)

            elif provider == ImageProvider.FLATICON:

                icon = search_flaticon(keyword)

                if icon:

                    return {
                        "provider": "flaticon",
                        "id": icon["id"]
                    }

                url = None

            elif provider == ImageProvider.PEXELS:

                url = await search_pexels(keyword)

            elif provider == ImageProvider.PIXABAY:

                url = await search_pixabay(keyword)

            else:

                url = None

            if url:

                return url

        except Exception as e:

            warning(

                f"{keyword} : {e}"

            )

    return None

# ============================================================
# Download Image
# ============================================================

#@retry_async()
async def download_image(

        url,
        output_file,

):

    print(f"download_image url is: {url}, output_file is: {output_file}")
    #
    # Flaticon
    #

    if isinstance(url, dict):

        if url["provider"] == "flaticon":

            download_flaticon(

                url["id"],

                output_file,

            )

            return
        
    response = requests.get(

        url,

        headers=HEADERS,

        timeout=60,

        stream=True,

    )

    response.raise_for_status()

    ensure_folder(

        output_file.parent

    )

    with open(

            output_file,

            "wb",

    ) as f:

        for chunk in response.iter_content(

                8192

        ):

            if chunk:

                f.write(chunk)


# ============================================================
# Common Process
# ============================================================

async def process_image(

        provider_key,
        keywords,
        output_file,
        json_object,
        display_name,

):

    #
    # Skip
    #
    #print(f"output File path: {output_file}")
    if file_exists(output_file):
        json_object["real_image"] = (

            PathBuilder.image_json_path(

                output_file

            )

        )

        #warning(  f"Skip: {display_name}"  )

        progress.next(display_name)

        return

    #
    # Provider
    #

    provider = get_provider(

        provider_key

    )

    #await asyncio.sleep(1)
    print(f"output File path: {output_file}")
    image_url = await search_best_image(

        provider,

        keywords,

    )

    if image_url is None:

        warning(

            f"No image: {display_name}"

        )

        progress.next(display_name)

        return

    #
    # Download
    #

    try:
        await asyncio.sleep(7)
        await download_image(

            image_url,

            output_file,

        )


    except Exception as e:
        await asyncio.sleep(20)
        warning(

            f"Download failed: {display_name} : {e}"

        )

        progress.next(display_name)

        return

    #
    # Verify
    #

    if not file_exists(output_file):

        warning(

            f"File missing: {display_name}"

        )

        progress.next(display_name)

        return

    #
    # Update JSON
    #

    json_object["real_image"] = (

        PathBuilder.image_json_path(

            output_file

        )

    )

    success(

        f"Downloaded: {display_name}"

    )

    progress.next(

        display_name

    )


# ============================================================
# Category
# ============================================================

async def process_category(

        category,

):

    provider_key=category['id']
    keywords=build_category_keywords(
        category,
    ),

    print(f"provider_key is: {provider_key},keywords category is {keywords} ")

    await process_image(
        provider_key=provider_key,
        keywords=keywords,

        output_file=PathBuilder.image_file(

            PathBuilder.category(

                category,

            ),
            provider_key
        ),

        json_object=category,

        display_name=category["id"],

    )


# ============================================================
# Subcategory
# ============================================================

async def process_subcategory(

        category,
        subcategory,

):
    provider_key=subcategory["id"]
    keywords=build_subcategory_keywords(
        category,
        subcategory,

    ),
    print(f"provider_key is: {provider_key},keywords is {keywords} ")
    await process_image(

        provider_key=provider_key,

        keywords= keywords,

        output_file=PathBuilder.image_file(

            PathBuilder.subcategory(

                category,
                subcategory,

            ),
            provider_key

        ),

        json_object=subcategory,

        display_name=subcategory["id"],

    )


# ============================================================
# Entity
# ============================================================

async def process_entity(

        category,
        subcategory,
        entity,

):
    filename=entity["id"]
    provider_key=subcategory["id"],
    keywords=build_entity_keywords(
        category,
        subcategory,
        entity,
    ),

    print(f"provider_key is: {provider_key},keywords is {keywords} ")
    await process_image(

        provider_key=provider_key,
        keywords=keywords,

        output_file=PathBuilder.image_file(

            PathBuilder.entity(
                category,
                subcategory,
                entity,

            ),
            filename

        ),

        json_object=entity,

        display_name=entity["id"],

    )


# ============================================================
# Batch Process
# ============================================================

async def process_batch(

        batch,

):

    tasks = []

    for task_type, payload in batch:

        if task_type == "category":

            tasks.append(

                process_category(

                    payload

                )

            )

        elif task_type == "subcategory":

            category, subcategory = payload

            tasks.append(

                process_subcategory(

                    category,

                    subcategory,

                )

            )

        elif task_type == "entity":

            category, subcategory, entity = payload

            tasks.append(

                process_entity(

                    category,

                    subcategory,

                    entity,

                )

            )

    await asyncio.gather(

        *tasks,

        #return_exceptions=True,

    )


# ============================================================
# Build Task List
# ============================================================

def build_tasks(

        data,

):

    tasks = []

    #
    # Categories
    #

    for category in iter_categories(data):

        tasks.append(

            (

                "category",

                category,

            )

        )

    #
    # Subcategories
    #

    for category, subcategory in iter_subcategories(data):

        tasks.append(

            (

                "subcategory",

                (

                    category,

                    subcategory,

                ),

            )

        )

    #
    # Entities
    #

    for category, subcategory, entity in iter_entities(data):

        tasks.append(

            (

                "entity",

                (

                    category,

                    subcategory,

                    entity,

                ),

            )

        )

    return tasks


# ============================================================
# Split Batch
# ============================================================

def split_batches(

        tasks,

        batch_size=1,

):

    current = []

    for task in tasks:

        current.append(

            task

        )

        if len(current) >= batch_size:

            yield current

            current = []

    if current:

        yield current


# ============================================================
# Main Pipeline
# ============================================================

async def generate_all_real_images(

        data,

):

    tasks = build_tasks(

        data

    )

    progress.reset(

        len(tasks)

    )

    success(

        f"Need download {len(tasks)} images."

    )

    for batch in split_batches(

            tasks,

            batch_size=1,

    ):

        await process_batch(

            batch

        )

    success(

        "Download completed."

    )

# ============================================================
# Test
# ============================================================

if __name__ == "__main__":

    from json_utils import (

        load_json,

        save_json,

    )

    data = load_json()

    asyncio.run(

        generate_all_real_images(

            data

        )

    )

    save_json(

        data

    )

    success(

        "JSON updated."

    )