from enum import Enum


class ImageProvider(Enum):
    WIKIMEDIA = "wikimedia"
    PEXELS = "pexels"
    PIXABAY = "pixabay"
    FLATICON = "flaticon"
    AI = "ai"


CATEGORY_PROVIDER = {

    # ===========================
    # Animals
    # ===========================

    "animals": ImageProvider.WIKIMEDIA,
    "wild_animals": ImageProvider.WIKIMEDIA,
    "farm_animals": ImageProvider.WIKIMEDIA,
    "pets": ImageProvider.WIKIMEDIA,
    "birds": ImageProvider.WIKIMEDIA,
    "fish": ImageProvider.WIKIMEDIA,
    "sea_animals": ImageProvider.WIKIMEDIA,
    "mammals": ImageProvider.WIKIMEDIA,
    "reptiles": ImageProvider.WIKIMEDIA,
    "amphibians": ImageProvider.WIKIMEDIA,
    "rodents": ImageProvider.WIKIMEDIA,
    "arachnids": ImageProvider.WIKIMEDIA,
    "dinosaurs": ImageProvider.WIKIMEDIA,
    "baby_animals": ImageProvider.WIKIMEDIA,
    "animal_homes": ImageProvider.WIKIMEDIA,
    "nocturnal_animals": ImageProvider.WIKIMEDIA,

    # ===========================
    # Plants
    # ===========================

    "flowers": ImageProvider.WIKIMEDIA,
    "trees": ImageProvider.WIKIMEDIA,
    "fruits": ImageProvider.WIKIMEDIA,
    "vegetables": ImageProvider.WIKIMEDIA,
    "herbs": ImageProvider.WIKIMEDIA,
    "fungi": ImageProvider.WIKIMEDIA,

    # ===========================
    # Nature
    # ===========================

    "minerals": ImageProvider.WIKIMEDIA,
    "rocks": ImageProvider.WIKIMEDIA,
    "weather": ImageProvider.WIKIMEDIA,
    "space": ImageProvider.WIKIMEDIA,
    "planets": ImageProvider.WIKIMEDIA,

    # ===========================
    # Objects
    # ===========================

    "vehicles": ImageProvider.WIKIMEDIA,
    "transportation": ImageProvider.WIKIMEDIA,
    "furniture": ImageProvider.WIKIMEDIA,
    "tools": ImageProvider.WIKIMEDIA,
    "electronics": ImageProvider.WIKIMEDIA,
    "buildings": ImageProvider.WIKIMEDIA,
    "foods": ImageProvider.WIKIMEDIA,

    # ===========================
    # Human
    # ===========================

    "jobs": ImageProvider.PEXELS,
    "occupations": ImageProvider.PEXELS,
    "human_relations": ImageProvider.PEXELS,
    "family": ImageProvider.PEXELS,

    # ===========================
    # Basics
    # ===========================

    "basics": ImageProvider.FLATICON,

    "numbers": ImageProvider.FLATICON,
    "numbers_digits": ImageProvider.FLATICON,

    "letters": ImageProvider.FLATICON,
    "alphabet": ImageProvider.FLATICON,

    "colors": ImageProvider.FLATICON,

    "shapes": ImageProvider.FLATICON,

    "directions": ImageProvider.FLATICON,

    "time": ImageProvider.FLATICON,

    "calendar": ImageProvider.FLATICON,

    "currency": ImageProvider.FLATICON,

    "symbols": ImageProvider.FLATICON,

    "punctuation": ImageProvider.FLATICON,

    # ===========================
    # Abstract
    # ===========================

    "emotions": ImageProvider.AI,
    "feelings": ImageProvider.AI,
}
def get_provider(category_id: str):

    return CATEGORY_PROVIDER.get(

        category_id,

        ImageProvider.WIKIMEDIA,

    )