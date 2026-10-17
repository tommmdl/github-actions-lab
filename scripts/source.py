import json
from pathlib import Path
import re

source = json.loads((Path(__file__).resolve().parent.parent / "source.json").read_text())
if source["repository"] != "tommmdl/docker-lab":
    raise SystemExit("Unexpected source repository")
if not re.fullmatch(r"[0-9a-f]{40}", source["revision"]):
    raise SystemExit("Source must be pinned to a full commit SHA")
print("revision=" + source["revision"])
