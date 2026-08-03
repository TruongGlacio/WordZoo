"""
Validate animal sound library.

Only validate entities inside category: animals
"""

from animal_sound_library import (
    get_animal_sound,
)

from utils import (
    success,
    warning,
)


# ============================================================
# Validate
# ============================================================

def validate_animal_sound(data):

    total = 0

    ok = 0

    missing = []

    for category in data["categories"]:

        # -----------------------------------------
        # Only validate animals category
        # -----------------------------------------

        if category["id"] != "animals":
            continue

        for subcategory in category["subcategories"]:
            if subcategory["id"] == "animal_homes":
                continue
            for entity in subcategory["entities"]:

                total += 1

                entity_id = entity["id"]

                sound = get_animal_sound(entity_id)

                if sound is None:

                    missing.append({
                        "subcategory": subcategory["id"],
                        "entity": entity_id,
                    })

                else:

                    ok += 1

    print()

    success("Animal Sound Validation")

    print(f"Animal entities : {total}")
    print(f"Supported       : {ok}")
    print(f"Missing         : {len(missing)}")

    if missing:

        print()

        warning("Missing animal sounds")

        print("-" * 60)

        for item in sorted(
                missing,
                key=lambda x: (x["subcategory"], x["entity"])
        ):

            print(
                f"[{item['subcategory']}] {item['entity']}"
            )

        print("-" * 60)

    else:

        print()

        success("All animal sounds are available.")

    return missing


# ============================================================
# Debug
# ============================================================

if __name__ == "__main__":

    from json_utils import load_json

    data = load_json()

    validate_animal_sound(data)