#!/usr/bin/env python3
from pathlib import Path
import cv2

root = Path("/artifacts")
out = Path("/out")
out.mkdir(parents=True, exist_ok=True)

clips = {
    "t1_0cm_ep2": root / "pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot/task0001_ep0002_success.mp4",
    "t1_15cm_ep0_ok": root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0000_success.mp4",
    "t1_15cm_ep1_ok": root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0001_success.mp4",
    "t1_15cm_ep2_fail": root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0002_fail.mp4",
    "t1_15cm_ep3_fail": root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0003_fail.mp4",
    "t1_15cm_ep4_fail": root / "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0004_fail.mp4",
    "t1_10cm_ep0_fail": root / "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0000_fail.mp4",
    "t1_10cm_ep1_ok": root / "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0001_success.mp4",
}

for tag, path in clips.items():
    if not path.exists():
        print("MISSING", tag, path)
        continue
    cap = cv2.VideoCapture(str(path))
    ok, frame = cap.read()
    n = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) or 0)
    cap.release()
    if not ok:
        print("EMPTY", tag)
        continue
    h, w = frame.shape[:2]
    cv2.imwrite(str(out / ("%s_f000.jpg" % tag)), frame)
    print("saved", tag, "n=", n, "wh=", w, h)
print("done")
