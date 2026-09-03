#!/usr/bin/env bash
set -euo pipefail
echo "ffmpeg=$(command -v ffmpeg || true)"
echo "python3=$(command -v python3 || true)"
python3 - <<'PY'
mods = []
for name in ("cv2", "imageio", "imageio_ffmpeg", "av"):
    try:
        __import__(name)
        mods.append(name)
    except Exception as e:
        mods.append(f"{name}:FAIL")
print("python_mods", mods)
PY
docker run --rm --entrypoint python ghcr.io/allenai/vla-evaluation-harness/libero:latest -c "import cv2; print('docker_cv2', cv2.__version__)"
