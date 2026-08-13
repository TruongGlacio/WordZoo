"""
generate_visual_descriptions.py

Generate visual_description for every:

    category
    subcategory
    entity

in WordZoo JSON using local Ollama + Qwen3.5 9B.

The generated visual_description is stored directly inside
each corresponding object in wordzoo_data.json.

Example:

{
    "id": "lion",
    "names": {
        "vi": "Sư tử",
        "en": "Lion",
        "zh": "狮子"
    },
    "visual_description": "A large tawny wild cat..."
}

Requirements:

    Ollama must be running.

Recommended model:

    qwen3.5:9b

Ollama URL:

    http://127.0.0.1:11434

The public function is:

    generate_all_visual_descriptions(data)

so main.py can call it directly.
"""

from __future__ import annotations

import json
import time
from typing import Any

import requests

from json_utils import iter_all_nodes
from utils import (
    success,
    warning,
    progress,
)


# ============================================================
# Configuration
# ============================================================

OLLAMA_URL = "http://127.0.0.1:11434"

MODEL_NAME = "qwen3:8b"

REQUEST_TIMEOUT = 300

MAX_RETRIES = 3

RETRY_DELAY = 2


# ============================================================
# Ollama
# ============================================================

SESSION = requests.Session()


def check_ollama() -> None:
    """
    Check that Ollama is running and the required model exists.
    """

    try:

        response = SESSION.get(
            f"{OLLAMA_URL}/api/tags",
            timeout=5,
        )

        response.raise_for_status()

        models = response.json().get(
            "models",
            []
        )

        model_names = [
            model.get("name", "")
            for model in models
        ]

        if not any(
                name == MODEL_NAME
                or name.startswith(MODEL_NAME + ":")
                for name in model_names
        ):

            raise RuntimeError(
                f"Ollama is running but model "
                f"'{MODEL_NAME}' was not found.\n\n"
                f"Available models:\n"
                + "\n".join(
                    f"  - {name}"
                    for name in model_names
                )
                + f"\n\nRun:\n"
                  f"ollama pull {MODEL_NAME}"
            )

    except requests.RequestException as exc:

        raise RuntimeError(
            f"Cannot connect to Ollama at "
            f"{OLLAMA_URL}.\n\n"
            f"Start Ollama first.\n\n"
            f"Original error: {exc}"
        ) from exc


# ============================================================
# Prompt
# ============================================================

SYSTEM_PROMPT = """
You generate short visual descriptions for a children's image generator.

Describe only visible physical characteristics.

Rules:
- Return ONLY the description.
- 25-50 words.
- No explanation.
- No JSON.
- No text, letters, labels or watermark.
- Make the subject immediately recognizable.
- Include distinctive features.
- Use simple concrete English.
"""
CATEGORY_RULES = {
    "animals": """
The subject is an animal.

Describe the animal's physical appearance precisely.
Prioritize species-defining characteristics.

The animal must be shown as a complete recognizable animal,
preferably standing or sitting in a natural pose.
Do not describe scenery unless it is necessary to identify the animal.
""",

    "plants": """
The subject is a plant.

Describe the visible plant structure precisely:
stem or trunk, leaves, flowers, fruits, colors and distinctive shape.

Show the complete plant whenever possible.
Do not focus on a landscape or garden.
""",

    "vehicles": """
The subject is a vehicle.

Describe its physical structure precisely:
body shape, wheels, windows, doors, lights and other distinctive
components.

The vehicle itself must be the dominant subject.
Do not describe roads or large environments.
""",

    "human_relations": """
The subject represents a human relationship.

Describe the people and their visible relationship:
number of people, approximate ages, relative positions,
physical interaction and natural body language.

The relationship must be visually understandable without text.
""",
}

def build_prompt(
        node_type: str,
        category: dict[str, Any],
        subcategory: dict[str, Any] | None,
        entity: dict[str, Any] | None,
) -> str:

    category_id = category.get("id", "")
    category_name = category["names"]["en"]

    category_rule = CATEGORY_RULES.get(
        category_id,
        ""
    )

    # ========================================================
    # CATEGORY
    # ========================================================

    if node_type == "category":

        name = category["names"]["en"]

        return f"""
Create a visual description representing the educational category:

Category: {name}

{category_rule}

The image should visually communicate the general category
to a young child.

Do not simply describe the written meaning of the word.
Describe a clear visual composition.

Return ONLY the visual description.
""".strip()

    # ========================================================
    # SUBCATEGORY
    # ========================================================

    if node_type == "subcategory":

        name = subcategory["names"]["en"]

        return f"""
Create a visual description representing this educational
subcategory:

Category: {category_name}
Subcategory: {name}

{category_rule}

The visual description must clearly communicate the subcategory
to a young child.

Use concrete visible subjects rather than abstract explanations.

Return ONLY the visual description.
""".strip()

    # ========================================================
    # ENTITY
    # ========================================================

    if node_type == "entity":

        name = entity["names"]["en"]

        category_name = category["names"]["en"]

        subcategory_name = subcategory["names"]["en"]

        return f"""
Describe the visual appearance of:

Entity: {name}
Category: {category_name}
Subcategory: {subcategory_name}

Write one concise visual description of this subject for an image generator.
Describe only visible physical features that make it immediately recognizable.
Use about 25-50 words.
Return only the description..
""".strip()

    raise ValueError(
        f"Unknown node type: {node_type}"
    )

# ============================================================
# Generate
# ============================================================

def generate_description(
        node_type: str,
        category: dict[str, Any],
        subcategory: dict[str, Any] | None,
        entity: dict[str, Any] | None,
) -> str:

    user_prompt = build_prompt(
        node_type,
        category,
        subcategory,
        entity,
    )

    payload = {

        "model": MODEL_NAME,

        "system": SYSTEM_PROMPT,

        "prompt": user_prompt,

        "stream": False,
        "think": False,
        "options": {
            "temperature": 0.2,
            "top_p": 0.8,
            "num_predict": 120,
            "num_ctx": 2048,

        },
    }

    for attempt in range(
            1,
            MAX_RETRIES + 1,
    ):

        try:

            response = SESSION.post(
                f"{OLLAMA_URL}/api/generate",
                json=payload,
                timeout=REQUEST_TIMEOUT,
            )

            response.raise_for_status()

            result = response.json()
            print("[Ollama RAW RESPONSE]")
            print(result)
            text = result.get(
                "response",
                "",
            ).strip()
# Remove accidental markdown code fences.
            if text.startswith("```"):
                text = text.replace("```text", "")
                text = text.replace("```", "")
                text = text.strip()

            # Remove accidental JSON-like wrapping.
            if text.startswith("{") and text.endswith("}"):
                raise RuntimeError(
                    "Qwen returned JSON instead of a visual description."
                )

            if len(text) < 15:
                raise RuntimeError(
                    f"Generated description is too short: {text}"
                )

            if len(text) > 600:
                warning(
                    f"Generated description is unusually long: "
                    f"{len(text)} characters"
                )
            if not text:

                raise RuntimeError(
                    "Ollama returned an empty response."
                )

            # Remove accidental surrounding quotes.
            text = text.strip(
                '"'
            ).strip()

            return text

        except Exception as exc:

            if attempt >= MAX_RETRIES:

                raise RuntimeError(
                    f"Failed after {MAX_RETRIES} attempts: "
                    f"{exc}"
                ) from exc

            warning(
                f"Ollama generation failed "
                f"(attempt {attempt}/{MAX_RETRIES}): "
                f"{exc}"
            )

            time.sleep(
                RETRY_DELAY
            )

    raise RuntimeError(
        "Unexpected generation failure."
    )


# ============================================================
# Node helpers
# ============================================================

def node_display_name(
        node_type: str,
        category: dict[str, Any],
        subcategory: dict[str, Any] | None,
        entity: dict[str, Any] | None,
) -> str:

    if node_type == "category":

        return (
            f"category/{category['id']}"
        )

    if node_type == "subcategory":

        return (
            f"subcategory/"
            f"{subcategory['id']}"
        )

    if node_type == "entity":

        return (
            f"entity/"
            f"{entity['id']}"
        )

    return node_type


# ============================================================
# Main generation
# ============================================================

def generate_all_visual_descriptions(
        data: Any,
) -> None:

    from json_utils import save_json

    # ========================================================
    # Check Ollama
    # ========================================================

    check_ollama()

    # ========================================================
    # Build node list
    # ========================================================

    nodes = list(
        iter_all_nodes(data)
    )

    total = len(nodes)

    progress.reset(total)

    success(
        f"Found {total} WordZoo nodes."
    )

    # ========================================================
    # Statistics
    # ========================================================

    generated = 0
    skipped = 0
    failed = 0

    # ========================================================
    # Process nodes sequentially
    # ========================================================

    for index, (
            node_type,
            category,
            subcategory,
            entity,
    ) in enumerate(
        nodes,
        start=1,
    ):

        # ----------------------------------------------------
        # Select target node
        # ----------------------------------------------------

        if node_type == "category":

            node = category

        elif node_type == "subcategory":

            node = subcategory

        elif node_type == "entity":

            node = entity

        else:

            warning(
                f"Unknown node type: {node_type}"
            )

            failed += 1

            progress.next(
                node_type
            )

            continue

        # ----------------------------------------------------
        # Display name
        # ----------------------------------------------------

        display_name = node_display_name(
            node_type,
            category,
            subcategory,
            entity,
        )

        print()
        print(
            "=" * 70
        )

        print(
            f"[Visual Description] "
            f"{index}/{total}"
        )

        print(
            f"Node: {display_name}"
        )

        # ----------------------------------------------------
        # Resume support
        #
        # If visual_description already exists,
        # do NOT call Qwen again.
        # ----------------------------------------------------

        existing = node.get(
            "visual_description"
        )

        if (
                isinstance(existing, str)
                and existing.strip()
        ):

            print(
                f"[SKIP] Already exists:"
            )

            print(
                f"       {existing}"
            )

            skipped += 1

            progress.next(
                display_name
            )

            continue

        # ----------------------------------------------------
        # Generate visual description
        # ----------------------------------------------------

        try:

            description = generate_description(
                node_type=node_type,
                category=category,
                subcategory=subcategory,
                entity=entity,
            )

            # ------------------------------------------------
            # Validate generated description
            # ------------------------------------------------

            if not description:

                raise RuntimeError(
                    "Generated description is empty."
                )

            description = description.strip()

            if len(description) < 15:

                raise RuntimeError(
                    "Generated description is too short: "
                    f"{description}"
                )

            # ------------------------------------------------
            # Store into JSON object
            # ------------------------------------------------

            node[
                "visual_description"
            ] = description

            generated += 1

            # ------------------------------------------------
            # Print result
            # ------------------------------------------------

            print(
                f"[OK] {display_name}"
            )

            print(
                f"     {description}"
            )

            # ------------------------------------------------
            # Autosave every 10 successful generations
            #
            # This protects the generated descriptions if
            # Ollama / Python / Windows crashes later.
            # ------------------------------------------------

            if generated % 10 == 0:

                save_json(data)

                print(
                    f"[SAVE] JSON checkpoint "
                    f"after {generated} generated nodes."
                )

        # ----------------------------------------------------
        # Generation failed
        # ----------------------------------------------------

        except Exception as exc:

            failed += 1

            warning(
                f"Failed: "
                f"{display_name}: "
                f"{exc}"
            )

        # ----------------------------------------------------
        # Progress
        # ----------------------------------------------------

        progress.next(
            display_name
        )

    # ========================================================
    # Final save
    #
    # Always save once more after the entire process.
    # ========================================================

    save_json(data)

    # ========================================================
    # Summary
    # ========================================================

    print()

    print(
        "=" * 70
    )

    success(
        "Visual description generation completed."
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

    print(
        f"Total     : {total}"
    )

    print(
        "=" * 70
    )


# ============================================================
# Standalone execution
# ============================================================

if __name__ == "__main__":

    from json_utils import (
        load_json,
        save_json,
    )

    print()
    print(
        "=" * 70
    )

    print(
        "WordZoo Visual Description Generator"
    )

    print(
        f"Model: {MODEL_NAME}"
    )

    print(
        f"Ollama: {OLLAMA_URL}"
    )

    print(
        "=" * 70
    )

    data = load_json()

    generate_all_visual_descriptions(
        data
    )

    save_json(
        data
    )

    success(
        "JSON updated with visual_description."
    )