#!/usr/bin/env python3
"""Side-by-side and abs-diff of first frames to verify the bowl actually moved."""
from pathlib import Path
import cv2
import numpy as np

kf = Path("/keyframes")
out = Path("/out")
out.mkdir(parents=True, exist_ok=True)

pairs = [
    ("t1_ep0_0cm_vs_10cm", "t1_0cm_success_f000.jpg", "t1_10cm_fail_f000.jpg"),
    ("t0_15cm_fail_vs_success_init", "t0_15cm_fail_f000.jpg", "t0_15cm_success_f000.jpg"),
    ("t1_10cm_fail_start_vs_last", "t1_10cm_fail_f000.jpg", "t1_10cm_fail_last.jpg"),
    ("t1_10cm_success_start_vs_last", "t1_10cm_success_f000.jpg", "t1_10cm_success_last.jpg"),
    ("t0_15cm_fail_start_vs_last", "t0_15cm_fail_f000.jpg", "t0_15cm_fail_last.jpg"),
    ("t0_15cm_success_start_vs_last", "t0_15cm_success_f000.jpg", "t0_15cm_success_last.jpg"),
    ("t1_15cm_fail_start_vs_last", "t1_15cm_fail_f000.jpg", "t1_15cm_fail_last.jpg"),
]

for name, a, b in pairs:
    ia = cv2.imread(str(kf / a))
    ib = cv2.imread(str(kf / b))
    if ia is None or ib is None:
        print("missing", name, a, b)
        continue
    h = min(ia.shape[0], ib.shape[0])
    w = min(ia.shape[1], ib.shape[1])
    ia = ia[:h, :w]
    ib = ib[:h, :w]
    side = np.hstack([ia, ib])
    cv2.imwrite(str(out / ("%s_side.jpg" % name)), side)
    diff = cv2.absdiff(ia, ib)
    heat = cv2.applyColorMap(cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY), cv2.COLORMAP_JET)
    cv2.imwrite(str(out / ("%s_diff.jpg" % name)), heat)
    gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
    ys, xs = np.where(gray > 25)
    if len(xs):
        print(name, "diff_centroid", int(xs.mean()), int(ys.mean()), "n_pix", len(xs), "max", int(gray.max()))
    else:
        print(name, "no_diff")
print("done")
