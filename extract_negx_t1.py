#!/usr/bin/env python3
from pathlib import Path
import cv2
import numpy as np

root = Path("/artifacts")
out = Path("/out")
out.mkdir(parents=True, exist_ok=True)

clips = [
    ("obj_t1_ep0_fail", root / "pilot_libero_object_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_x/task0001_ep0000_fail.mp4"),
    ("obj_t1_ep1_fail", root / "pilot_libero_object_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_x/task0001_ep0001_fail.mp4"),
    ("obj_t1_ep2_fail", root / "pilot_libero_object_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_x/task0001_ep0002_fail.mp4"),
    ("obj_t1_ep3_fail", root / "pilot_libero_object_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_x/task0001_ep0003_fail.mp4"),
    ("obj_t1_ep4_ok", root / "pilot_libero_object_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_objshift_10cm_neg_x/task0001_ep0004_success.mp4"),
    ("pair_t1_ep0_fail", root / "pilot_libero_pair_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_pairshift_10cm_neg_x/task0001_ep0000_fail.mp4"),
    ("pair_t1_ep1_fail", root / "pilot_libero_pair_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_pairshift_10cm_neg_x/task0001_ep0001_fail.mp4"),
    ("pair_t1_ep2_fail", root / "pilot_libero_pair_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_pairshift_10cm_neg_x/task0001_ep0002_fail.mp4"),
    ("pair_t1_ep3_ok", root / "pilot_libero_pair_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_pairshift_10cm_neg_x/task0001_ep0003_success.mp4"),
    ("pair_t1_ep4_fail", root / "pilot_libero_pair_shift_10cm_neg_x_3x5/episodes/pi05_libero_spatial_pairshift_10cm_neg_x/task0001_ep0004_fail.mp4"),
    ("base_t1_ep0_ok", root / "pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot/task0001_ep0000_success.mp4"),
    ("base_t1_ep2_ok", root / "pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot/task0001_ep0002_success.mp4"),
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
            im = np.zeros((256, 256, 3), dtype=np.uint8)
        frames.append(im)
    cap.release()
    return n, frames

for tag, path in clips:
    if not path.exists():
        print("MISSING", tag)
        continue
    n, frames = grab(path)
    h = min(im.shape[0] for im in frames)
    w = min(im.shape[1] for im in frames)
    frames = [im[:h, :w] for im in frames]
    cv2.imwrite(str(out / ("%s_f000.jpg" % tag)), frames[0])
    cv2.imwrite(str(out / ("%s_last.jpg" % tag)), frames[-1])
    cv2.imwrite(str(out / ("%s_sheet.jpg" % tag)), np.hstack(frames))
    print("ok", tag, "n=", n)

# same-init first-frame comparisons
pairs = [
    ("cmp_ep0_base_vs_obj", "base_t1_ep0_ok_f000.jpg", "obj_t1_ep0_fail_f000.jpg"),
    ("cmp_ep0_obj_vs_pair", "obj_t1_ep0_fail_f000.jpg", "pair_t1_ep0_fail_f000.jpg"),
    ("cmp_ep2_base_vs_obj", "base_t1_ep2_ok_f000.jpg", "obj_t1_ep2_fail_f000.jpg"),
    ("cmp_ep4_obj_ok_vs_pair_fail", "obj_t1_ep4_ok_f000.jpg", "pair_t1_ep4_fail_f000.jpg"),
]
for name, a, b in pairs:
    ia = cv2.imread(str(out / a))
    ib = cv2.imread(str(out / b))
    if ia is None or ib is None:
        print("skip", name)
        continue
    h = min(ia.shape[0], ib.shape[0])
    w = min(ia.shape[1], ib.shape[1])
    cv2.imwrite(str(out / ("%s.jpg" % name)), np.hstack([ia[:h, :w], ib[:h, :w]]))
print("done")
