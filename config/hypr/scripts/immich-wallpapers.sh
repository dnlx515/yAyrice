#!/usr/bin/env python3
import json
import os
import sys
import urllib.request
from pathlib import Path

API = os.environ.get("IMMICH_URL", "http://127.0.0.1:2283").rstrip("/")
KEY_FILE = Path(os.environ.get("IMMICH_KEY_FILE", Path.home() / ".config/immich/key"))
DEST = Path(os.environ.get("DEST", Path.home() / "Downloads/waypepah"))
ALBUM = sys.argv[1] if len(sys.argv) > 1 else ""
EXTS = {".jpg", ".jpeg", ".png", ".webp"}


def request(path, data=None):
    headers = {"x-api-key": KEY_FILE.read_text().strip(), "Accept": "application/json"}
    body = None
    if data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(API + path, data=body, headers=headers)
    return urllib.request.urlopen(req, timeout=60)


def api_json(path, data=None):
    with request(path, data) as resp:
        return json.load(resp)


def album_assets(name):
    for album in api_json("/api/albums"):
        if album.get("albumName", "").lower() == name.lower():
            return api_json(f"/api/albums/{album['id']}").get("assets", [])
    sys.exit(f"album not found: {name}")


def all_assets():
    page = 1
    while True:
        payload = {"page": page, "size": 500, "type": "IMAGE"}
        items = api_json("/api/search/metadata", payload).get("assets", {})
        yield from items.get("items", [])
        if not items.get("nextPage"):
            break
        page += 1


def main():
    if not KEY_FILE.is_file():
        sys.exit(f"missing api key: {KEY_FILE}")
    DEST.mkdir(parents=True, exist_ok=True)

    assets = album_assets(ALBUM) if ALBUM else all_assets()
    downloaded = skipped = failed = seen = 0
    for asset in assets:
        seen += 1
        ext = Path(asset.get("originalFileName") or "").suffix.lower()
        if ext not in EXTS:
            seen -= 1
            continue
        name = Path(asset.get("originalFileName") or asset["id"]).stem
        target = DEST / f"immich-{name}-{asset['id'][:8]}{ext}"
        if target.exists():
            skipped += 1
            continue
        try:
            with request(f"/api/assets/{asset['id']}/original") as resp, open(target, "wb") as out:
                out.write(resp.read())
            downloaded += 1
            print(f"[{seen}] {target.name}", flush=True)
        except Exception as exc:
            failed += 1
            target.unlink(missing_ok=True)
            print(f"[{seen}] failed {asset['id']}: {exc}", file=sys.stderr, flush=True)

    os.system(f"{Path.home()}/.config/hypr/scripts/wallpaper-select.sh --refresh")
    print(f"done: {downloaded} new, {skipped} already there, {failed} failed -> {DEST}")


if __name__ == "__main__":
    main()
