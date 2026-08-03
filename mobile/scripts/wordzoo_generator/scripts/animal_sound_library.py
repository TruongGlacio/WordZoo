"""
Animal sound library for WordZoo.

Each animal defines:

- text:
    Text that Edge-TTS will pronounce.

- rate:
    Speech speed.

- pitch:
    Voice pitch.

- volume:
    Voice volume.

Only animals need entries here.

Other entities will simply return None.
"""

from dataclasses import dataclass


@dataclass(frozen=True)
class AnimalSound:

    text: str

    rate: str = "-20%"

    pitch: str = "-5Hz"

    volume: str = "+0%"


ANIMAL_SOUND_LIBRARY = {

    # ==========================================================
    # Pets
    # ==========================================================

    "dog": AnimalSound(
        text="Woof! Woof!",
        rate="-5%",
        pitch="-2Hz",
    ),

    "cat": AnimalSound(
        text="Meow~ Meow~",
        rate="+8%",
        pitch="+8Hz",
    ),

    "rabbit": AnimalSound(
        text="Squeak... Squeak...",
        rate="+12%",
        pitch="+12Hz",
    ),

    "hamster": AnimalSound(
        text="Squeak! Squeak!",
        rate="+15%",
        pitch="+15Hz",
    ),

    "mouse": AnimalSound(
        text="Squeak!",
        rate="+18%",
        pitch="+18Hz",
    ),

    "guinea_pig": AnimalSound(
        text="Wheek! Wheek!",
        rate="+10%",
        pitch="+10Hz",
    ),

    "goldfish": AnimalSound(
        text="Blub... Blub...",
        rate="-15%",
    ),

    "parrot": AnimalSound(
        text="Squawk! Squawk!",
        rate="+5%",
    ),

    "canary": AnimalSound(
        text="Tweet! Tweet!",
        rate="+18%",
        pitch="+14Hz",
    ),

    # ==========================================================
    # Farm Animals
    # ==========================================================

    "cow": AnimalSound(
        text="Mooooooo...",
        rate="-25%",
        pitch="-15Hz",
    ),

    "buffalo": AnimalSound(
        text="Moooo...",
        rate="-30%",
        pitch="-18Hz",
    ),

    "bull": AnimalSound(
        text="Moooo!",
        rate="-30%",
        pitch="-18Hz",
    ),

    "horse": AnimalSound(
        text="Neighhhhh!",
        rate="-10%",
    ),

    "donkey": AnimalSound(
        text="Hee Haw! Hee Haw!",
        rate="-8%",
    ),

    "pig": AnimalSound(
        text="Oink! Oink!",
        rate="+5%",
    ),

    "goat": AnimalSound(
        text="Baaa! Baaa!",
    ),

    "sheep": AnimalSound(
        text="Baaaaaa...",
        rate="-8%",
    ),

    "chicken": AnimalSound(
        text="Cluck! Cluck!",
    ),

    "rooster": AnimalSound(
        text="Cock-a-doodle-doooo!",
        rate="-10%",
    ),

    "duck": AnimalSound(
        text="Quack! Quack!",
    ),

    "goose": AnimalSound(
        text="Honk! Honk!",
        rate="-8%",
    ),

    "turkey": AnimalSound(
        text="Gobble Gobble!",
    ),

    "pigeon": AnimalSound(
        text="Coo... Coo...",
    ),

    # ==========================================================
    # Wild Animals
    # ==========================================================

    "lion": AnimalSound(
        text="Grrrrrrrr... Rooooooar!!",
        rate="-35%",
        pitch="-18Hz",
    ),

    "tiger": AnimalSound(
        text="Grrrrrr... Roar!!",
        rate="-32%",
        pitch="-15Hz",
    ),

    "leopard": AnimalSound(
        text="Grrrr...",
        rate="-25%",
        pitch="-10Hz",
    ),

    "cheetah": AnimalSound(
        text="Rrrr... Hiss!",
        rate="-15%",
    ),

    "wolf": AnimalSound(
        text="Awooooooooo...",
        rate="-25%",
    ),

    "fox": AnimalSound(
        text="Yip! Yip!",
        rate="+5%",
    ),

    "bear": AnimalSound(
        text="Grrrrrrrr!",
        rate="-35%",
        pitch="-20Hz",
    ),

    "panda": AnimalSound(
        text="Hmmmmm...",
        rate="-20%",
    ),

    "elephant": AnimalSound(
        text="Prrrrrrrrrrrrrr!",
        rate="-35%",
        pitch="-20Hz",
    ),

    "hippopotamus": AnimalSound(
        text="Huff! Huff!",
        rate="-20%",
    ),

    "rhinoceros": AnimalSound(
        text="Snort!!",
        rate="-25%",
    ),

    "giraffe": AnimalSound(
        text="Hmmmmmm...",
        rate="-20%",
    ),

    "zebra": AnimalSound(
        text="Neigh!",
        rate="-5%",
    ),

    "monkey": AnimalSound(
        text="Oo oo aa aa!",
        rate="+8%",
    ),

    "gorilla": AnimalSound(
        text="Hooo! Hooo!",
        rate="-15%",
        pitch="-10Hz",
    ),

    "orangutan": AnimalSound(
        text="Ooooooh!",
        rate="-10%",
    ),

    "kangaroo": AnimalSound(
        text="Chuff! Chuff!",
    ),

    "koala": AnimalSound(
        text="Aaaaah...",
        rate="-20%",
    ),

    "sloth": AnimalSound(
        text="Mmmmm...",
        rate="-40%",
    ),
# ==========================================================
# Birds
# ==========================================================

"eagle": AnimalSound(
    text="Screeeeeee!",
    rate="-15%",
    pitch="-5Hz",
),

"hawk": AnimalSound(
    text="Keeeeee!",
    rate="-15%",
),

"falcon": AnimalSound(
    text="Keeeeee!",
    rate="-10%",
),

"owl": AnimalSound(
    text="Hoo... Hoo...",
    rate="-20%",
),

"sparrow": AnimalSound(
    text="Chirp! Chirp! Chirp!",
    rate="+18%",
    pitch="+10Hz",
),

"swallow": AnimalSound(
    text="Tweet! Tweet!",
    rate="+20%",
),

"crow": AnimalSound(
    text="Caw! Caw!",
    rate="-5%",
),

"raven": AnimalSound(
    text="Craaaw!",
    rate="-15%",
),

"woodpecker": AnimalSound(
    text="Tok Tok Tok Tok!",
    rate="+20%",
),

"peacock": AnimalSound(
    text="Meeee-ow!",
    rate="-5%",
),

"flamingo": AnimalSound(
    text="Honk!",
),

"pelican": AnimalSound(
    text="Honk!",
),

"penguin": AnimalSound(
    text="Honk! Honk!",
),

"seagull": AnimalSound(
    text="Keeeee! Keeeee!",
    rate="+8%",
),

"swan": AnimalSound(
    text="Honk...",
    rate="-20%",
),

"ostrich": AnimalSound(
    text="Boom... Boom...",
    rate="-25%",
),

# ==========================================================
# Sea Animals
# ==========================================================

"dolphin": AnimalSound(
    text="Eeeeeee! Eeeeeee!",
    rate="+20%",
    pitch="+18Hz",
),

"whale": AnimalSound(
    text="Woooooooooooo...",
    rate="-45%",
    pitch="-20Hz",
),

"orca": AnimalSound(
    text="Eeee... Eeee...",
    rate="+5%",
),

"seal": AnimalSound(
    text="Arf! Arf!",
    rate="+5%",
),

"sea_lion": AnimalSound(
    text="Arf! Arf!",
),

"walrus": AnimalSound(
    text="Oooonk!",
    rate="-20%",
),

"otter": AnimalSound(
    text="Eeep! Eeep!",
    rate="+15%",
),

"shark": AnimalSound(
    text="Splash...",
    rate="-30%",
),

"octopus": AnimalSound(
    text="Blub... Blub...",
    rate="-30%",
),

"squid": AnimalSound(
    text="Splash...",
),

"jellyfish": AnimalSound(
    text="Blub...",
),

"starfish": AnimalSound(
    text="Blub...",
),

"crab": AnimalSound(
    text="Click! Click!",
    rate="+15%",
),

"lobster": AnimalSound(
    text="Click! Click!",
),

"shrimp": AnimalSound(
    text="Tick Tick!",
    rate="+20%",
),

"seahorse": AnimalSound(
    text="Blub...",
),

"fish": AnimalSound(
    text="Blub... Blub...",
),

# ==========================================================
# Reptiles
# ==========================================================

"snake": AnimalSound(
    text="Hissssssssss...",
    rate="-15%",
),

"cobra": AnimalSound(
    text="Hissssss!",
    rate="-20%",
),

"python": AnimalSound(
    text="Hissss...",
    rate="-25%",
),

"crocodile": AnimalSound(
    text="Grrrrrr!",
    rate="-30%",
    pitch="-15Hz",
),

"alligator": AnimalSound(
    text="Grrrrrr!",
    rate="-30%",
),

"turtle": AnimalSound(
    text="Hmmmmm...",
    rate="-40%",
),

"tortoise": AnimalSound(
    text="Hmmmmm...",
    rate="-45%",
),

"lizard": AnimalSound(
    text="Tsk... Tsk...",
    rate="+10%",
),

"gecko": AnimalSound(
    text="Click! Click!",
    rate="+20%",
),

"iguana": AnimalSound(
    text="Hssss...",
    rate="-10%",
),

"chameleon": AnimalSound(
    text="Tsk...",
    rate="+15%",
),

# ==========================================================
# Amphibians
# ==========================================================

"frog": AnimalSound(
    text="Ribbit! Ribbit!",
    rate="+8%",
),

"tree_frog": AnimalSound(
    text="Ribbit! Ribbit!",
    rate="+15%",
),

"bullfrog": AnimalSound(
    text="Crooooak!",
    rate="-25%",
),

"toad": AnimalSound(
    text="Croak!",
    rate="-15%",
),

"salamander": AnimalSound(
    text="Squeak...",
    rate="+12%",
),

"newt": AnimalSound(
    text="Squeak...",
    rate="+15%",
),

# ==========================================================
# Insects
# ==========================================================

"bee": AnimalSound(
    text="Bzzzzzzzz...",
    rate="+15%",
),

"wasp": AnimalSound(
    text="Bzzzz!",
    rate="+18%",
),

"hornet": AnimalSound(
    text="Bzzzz!",
    rate="+18%",
),

"mosquito": AnimalSound(
    text="Bzzzzzz...",
    rate="+22%",
    pitch="+15Hz",
),

"fly": AnimalSound(
    text="Bzz...",
    rate="+20%",
),

"dragonfly": AnimalSound(
    text="Bzzz...",
),

"butterfly": AnimalSound(
    text="Flutter...",
    rate="+20%",
),

"grasshopper": AnimalSound(
    text="Chirp! Chirp!",
    rate="+18%",
),

"cricket": AnimalSound(
    text="Cri Cri Cri...",
    rate="+25%",
),

"cicada": AnimalSound(
    text="Zeeeeeeeeeeee...",
    rate="+15%",
),

"ant": AnimalSound(
    text="Tick Tick...",
    rate="+20%",
),

"beetle": AnimalSound(
    text="Click Click...",
    rate="+10%",
),

"spider": AnimalSound(
    text="Tick...",
    rate="+15%",
),
}

# ==========================================================
# Alias
# ==========================================================

ANIMAL_ALIASES = {

    # ------------------------------------------------------
    # Elephant
    # ------------------------------------------------------

    "african_elephant": "elephant",
    "asian_elephant": "elephant",
    "baby_elephant": "elephant",

    # ------------------------------------------------------
    # Bear
    # ------------------------------------------------------

    "polar_bear": "bear",
    "brown_bear": "bear",
    "black_bear": "bear",
    "grizzly_bear": "bear",
    "panda_bear": "panda",

    # ------------------------------------------------------
    # Wolf
    # ------------------------------------------------------

    "gray_wolf": "wolf",
    "arctic_wolf": "wolf",

    # ------------------------------------------------------
    # Fox
    # ------------------------------------------------------

    "red_fox": "fox",
    "arctic_fox": "fox",

    # ------------------------------------------------------
    # Eagle
    # ------------------------------------------------------

    "golden_eagle": "eagle",
    "bald_eagle": "eagle",

    # ------------------------------------------------------
    # Owl
    # ------------------------------------------------------

    "snowy_owl": "owl",
    "barn_owl": "owl",

    # ------------------------------------------------------
    # Whale
    # ------------------------------------------------------

    "blue_whale": "whale",
    "humpback_whale": "whale",

    # ------------------------------------------------------
    # Dolphin
    # ------------------------------------------------------

    "bottlenose_dolphin": "dolphin",

    # ------------------------------------------------------
    # Snake
    # ------------------------------------------------------

    "king_cobra": "cobra",
    "anaconda": "python",

    # ------------------------------------------------------
    # Turtle
    # ------------------------------------------------------

    "sea_turtle": "turtle",
    # ==========================================================
    # Birds
    # ==========================================================

    "robin": "sparrow",
    "hummingbird": "sparrow",
    "stork": "flamingo",
    "macaw": "parrot",
    "cockatoo": "parrot",
    "parakeet": "parrot",
    "budgerigar": "parrot",
    "lovebird": "parrot",
    "finch": "canary",
    "cardinal": "sparrow",
    "bluebird": "sparrow",
    "blackbird": "crow",
    "magpie": "crow",
    "jay": "crow",
    "oriole": "canary",
    "lark": "sparrow",
    "nightingale": "canary",
    "wren": "sparrow",
    "warbler": "sparrow",
    "heron": "flamingo",
    "ibis": "flamingo",
    "egret": "flamingo",
    "crane": "stork",
    "vulture": "eagle",
    "condor": "eagle",
    "kite": "hawk",
    "buzzard": "hawk",
    "kite_bird": "hawk",
    "kingfisher": "sparrow",
    "hornbill": "parrot",
    "toucan": "parrot",

    # ==========================================================
    # Fish
    # ==========================================================

    "anchovy": "fish",
    "anglerfish": "fish",
    "bass": "fish",
    "betta": "fish",
    "carp": "fish",
    "catfish": "fish",
    "clownfish": "fish",
    "cod": "fish",
    "guppy": "fish",
    "koi": "fish",
    "mackerel": "fish",
    "marlin": "fish",
    "pufferfish": "fish",
    "salmon": "fish",
    "sardine": "fish",
    "swordfish": "fish",
    "tilapia": "fish",
    "trout": "fish",
    "tuna": "fish",
    "eel": "fish",

    # ==========================================================
    # Amphibians
    # ==========================================================

    "axolotl": "salamander",
    "caecilian": "salamander",
    "hellbender": "salamander",
    "mudpuppy": "salamander",
    "olm": "salamander",

    # ==========================================================
    # Reptiles
    # ==========================================================

    "anole": "lizard",
    "skink": "lizard",
    "komodo_dragon": "lizard",
    "gila_monster": "lizard",
    "tuatara": "lizard",
    "viper": "snake",
    "rattlesnake": "snake",
    "boa": "python",
    "water_snake": "snake",
    "sea_snake": "snake",
    "monitor_lizard": "lizard",
    "frilled_lizard": "lizard",
    "horned_lizard": "lizard",

    # ==========================================================
    # Sea Animals
    # ==========================================================

    "clam": "fish",
    "oyster": "fish",
    "sea_urchin": "fish",
    "stingray": "fish",
    "coral": "fish",

    # ==========================================================
    # Mammals
    # ==========================================================

    "armadillo": "bear",
    "badger": "bear",
    "bat": "owl",
    "beaver": "otter",
    "hedgehog": "mouse",
    "mole": "mouse",
    "platypus": "otter",
    "raccoon": "bear",
    "squirrel": "mouse",

    "camel": "horse",
    "deer": "horse",
    "boar": "pig",
    "llama": "horse",

    "chimpanzee": "gorilla",
    "baboon": "monkey",
    "mandrill": "monkey",
    "gibbon": "monkey",

    "hyena": "wolf",
    "jackal": "wolf",
    "coyote": "wolf",

    "moose": "cow",
    "elk": "deer",
    "reindeer": "deer",
    "antelope": "deer",
    "gazelle": "deer",
    "bison": "buffalo",

    "warthog": "pig",
    "tapir": "horse",
    "okapi": "giraffe",

    # ==========================================================
    # Rodents
    # ==========================================================

    "agouti": "mouse",
    "capybara": "guinea_pig",
    "chinchilla": "rabbit",
    "degu": "mouse",
    "dormouse": "mouse",
    "gerbil": "hamster",
    "lemming": "mouse",
    "rat": "mouse",
    "vole": "mouse",

    # ==========================================================
    # Nocturnal Animals
    # ==========================================================

    "aardvark": "pig",
    "aardwolf": "wolf",
    "bushbaby": "monkey",
    "civet": "cat",
    "genet": "cat",
    "jerboa": "mouse",
    "kinkajou": "monkey",
    "kiwi": "sparrow",
    "loris": "monkey",
    "nightjar": "owl",
    "opossum": "mouse",
    "ringtail": "cat",
    "striped_skunk": "fox",
    "tarsier": "monkey",

    # ==========================================================
    # Farm Animals
    # ==========================================================

    "hen": "chicken",
    "calf": "cow",
    "lamb": "sheep",

    # ==========================================================
    # Baby Animals
    # ==========================================================

    "kitten": "cat",
    "puppy": "dog",
    "piglet": "pig",
    "duckling": "duck",
    "gosling": "goose",
    "chick": "chicken",
    "cygnet": "swan",
    "foal": "horse",
    "kid": "goat",
    "lamb_baby": "sheep",
    "cub": "bear",
    "eaglet": "eagle",
    "owlet": "owl",
    "leveret": "rabbit",
    "joey": "kangaroo",
    "tadpole": "frog",
    "hatchling": "turtle",
    "nestling": "sparrow",
    # ==========================================================
    # Insects
    # ==========================================================

    "cockroach": "beetle",
    "firefly": "fly",
    "flea": "mosquito",
    "ladybug": "beetle",
    "leaf_insect": "grasshopper",
    "mantis": "grasshopper",
    "moth": "butterfly",
    "stick_insect": "grasshopper",
    "termite": "ant",

    # ==========================================================
    # Arachnids
    # ==========================================================

    "black_widow": "spider",
    "brown_recluse": "spider",
    "harvestman": "spider",
    "mite": "spider",
    "orb_weaver": "spider",
    "scorpion": "spider",
    "tarantula": "spider",
    "tick": "spider",
    # ==========================================================
    # Dinosaurs
    # ==========================================================

    "allosaurus": "tiger",
    "ankylosaurus": "rhinoceros",
    "argentinosaurus": "elephant",
    "brachiosaurus": "giraffe",
    "brontosaurus": "elephant",
    "carnotaurus": "tiger",
    "compsognathus": "lizard",
    "dilophosaurus": "lizard",
    "diplodocus": "giraffe",
    "gallimimus": "ostrich",
    "iguanodon": "iguana",
    "oviraptor": "eagle",
    "pachycephalosaurus": "goat",
    "parasaurolophus": "elephant",
    "spinosaurus": "crocodile",
    "stegosaurus": "rhinoceros",
    "therizinosaurus": "bear",
    "triceratops": "rhinoceros",
    "tyrannosaurus_rex": "tiger",
    "velociraptor": "eagle",

    # ==========================================================
    # Wild Animals
    # ==========================================================

    "jaguar": "leopard",
    "cougar": "lion",
    "puma": "lion",
    "lynx": "cat",
    "bobcat": "cat",

    "meerkat": "mouse",
    "weasel": "mouse",
    "ferret": "cat",
    "wolverine": "bear",

    "yak": "cow",
    "musk_ox": "buffalo",

    "impala": "deer",
    "springbok": "deer",

    "emu": "ostrich",
    "cassowary": "ostrich",

    "manatee": "seal",
    "dugong": "seal",

    "narwhal": "whale",
    "beluga": "whale",

    "manta_ray": "fish",

    "nautilus": "octopus",
    "cuttlefish": "squid",

    "hermit_crab": "crab",
    "emperor_scorpion": "spider",
    "pseudoscorpion": "spider",
    "whip_scorpion": "spider",
    "fawn": "horse",
    "alpaca": "horse",
    "honey_badger": "bear",
    "slow_loris": "monkey",
    "tenrec": "mouse",
    "chipmunk": "mouse",
    "flying_squirrel": "mouse",
    "ground_squirrel": "mouse",
    "marmot": "mouse",
    "muskrat": "mouse",
    "nutria": "otter",
    "porcupine": "mouse",
    "pangolin": "bear",
}
# ==========================================================
# Normalize
# ==========================================================

def normalize_entity_id(entity_id: str) -> str:

    if entity_id is None:
        return ""

    entity_id = entity_id.lower().strip()

    entity_id = entity_id.replace("-", "_")

    entity_id = entity_id.replace(" ", "_")

    return entity_id

# ==========================================================
# Guess Base Animal
# ==========================================================

def guess_base_animal(entity_id: str):

    parts = entity_id.split("_")

    if len(parts) <= 1:
        return None

    #
    # white_tiger
    # -> tiger
    #

    last = parts[-1]

    if last in ANIMAL_SOUND_LIBRARY:
        return last

    #
    # african_elephant
    # -> elephant
    #

    for part in reversed(parts):

        if part in ANIMAL_SOUND_LIBRARY:
            return part

    return None

# ==========================================================
# Has Animal Sound
# ==========================================================

def has_animal_sound(entity_id: str) -> bool:

    return get_animal_sound(entity_id) is not None


# ==========================================================
# Lookup
# ==========================================================

def get_animal_sound(entity_id: str):

    entity_id = normalize_entity_id(entity_id)
    #
    # exact
    #
    if entity_id in ANIMAL_SOUND_LIBRARY:

        return ANIMAL_SOUND_LIBRARY[entity_id]

    #
    # alias
    #

    if entity_id in ANIMAL_ALIASES:

        alias = ANIMAL_ALIASES[entity_id]

        if alias in ANIMAL_SOUND_LIBRARY:

            return ANIMAL_SOUND_LIBRARY[alias]

    #
    # smart guess
    #

    guess = guess_base_animal(entity_id)

    if guess:

        return ANIMAL_SOUND_LIBRARY[guess]

    return None