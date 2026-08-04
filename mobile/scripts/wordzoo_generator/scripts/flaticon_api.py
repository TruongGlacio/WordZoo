import time
from pathlib import Path

import requests

from config import FLATICON_API_KEY

BASE_URL = "https://api.flaticon.com/v3"

_token = None
_expire = 0

def authenticate():

    global _token
    global _expire

    if _token and time.time() < _expire:
        return _token

    response = requests.post(
        f"{BASE_URL}/app/authentication",
        json={
            "apikey": FLATICON_API_KEY
        },
        timeout=30,
    )

    response.raise_for_status()

    body = response.json()

    _token = body["data"]["token"]

    _expire = time.time() + 23 * 3600

    return _token

def headers():

    return {

        "Authorization": f"Bearer {authenticate()}",
        "Accept": "application/json",

    }

def search_flaticon(

    keyword,
    limit=30,

):

    response = requests.get(

        f"{BASE_URL}/search/icons/priority",

        headers=headers(),

        params={

            "q": keyword,

            "limit": limit,

            "styleColor": "color",

            "styleShape": "fill",

        },

        timeout=30,

    )

    response.raise_for_status()

    items = response.json()["data"]

    if not items:
        return None

    #
    # chỉ lấy FREE
    #

    for item in items:

        #
        # API trả về field free
        #

        if item.get("free", False):

            return item

    return None

def download_flaticon(
    icon_id: int,
    output_file: Path,
):

    #
    # Ưu tiên 512px
    #

    for size in (512, 256):

        response = requests.get(

            f"{BASE_URL}/item/icon/download/{icon_id}",

            headers=headers(),

            params={

                "format": "png",
                "size": size,

            },

            timeout=60,

        )

        response.raise_for_status()

        #
        # Có thể API trả JSON hoặc trả file
        #

        content_type = response.headers.get(
            "Content-Type",
            ""
        ).lower()

        #
        # Trả trực tiếp file PNG
        #

        if "image/png" in content_type:

            output_file.parent.mkdir(
                parents=True,
                exist_ok=True,
            )

            with open(output_file, "wb") as f:
                f.write(response.content)

            return True

        #
        # Trả JSON chứa download url
        #

        if "application/json" in content_type:

            body = response.json()

            url = (
                body.get("data", {})
                    .get("url")
            )

            if not url:
                continue

            image = requests.get(
                url,
                timeout=60,
            )

            image.raise_for_status()

            if "image/png" not in image.headers.get(
                "Content-Type",
                ""
            ).lower():
                continue

            output_file.parent.mkdir(
                parents=True,
                exist_ok=True,
            )

            with open(output_file, "wb") as f:
                f.write(image.content)

            return True

    return False

def download_by_keyword(
    keyword,
    output_file,
):

    icon = search_flaticon(keyword)

    if icon is None:
        return False

    return download_flaticon(
        icon["id"],
        output_file,
    )

