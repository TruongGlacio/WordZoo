import json
import re
import subprocess
import shutil
import time
from pathlib import Path

import requests


# ============================================================
# CONFIG
# ============================================================

INPUT_JSON = "data_version1_final.json"
OUTPUT_JSON = "data_version1_final.json"

OLLAMA_URL = "http://127.0.0.1:11434/api/generate"

TRANSLATE_MODEL = "translategemma:12b"

BATCH_SIZE = 10

MAX_RETRIES = 3

REQUEST_TIMEOUT = 300

OLLAMA_DELAY = 0.2


# ============================================================
# Languages
# ============================================================

ALL_LANGUAGES = [
    "vi",
    "en",
    "zh",
    "es",
    "fr",
    "ja",
    "ko",
]


TRANSLATE_LANGUAGES = [
    "es",
    "fr",
    "ja",
    "ko",
]


PRONUNCIATION_LANGUAGES = [
    "vi",
    "en",
    "zh",
    "es",
    "fr",
    "ja",
    "ko",
]


# ============================================================
# eSpeak language
# ============================================================

ESPEAK_LANGUAGES = {
    "vi": "vi",
    "en": "en",
    "zh": "zh",
    "es": "es",
    "fr": "fr",
    "ja": "ja",
    "ko": "ko",
}


# ============================================================
# Find eSpeak
# ============================================================

def find_espeak():

    candidates = [

        "espeak-ng",

        "espeak-ng.exe",

        r"C:\Program Files\eSpeak NG\espeak-ng.exe",

        r"C:\Program Files (x86)\eSpeak NG\espeak-ng.exe",

    ]

    for candidate in candidates:

        found = shutil.which(candidate)

        if found:
            return found

        if Path(candidate).exists():
            return candidate

    return None


ESPEAK_PATH = find_espeak()


# ============================================================
# Chunk
# ============================================================

def chunks(items, size):

    for i in range(
        0,
        len(items),
        size
    ):

        yield items[
            i:i + size
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

    temp = OUTPUT_JSON + ".tmp"

    with open(
        temp,
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2
        )

    Path(temp).replace(
        OUTPUT_JSON
    )


# ============================================================
# Collect entities
# ============================================================

def collect_entities(data):

    entities = []

    for category in data.get(
        "categories",
        []
    ):

        for subcategory in category.get(
            "subcategories",
            []
        ):

            for entity in subcategory.get(
                "entities",
                []
            ):

                entities.append(
                    entity
                )

    return entities


# ============================================================
# Check names
# ============================================================

def has_name(
        entity,
        language
):

    names = entity.get(
        "names",
        {}
    )

    value = names.get(
        language
    )

    return (
        isinstance(value, str)
        and
        bool(value.strip())
    )


def missing_names(
        entity
):

    return [

        language

        for language in TRANSLATE_LANGUAGES

        if not has_name(
            entity,
            language
        )

    ]


# ============================================================
# Check pronunciation
# ============================================================

def has_pronunciation(
        entity,
        language
):

    pronunciation = entity.get(
        "pronunciation",
        {}
    )

    item = pronunciation.get(
        language
    )

    if not isinstance(
        item,
        dict
    ):

        return False

    ipa = item.get(
        "ipa"
    )

    syllable = item.get(
        "syllable"
    )

    return (
        isinstance(ipa, str)
        and bool(ipa.strip())
        and
        isinstance(syllable, str)
        and bool(syllable.strip())
    )


def missing_pronunciation(
        entity
):

    return [

        language

        for language in PRONUNCIATION_LANGUAGES

        if not has_pronunciation(
            entity,
            language
        )

    ]


# ============================================================
# eSpeak IPA
# ============================================================

def normalize_ipa(
        value
):

    if not value:
        return ""

    value = value.strip()

    value = value.strip(
        "/[]"
    )

    value = re.sub(
        r"\s+",
        " ",
        value
    )

    return value.strip()


def generate_ipa(
        text,
        language
):

    if not ESPEAK_PATH:

        raise RuntimeError(
            "eSpeak NG not found"
        )

    voice = ESPEAK_LANGUAGES.get(
        language
    )

    if not voice:
        return None

    command = [

        ESPEAK_PATH,

        "-q",

        "--ipa=3",

        "-v",
        voice,

        text,

    ]

    try:

        result = subprocess.run(

            command,

            stdout=subprocess.PIPE,

            stderr=subprocess.PIPE,

            text=True,

            encoding="utf-8",

            errors="replace",

            timeout=30,

        )

    except Exception as e:

        print(
            f"    ✗ eSpeak {language}: {e}"
        )

        return None

    if result.returncode != 0:

        return None

    return normalize_ipa(
        result.stdout
    )


# ============================================================
# Syllable
# ============================================================

def generate_syllable(
        text,
        language
):

    """
    eSpeak IPA is reliable for pronunciation.

    Keep syllable as the source word for now.
    """

    return text.strip()


# ============================================================
# Generate pronunciation
# ============================================================

def generate_pronunciation(
        text,
        language
):

    ipa = generate_ipa(
        text,
        language
    )

    if not ipa:
        return None

    return {

        "ipa": ipa,

        "syllable": generate_syllable(
            text,
            language
        ),

    }


# ============================================================
# Translation prompt
# ============================================================

def build_translation_prompt(
        batch
):

    inputs = []

    for entity in batch:

        names = entity.get(
            "names",
            {}
        )

        missing = missing_names(
            entity
        )

        inputs.append({

            "id": entity.get(
                "id"
            ),

            "vi": names.get(
                "vi",
                ""
            ),

            "en": names.get(
                "en",
                ""
            ),

            "zh": names.get(
                "zh",
                ""
            ),

            "missing": missing,

        })

    return f"""
Translate missing WordZoo names.

Return ONLY valid JSON.
No markdown.
No explanation.

For each item:
- Keep id unchanged.
- Generate ONLY languages in "missing".
- Do NOT change vi.
- Do NOT change en.
- Do NOT change zh.
- Use common natural vocabulary.
- Spanish = es
- French = fr
- Japanese = ja
- Korean = ko

Format:

[
  {{
    "id": "lion",
    "names": {{
      "es": "León",
      "fr": "Lion",
      "ja": "ライオン",
      "ko": "사자"
    }}
  }}
]

INPUT:

{json.dumps(
    inputs,
    ensure_ascii=False,
    indent=2
)}
"""


# ============================================================
# TranslateGemma
# ============================================================

def call_translategemma(
        batch
):

    prompt = build_translation_prompt(
        batch
    )

    payload = {

        "model": TRANSLATE_MODEL,

        "prompt": prompt,

        "stream": False,

        "options": {

            "temperature": 0,

        },

    }

    for attempt in range(
        1,
        MAX_RETRIES + 1
    ):

        try:

            response = requests.post(

                OLLAMA_URL,

                json=payload,

                timeout=REQUEST_TIMEOUT

            )

            response.raise_for_status()

            raw = response.json().get(
                "response",
                ""
            ).strip()

            # Remove markdown fences
            raw = re.sub(
                r"^```json\s*",
                "",
                raw,
                flags=re.IGNORECASE
            )

            raw = re.sub(
                r"\s*```$",
                "",
                raw
            )

            result = json.loads(
                raw
            )

            if not isinstance(
                result,
                list
            ):

                raise ValueError(
                    "Response is not JSON array"
                )

            return result

        except Exception as e:

            print(
                f"    ✗ Attempt "
                f"{attempt}/{MAX_RETRIES}: "
                f"{e}"
            )

            if attempt < MAX_RETRIES:

                time.sleep(
                    attempt * 2
                )

    return []


# ============================================================
# Merge names
# ============================================================

def merge_names(
        batch,
        results
):

    entity_map = {

        entity["id"]: entity

        for entity in batch

    }

    merged = 0

    failed = 0

    for result in results:

        if not isinstance(
            result,
            dict
        ):
            continue

        entity_id = result.get(
            "id"
        )

        entity = entity_map.get(
            entity_id
        )

        if not entity:
            failed += 1
            continue

        returned_names = result.get(
            "names",
            {}
        )

        if not isinstance(
            returned_names,
            dict
        ):
            continue

        names = entity.setdefault(
            "names",
            {}
        )

        for language in TRANSLATE_LANGUAGES:

            # NEVER overwrite
            if has_name(
                entity,
                language
            ):
                continue

            value = returned_names.get(
                language
            )

            if not isinstance(
                value,
                str
            ):
                continue

            value = value.strip()

            if not value:
                continue

            names[language] = value

            merged += 1

    return merged, failed


# ============================================================
# Translation pipeline
# ============================================================

def process_translation(
        data
):

    entities = collect_entities(
        data
    )

    pending = [

        entity

        for entity in entities

        if missing_names(entity)

    ]

    print()
    print("=" * 70)
    print("TRANSLATE NAMES")
    print("=" * 70)

    print(
        f"Entities needing translation: "
        f"{len(pending):,}"
    )

    if not pending:

        print(
            "✓ All names already exist"
        )

        return

    batches = list(
        chunks(
            pending,
            BATCH_SIZE
        )
    )

    for index, batch in enumerate(
        batches,
        start=1
    ):

        start = (
            (index - 1)
            * BATCH_SIZE
            + 1
        )

        end = (
            start
            + len(batch)
            - 1
        )

        print()
        print(
            f"BATCH {start}-{end}"
        )

        print(
            "  "
            +
            ", ".join(
                entity["id"]
                for entity in batch
            )
        )

        print(
            "  → TranslateGemma 12B..."
        )

        results = call_translategemma(
            batch
        )

        print(
            f"  ✓ returned "
            f"{len(results)}"
        )

        merged, failed = merge_names(
            batch,
            results
        )

        print(
            f"  ✓ names added: "
            f"{merged}"
        )

        if failed:

            print(
                f"  ⚠ failed: "
                f"{failed}"
            )

        save_json(
            data
        )

        time.sleep(
            OLLAMA_DELAY
        )


# ============================================================
# Pronunciation pipeline
# ============================================================

def process_pronunciation(
        data
):

    entities = collect_entities(
        data
    )

    print()
    print("=" * 70)
    print("PRONUNCIATION - eSpeak NG")
    print("=" * 70)

    total_added = 0

    total_skipped = 0

    total_failed = 0

    for language in PRONUNCIATION_LANGUAGES:

        pending = [

            entity

            for entity in entities

            if (
                not has_pronunciation(
                    entity,
                    language
                )
                and
                has_name(
                    entity,
                    language
                )
            )

        ]

        print()
        print(
            f"{language}: "
            f"{len(pending):,} missing"
        )

        if not pending:

            print(
                f"  ✓ Nothing to do"
            )

            continue

        for index, entity in enumerate(
            pending,
            start=1
        ):

            text = entity[
                "names"
            ][
                language
            ]

            pronunciation = (
                generate_pronunciation(
                    text,
                    language
                )
            )

            if pronunciation:

                entity.setdefault(
                    "pronunciation",
                    {}
                )[language] = pronunciation

                total_added += 1

            else:

                total_failed += 1

                print(
                    f"  ✗ "
                    f"{entity['id']} "
                    f"({language})"
                )

            if index % 100 == 0:

                print(
                    f"  Progress: "
                    f"{index:,}/"
                    f"{len(pending):,}"
                )

        # Save after every language
        save_json(
            data
        )

    # Count existing pronunciation
    for entity in entities:

        for language in PRONUNCIATION_LANGUAGES:

            if has_pronunciation(
                entity,
                language
            ):

                total_skipped += 1

    print()
    print(
        f"✓ pronunciation added: "
        f"{total_added:,}"
    )

    print(
        f"✓ existing pronunciation kept: "
        f"{total_skipped:,}"
    )

    print(
        f"✗ pronunciation failed: "
        f"{total_failed:,}"
    )


# ============================================================
# Main
# ============================================================

def main():

    global ESPEAK_PATH

    print()
    print("=" * 70)
    print("WORDZOO TRANSLATEGEMMA + ESPEAK NG")
    print("=" * 70)

    # --------------------------------------------------------
    # Check eSpeak
    # --------------------------------------------------------

    ESPEAK_PATH = find_espeak()

    if not ESPEAK_PATH:

        print()
        print(
            "ERROR: eSpeak NG was not found."
        )

        print(
            "Install eSpeak NG first."
        )

        return

    print(
        f"eSpeak NG: "
        f"{ESPEAK_PATH}"
    )

    # --------------------------------------------------------
    # Load
    # --------------------------------------------------------

    print(
        f"Input: "
        f"{INPUT_JSON}"
    )

    data = load_json()

    entities = collect_entities(
        data
    )

    print(
        f"Entities: "
        f"{len(entities):,}"
    )

    # --------------------------------------------------------
    # Names
    # --------------------------------------------------------

    process_translation(
        data
    )

    # --------------------------------------------------------
    # Pronunciation
    # --------------------------------------------------------

    process_pronunciation(
        data
    )

    # --------------------------------------------------------
    # Final save
    # --------------------------------------------------------

    save_json(
        data
    )

    print()
    print("=" * 70)
    print("COMPLETED")
    print("=" * 70)

    print(
        f"Output: "
        f"{OUTPUT_JSON}"
    )


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":

    main()