import json
from copy import deepcopy

from config import INPUT_JSON
from config import OUTPUT_JSON


# ============================================================
# Supported languages
# ============================================================

LANGUAGES = [
    "vi",
    "en",
    "zh",
    "es",
    "fr",
    "ja",
    "ko",
]


# ============================================================
# Load / Save
# ============================================================

def load_json():

    with open(
        INPUT_JSON,
        "r",
        encoding="utf-8"
    ) as f:

        return json.load(f)


def save_json(data):

    with open(
        OUTPUT_JSON,
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2
        )


# ============================================================
# Clone
# ============================================================

def clone(data):

    return deepcopy(data)


# ============================================================
# Category Iterator
# ============================================================

def iter_categories(data):

    for category in data["categories"]:

        yield category


# ============================================================
# SubCategory Iterator
# ============================================================

def iter_subcategories(data):

    for category in data["categories"]:

        for subcategory in category["subcategories"]:

            yield (
                category,
                subcategory
            )


# ============================================================
# Entity Iterator
# ============================================================

def iter_entities(data):

    for category in data["categories"]:

        for subcategory in category["subcategories"]:

            for entity in subcategory["entities"]:

                yield (
                    category,
                    subcategory,
                    entity
                )


# ============================================================
# All Nodes Iterator
# ============================================================

def iter_all_nodes(data):

    """
    Yield:

    category
    subcategory
    entity
    """

    for category in data["categories"]:

        yield (
            "category",
            category,
            None,
            None
        )

        for subcategory in category["subcategories"]:

            yield (
                "subcategory",
                category,
                subcategory,
                None
            )

            for entity in subcategory["entities"]:

                yield (
                    "entity",
                    category,
                    subcategory,
                    entity
                )


# ============================================================
# Language Iterator
# ============================================================

def iter_languages(node):

    """
    Yield all languages that actually exist
    in node["names"].

    Example:

    {
        "names": {
            "vi": "...",
            "en": "...",
            "zh": "...",
            "es": "...",
            "fr": "...",
            "ja": "...",
            "ko": "..."
        }
    }

    -> yields all 7 languages.

    Missing languages are skipped.
    """

    names = node.get(
        "names",
        {}
    )

    for language in LANGUAGES:

        if language not in names:
            continue

        text = names[language]

        if not isinstance(text, str):
            continue

        if not text.strip():
            continue

        yield (
            language,
            text
        )


# ============================================================
# Statistics
# ============================================================

def statistics(data):

    category_count = 0

    subcategory_count = 0

    entity_count = 0

    audio_count = 0

    for category in data["categories"]:

        category_count += 1

        # Category audio languages
        audio_count += len(
            category.get("names", {})
        )

        subcategory_count += len(
            category["subcategories"]
        )

        for subcategory in category["subcategories"]:

            # Subcategory audio languages
            audio_count += len(
                subcategory.get("names", {})
            )

            entity_count += len(
                subcategory["entities"]
            )

            for entity in subcategory["entities"]:

                # Entity audio languages
                audio_count += len(
                    entity.get("names", {})
                )

    return {

        "categories": category_count,

        "subcategories": subcategory_count,

        "entities": entity_count,

        "audios": audio_count,

        "images": (
            category_count
            + subcategory_count
            + entity_count
        )

    }


# ============================================================
# Find
# ============================================================

def find_entity(
        data,
        entity_id
):

    for _, _, entity in iter_entities(data):

        if entity["id"] == entity_id:

            return entity

    return None


def find_subcategory(
        data,
        subcategory_id
):

    for _, subcategory in iter_subcategories(data):

        if subcategory["id"] == subcategory_id:

            return subcategory

    return None


def find_category(
        data,
        category_id
):

    for category in iter_categories(data):

        if category["id"] == category_id:

            return category

    return None