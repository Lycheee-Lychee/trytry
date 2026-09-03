#!/usr/bin/env python3
"""Contact sheets for existing failure mp4s: first / 25% / 50% / 75% / last."""
from pathlib import Path
import cv2
import numpy as np

root = Path("/artifacts")
out = Path("/out")
out.mkdir(parents=True, exist_ok=True)

fails = [
    "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0000_fail.mp4",
    "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0002_fail.mp4",
    "pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0004_fail.mp4",
    "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0000_ep0000_fail.mp4",
    "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0002_fail.mp4",
    "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0003_fail.mp4",
    "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0001_ep0004_fail.mp4",
    "pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0002_ep0003_fail.mp4",
    "pilot_libero_object_shift_15cm_max440_3x5/episodes/pi05_libero_spatial_objshift_15cm_max440/task0001_ep0003_fail.mp4",
    "pilot_libero_object_shift_15cm_max440_3x5/episodes/pi05_libero_spatial_objshift_15cm_max440/task0001_ep0004_fail.mp4",
    "pilot_libero_object_shift_15cm_max440_3x5/episodes/pi05_libero_spatial_objshift_15cm_max440/task0002_ep0002_fail.mp4",
    "pilot_libero_object_shift_15cm_max440_3x5/episodes/pi05_libero_spatial_objshift_15cm_max440/task0002_ep0003_fail.mp4",
    "pilot_libero_camera_yaw45_3x5/episodes/pi05_libero_spatial_camera_yaw45/task0001_ep0002_fail.mp4",
    "pilot_libero_camera_yaw45_3x5/episodes/pi05_libero_spatial_camera_yaw45/task0001_ep0004_fail.mp4",
    "pilot_libero_object_shift_10cm_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_x/task0000_ep0000_fail.mp4",
    "pilot_libero_object_shift_10cm_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_x/task0000_ep0001_fail.mp4",
    "pilot_libero_object_shift_10cm_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_x/task0002_ep0002_fail.mp4",
    "pilot_libero_object_shift_10cm_neg_y_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_y/task0002_ep0003_fail.mp4",
]

fracs = (0.0, 0.25, 0.5, 0.75, 1.0)

def grab(path):
    cap = cv2.VideoCapture(str(path))
    n = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) or 0)
    frames = []
    for f in fracs:
        idx = 0 if n <= 1 else min(n - 1, int(round(f * (n - 1))))
        cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
        ok, im = cap.read()
        if not ok:
            cap.set(cv2.CAP_PROP_POS_FRAMES, max(0, idx - 1))
            ok, im = cap.read()
        if not ok:
            im = np.zeros((256, 256, 3), dtype=np.uint8)
        frames.append(im)
    cap.release()
    return n, frames

for rel in fails:
    path = root / rel
    tag = rel.split("/")[-1].replace(".mp4", "")
    cond = rel.split("/")[0].replace("pilot_libero_", "")
    name = "%s__%s" % (cond, tag)
    if not path.exists():
        print("MISSING", rel)
        continue
    n, frames = grab(path)
    h = min(im.shape[0] for im in frames)
    w = min(im.shape[1] for im in frames)
    frames = [im[:h, :w] for im in frames]
    sheet = np.hstack(frames)
    cv2.imwrite(str(out / ("%s_sheet.jpg" % name)), sheet)
    cv2.imwrite(str(out / ("%s_last.jpg" % name)), frames[-1])
    print("ok", name, "n=", n)
print("done")
