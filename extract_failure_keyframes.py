#!/usr/bin/env python3
from pathlib import Path
import cv2

root = Path("/artifacts")
out = Path("/out")
out.mkdir(parents=True, exist_ok=True)

clips = [
    ("t1_0cm_success", root / "pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot/task0001_ep0000_success.mp4"),
    ("t1_10cm_fail", root / "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0000_fail.mp4"),
    ("t1_10cm_success", root / "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0001_success.mp4"),
    ("t0_15cm_fail", root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0000_ep0000_fail.mp4"),
    ("t0_15cm_success", root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0000_ep0001_success.mp4"),
    ("t1_15cm_fail", root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0002_fail.mp4"),
]

wanted = {0, 20, 60, 120, 180}

for tag, path in clips:
    if not path.exists():
        print("MISSING", tag, path)
        continue
    cap = cv2.VideoCapture(str(path))
    n = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) or 0)
    print("OPEN", tag, "n=", n, path)
    saved = []
    idx = 0
    last = None
    while True:
        ok, frame = cap.read()
        if not ok:
            break
        if idx in wanted:
            cv2.imwrite(str(out / ("%s_f%03d.jpg" % (tag, idx))), frame)
            saved.append(idx)
        last = frame
        idx += 1
    if last is not None:
        cv2.imwrite(str(out / ("%s_last.jpg" % tag)), last)
    cap.release()
    print("  saved", saved, "last_idx", idx - 1)
print("done")
