# Spatial Robustness of π0.5 on LIBERO

Case study of `lerobot/pi05_libero_finetuned` on LIBERO Spatial. The robot is
a Franka Emika Panda in MuJoCo (robosuite + LIBERO).

## Locked question (2026-09-03)

**Working title:** Characterizing Spatial Robustness Degradation of a LIBERO-finetuned π0.5 Policy

Do not use “boundary” in the title until a sharper threshold exists. The
+y curve is a noisy **degradation trend**, not monotonic at n=5
(10 cm 80% vs 12.5 cm 87%).

**Main RQ:** How does spatial distribution shift affect this VLA, and which
failure mechanisms show up once success drops — visibility, relational
grounding, or execution?

**Design:** LIBERO is the main study (~70–80%). RoboTwin is a later
validation (~20–30%): same *kind* of object-pose shift, 5–10 tasks, not a
second leaderboard. RoboDojo is out (horizon/memory/precision are confounded).

| | in | out |
|---|---|---|
| Policy | LIBERO-finetuned π0.5 | general π0.5 as the LIBERO subject |
| Main env | LIBERO Spatial tasks 0–2 | full 10-task / 50-ep leaderboard |
| Validation | RoboTwin object-pose shift, after LIBERO mechanisms | RoboDojo |
| Controls | camera yaw 45° (negative control vs object shift) | lighting, appearance, language rewrite |
| Intervention | only after failure modes are labeled | max_steps=440 already ruled out |

**RQs**

1. **Characterization** — How does success fall with displacement magnitude?
2. **Direction** — Is robustness isotropic? (+x/−x/+y/−y; tasks break differently)
3. **Mechanism** — Visibility vs relational grounding vs reach/grasp/place?
4. **Transfer (later)** — Does the pattern show up on RoboTwin?

**Week 2 order**

1. ~~Label existing failures~~ (provisional table below).
2. ~~Pair shift at +y 10 cm~~ → **15/15** vs object-only 12/15 (task 1 5/5 vs 2/5).
3. ~~−x 10 cm and +y 7.5 / 12.5 cm~~ (tables below). Direction is **not**
   isotropic: −x 10 cm is the worst 10 cm axis (10/15, task 1 = 1/5).

One-line claim already allowed: out-of-FOV is not sufficient for failure;
success episodes can be cropped too.

## Current results

### LIBERO-Spatial pilot

- Protocol: first 3 official tasks × 5 episodes, seed 7
- Result: 15/15 successful episodes
- Mean trajectory lengths: 77.6, 108.0, and 95.6 steps
- [Aggregate JSON](artifacts/pilot_libero_spatial_3x5/pi05_libero_spatial_pilot_aggregate.json)
- [All Spatial videos](artifacts/pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot)
- [Representative video](artifacts/pilot_libero_spatial_3x5/episodes/pi05_libero_spatial_pilot/task0000_ep0000_success.mp4)

### LIBERO-10 long-horizon pilot

- Protocol: first 3 official tasks × 5 episodes, seed 7
- Result: 15/15 successful episodes
- Mean trajectory lengths: 254.0, 242.0, and 244.2 steps
- [Aggregate JSON](artifacts/pilot_libero10_3x5/pi05_libero10_pilot_aggregate.json)
- [All LIBERO-10 videos](artifacts/pilot_libero10_3x5/episodes/pi05_libero10_pilot)
- [Representative video](artifacts/pilot_libero10_3x5/episodes/pi05_libero10_pilot/task0000_ep0000_success.mp4)

### LIBERO-Spatial object displacement (+y)

- Protocol: same 3 Spatial tasks × 5 episodes, seed 7
- Perturbation: pick-target (`akita_black_bowl_1`) translated along **+y**
  after the official init state

| shift | overall | task 0 | task 1 (next to ramekin) | task 2 |
| ----- | ------- | ------ | ------------------------ | ------ |
| 0 cm  | 15/15   | 5/5    | 5/5                      | 5/5    |
| 2 cm  | 15/15   | 5/5    | 5/5                      | 5/5    |
| 5 cm  | 15/15   | 5/5    | 5/5                      | 5/5    |
| 7.5 cm | 14/15 (93%) | 5/5 | **4/5**               | 5/5    |
| 10 cm | **12/15 (80%)** | 5/5 | **2/5**              | 5/5    |
| 12.5 cm | 13/15 (87%) | 5/5 | **4/5**            | **4/5** |
| 15 cm | **10/15 (67%)** | **4/5** | **2/5**           | **4/5** |
| 15 cm, max_steps=440 | **11/15 (73%)** | 5/5 | **3/5** | **3/5** |

- Failures at 220 were all timeouts. Doubling the horizon did **not** produce any
  success with 221–440 steps: 440-run successes finished in 84–135 steps, and
  remaining failures still timed out at 440. Same init can flip success/fail
  across runs (π0.5 sampling), so n=5 percentages are noisy.
- Failure videos: the arm typically reaches the bowl and is over the plate at
  timeout (late-stage place), not reaching toward an empty memorized spot.
- Keyframes: [artifacts/failure_keyframes](artifacts/failure_keyframes)
- [2 cm artifacts](artifacts/pilot_libero_object_shift_2cm_3x5)
- [5 cm artifacts](artifacts/pilot_libero_object_shift_5cm_3x5)
- [7.5 cm artifacts](artifacts/pilot_libero_object_shift_7p5cm_y_3x5)
- [10 cm artifacts](artifacts/pilot_libero_object_shift_10cm_3x5)
- [12.5 cm artifacts](artifacts/pilot_libero_object_shift_12p5cm_y_3x5)
- [15 cm artifacts](artifacts/pilot_libero_object_shift_15cm_3x5)
- [15 cm max_steps=440 artifacts](artifacts/pilot_libero_object_shift_15cm_max440_3x5)
- [10 cm failure video](artifacts/pilot_libero_object_shift_10cm_3x5/episodes/pi05_libero_spatial_objshift_10cm/task0001_ep0000_fail.mp4)
- [15 cm failure video](artifacts/pilot_libero_object_shift_15cm_3x5/episodes/pi05_libero_spatial_objshift_15cm/task0000_ep0000_fail.mp4)

### Discovery effect sizes (same 3×5, seed 7)

| factor | overall | Δ vs 0 cm | notes |
| --- | --- | --- | --- |
| baseline | 15/15 | — | |
| camera yaw 15° | 15/15 | 0 | |
| camera yaw 30° | 15/15 | 0 | [artifacts](artifacts/pilot_libero_camera_yaw30_3x5) |
| camera yaw 45° | **13/15 (87%)** | **−13%** | task 1: 3/5; [artifacts](artifacts/pilot_libero_camera_yaw45_3x5) |
| object +y 5 cm | 15/15 | 0 | |
| object +y 7.5 cm | 14/15 (93%) | −7% | task 1: 4/5; [artifacts](artifacts/pilot_libero_object_shift_7p5cm_y_3x5) |
| object +y 10 cm | **12/15 (80%)** | **−20%** | task 1: 2/5 |
| object +y 12.5 cm | 13/15 (87%) | −13% | n=5 non-monotonic vs 10 cm; [artifacts](artifacts/pilot_libero_object_shift_12p5cm_y_3x5) |
| object −y 10 cm | 14/15 (93%) | −7% | task 2: 4/5; [artifacts](artifacts/pilot_libero_object_shift_10cm_neg_y_3x5) |
| object +x 10 cm | **12/15 (80%)** | **−20%** | task 0: 3/5; [artifacts](artifacts/pilot_libero_object_shift_10cm_x_3x5) |
| object −x 10 cm | **10/15 (67%)** | **−33%** | task 1: 1/5; [artifacts](artifacts/pilot_libero_object_shift_10cm_neg_x_3x5) |
| object +y 15 cm | **10/15 (67%)** | **−33%** | all three tasks drop |
| LIBERO-10 | 15/15 | 0 | longer tasks, not a perturbation |

Largest scout effects are **object translation**, not camera. Robustness is
**not isotropic**. At 10 cm: −x 67% (task 1 = 1/5) is worst; −y 93% is
near noise. +x breaks task 0; ±y / −x break task 1.

### Direction at 10 cm (object only)

| axis | overall | task 0 | task 1 | task 2 |
| --- | --- | --- | --- | --- |
| +x | 12/15 | **3/5** | 5/5 | 4/5 |
| −x | **10/15** | 5/5 | **1/5** | 4/5 |
| +y | 12/15 | 5/5 | **2/5** | 5/5 |
| −y | 14/15 | 5/5 | 5/5 | 4/5 |

### Pair shift vs object-only (10 cm)

Same 3×5, seed 7. Pair = pick target **and ramekin** translated together
(`shift_mode=pick_and_landmark`). Plate stays.

| axis | object only | pair (bowl+ramekin) | task 1 only→pair |
| --- | --- | --- | --- |
| +y | 12/15 | **15/15** | 2/5 → **5/5** |
| −x | 10/15 | 11/15 | **1/5 → 1/5** |

+y drop on the relational task is recovered by preserving “next to the
ramekin”. −x is not: task 1 stays 1/5. Relational grounding explains +y,
not the worst axis.

### −x mechanism (pose traces, same 3×5 seed 7)

Timeouts used to log `on_plate=None` because poses were only snapshotted on
`done`. A second −x 10 cm object-only run snapshots **every step**.
Overall **11/15** (task 1 still **1/5**). Sampling noise vs earlier 10/15
and 12/15; task 1 staying ~1/5 is the stable part.
[Traced artifacts](artifacts/pilot_libero_object_shift_10cm_neg_x_traced2_3x5)

`on_plate` = nearest of pick-bowl / ramekin / other-bowl within 10 cm of
the plate at the last step. Distances in cm.

| task 1 ep | success | on_plate | pick→plate | ramekin→plate | pick moved | ramekin moved | label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | no | **none** | 40.3 | 24.2 | 1.8 | 2.2 | no-grasp (nothing moved) |
| 1 | no | **ramekin** | 38.4 | 1.2 | 4.5 | 23.4 | identity |
| 2 | no | **ramekin** | 35.4 | 1.8 | 2.1 | 26.3 | identity |
| 3 | no | **ramekin** | 37.3 | 1.7 | 1.1 | 22.9 | identity |
| 4 | yes | pick_bowl | 2.3 | 5.9 | 35.2 | 22.1 | correct bowl (ramekin also dragged) |

Task 0 and 2 were 5/5, all `on_plate=pick_bowl`. Task 2 never moves the
ramekin. So **3/4 −x task-1 fails are identity** (ramekin placed, black
bowl stays put). The remaining fail never transported anything. Pair
shift cannot fix identity; that is why −x pair stayed 1/5.

### Language ablation at −x 10 cm

Same geometry as traced2 (object-only −x 10 cm, seed 7). Only change:
task 1 instruction becomes `pick up the black bowl and place it on the
plate` (drop “next to the ramekin”). Tasks 0 and 2 unchanged.
[Artifacts](artifacts/pilot_libero_object_shift_10cm_neg_x_nolang_3x5)

| | original instruction | drop landmark phrase |
| --- | --- | --- |
| overall | 11/15 | **10/15** |
| task 0 | 5/5 | 5/5 |
| task 1 | **1/5** | **0/5** |
| task 2 | 5/5 | 5/5 |

Task 1 fails without the phrase:

| ep | on_plate | pick moved | ramekin moved | label |
| --- | --- | --- | --- | --- |
| 0 | **ramekin** | 0.4 cm | 23.8 cm | identity |
| 1 | **ramekin** | 0.3 cm | 24.4 cm | identity |
| 2 | none | ~0 | 0.3 cm | no-grasp |
| 3 | **ramekin** | 0.5 cm | 22.4 cm | identity |
| 4 | **other_bowl** | ~0 | ~0 | identity (wrong bowl) |

Dropping the landmark phrase does **not** recover −x task 1. The one
success disappears (n=5 noise vs “made worse”). Identity remains:
3× ramekin, 1× other black bowl, 1× nothing moved. −x is visual/spatial
object identity, not the words “next to the ramekin”.

**−x task 1 videos** (object-only 4 fails + pair 4 fails, contact sheets in
[artifacts/negx_t1_sheets](artifacts/negx_t1_sheets)): first frames still
show the bowls in `agentview` (not the +y-15 cm crop). Last frames match
the pose table: pale vessel on the plate, or idle with objects unmoved.
[Pair +y](artifacts/pilot_libero_pair_shift_10cm_y_3x5) ·
[Pair −x](artifacts/pilot_libero_pair_shift_10cm_neg_x_3x5)

### Failure-stage labels (agentview contact sheets)

Provisional. Reach = never at the object; Grasp = at object, no secure lift;
Place = object at/over the plate but success never flags. Sheets:
[artifacts/failure_sheets](artifacts/failure_sheets).

| condition | episode | last-frame stage |
| --- | --- | --- |
| +y 10 cm | t1 ep0 | Place (gripper over plate/bowl on the left) |
| +y 10 cm | t1 ep2 | Reach/Grasp at FOV edge (target clipped the whole episode) |
| +y 10 cm | t1 ep4 | Place or Grasp (open gripper over bowl on plate-like rim) |
| +y 15 cm | t0 ep0 | Grasp (bowl clipped, appears knocked) |
| +y 15 cm | t1 ep2 | Grasp (gripper over in-view bowl) |
| +y 15 cm | t1 ep3 | Reach/idle (arm high, no clear grasp) |
| +y 15 cm | t1 ep4 | Grasp (open gripper over bowl) |
| +y 15 cm | t2 ep3 | Place/Grasp (gripper over near-edge dish) |
| +y 15 cm max440 | t1 ep3 | Place (gripper over dish with contact marker) |
| +x 10 cm | t0 ep0 | Grasp / possible wrong object (white bowl under gripper; dark bowl half off-frame) |
| +x 10 cm | t2 ep2 | Transport/Place (holding bowl at bottom-left edge) |
| −y 10 cm | t2 ep3 | Grasp at FOV edge |
| camera 45° | t1 ep2 | Grasp (gripper over silver bowl; scene still in view) |

Failures are mixed, not one FOV story. The relational pair result is cleaner
than the stage labels.

### LIBERO-Spatial camera-view pilot (15° yaw)

- Protocol: same 3 Spatial tasks × 5 episodes, seed 7
- Perturbation: third-person `agentview` rotated 15° around the table
  (LIBERO-Plus Camera Viewpoints C2, mild azimuth)
- Result: 15/15 successful episodes
- Mean trajectory lengths: 75.8, 103.6, and 97.6 steps
- [Aggregate JSON](artifacts/pilot_libero_camera_yaw15_3x5/pi05_libero_spatial_camera_yaw15_aggregate.json)
- [All camera-shift videos](artifacts/pilot_libero_camera_yaw15_3x5/episodes/pi05_libero_spatial_camera_yaw15)
- [Representative video](artifacts/pilot_libero_camera_yaw15_3x5/episodes/pi05_libero_spatial_camera_yaw15/task0000_ep0000_success.mp4)

## What is stored

- Every episode video (`.mp4`)
- Every episode step record (`.jsonl`)
- Aggregate benchmark summaries (`.json`)
- Raw evaluation databases (`.sqlite`)
- Reproducible local configs and setup/run scripts

## Important interpretation

These are n=5 scouts, not a fitted paper curve. Discovery ranking:
object translation (−20% at 10 cm, −33% at 15 cm) > camera yaw (−13%
only at 45°) > longer-horizon LIBERO-10 (0 at this n). Camera 15–30°
is a false negative if you stop at mild yaw. Title stays “degradation”
until a threshold is real.

**Split so far:** +y task-1 drop ≈ relational grounding (pair recovers).
−x task-1 drop ≈ identity (3/4) plus no-grasp (1/4). Dropping
“next to the ramekin” at −x 10 cm does **not** recover task 1
(1/5 → **0/5**); remaining fails are still wrong-object or no-grasp.
Do not add curve points. RoboTwin still later.

## Local platform notes

- Windows 11 + Ubuntu 22.04 under WSL2
- NVIDIA RTX 5090 Laptop GPU (24 GB)
- VLA Evaluation Harness v0.4.0
- Docker Desktop
- Local server override disables checkpoint `torch.compile` because the saved
  `max-autotune` setting caused first-action timeouts on this RTX 5090/WSL2
  setup.

