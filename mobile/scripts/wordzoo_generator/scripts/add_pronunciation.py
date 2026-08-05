import eng_to_ipa as ipa
import pyphen

from pypinyin import lazy_pinyin, Style

from json_utils import iter_all_nodes
from utils import info, success


# ------------------------------------------------------
# English
# ------------------------------------------------------

_en_dic = pyphen.Pyphen(lang="en_US")


def build_english_pronunciation(text: str):

    text = text.strip()

    ipa_text = ipa.convert(text)

    ipa_text = ipa_text.replace("*", "").strip()

    syllable = _en_dic.inserted(text)

    syllable = syllable.replace("-", "·")

    return {
        "ipa": ipa_text,
        "syllable": syllable,
    }


# ------------------------------------------------------
# Chinese
# ------------------------------------------------------

def build_chinese_pronunciation(text: str):

    text = text.strip()

    if not text:
        return {
            "pinyin": "",
            "syllable": "",
        }

    pinyin_list = lazy_pinyin(
        text,
        style=Style.TONE,
    )

    pinyin = " ".join(pinyin_list)

    syllable = "·".join(
        [
            x.replace("ü", "v")
            for x in lazy_pinyin(
                text,
                style=Style.NORMAL,
            )
        ]
    )

    return {
        "pinyin": pinyin,
        "syllable": syllable,
    }


# ------------------------------------------------------
# Main
# ------------------------------------------------------

def add_pronunciation(data):

    info("Adding pronunciation...")

    count = 0

    for (
        node_type,
        category,
        subcategory,
        entity,
    ) in iter_all_nodes(data):

        if node_type == "category":
            node = category

        elif node_type == "subcategory":
            node = subcategory

        else:
            node = entity

        node["pronunciation"] = {

            "en": build_english_pronunciation(

                node["names"]["en"]

            ),

            "zh": build_chinese_pronunciation(

                node["names"]["zh"]

            )

        }

        count += 1

    success(
        f"Added pronunciation for {count} nodes."
    )