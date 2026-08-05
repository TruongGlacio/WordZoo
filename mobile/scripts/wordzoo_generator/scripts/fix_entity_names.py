from json_utils import (
    load_json,
    save_json,
    iter_entities,
)

# ============================================================
# Category IDs
# ============================================================

ANIMAL_SUBCATEGORIES = {

    "wild_animals",
    "farm_animals",
    "pets",
    "mammals",
    "birds",
    "fish",
    "sea_animals",
    "insects",
    "reptiles",
    "amphibians",
    "arachnids",
    "rodents",
    "dinosaurs",
    "nocturnal_animals",
    "baby_animals",
    "animal_homes",

}

PLANT_SUBCATEGORIES = {

    "flowers",
    "trees",
    "fruits",
    "vegetables",
    "herbs",
    "fungi",
    "grains",

}


# ============================================================
# Fix one entity
# ============================================================

def fix_entity(subcategory, entity):

    sid = subcategory["id"]

    vi = entity["names"]["vi"].strip()

    # -------------------------
    # Animals
    # -------------------------

    if sid in ANIMAL_SUBCATEGORIES:

        if not vi.startswith("con "):
            entity["names"]["vi"] = f"con {vi}"

    # -------------------------
    # Plants
    # -------------------------

    elif sid in PLANT_SUBCATEGORIES:

        if not vi.startswith("cây "):
            entity["names"]["vi"] = f"cây {vi}"


# ============================================================
# Main
# ============================================================

def fix_all():

    data = load_json()

    count = 0

    for _, subcategory, entity in iter_entities(data):

        before = entity["names"]["vi"]

        fix_entity(
            subcategory,
            entity,
        )

        if before != entity["names"]["vi"]:
            count += 1

    save_json(data)

    print("--------------------------------")
    print(f"Updated : {count}")
    print("Done.")


if __name__ == "__main__":

    fix_all()