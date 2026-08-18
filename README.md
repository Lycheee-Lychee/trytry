# π0.5 × LIBERO Evaluation

Small-scale evaluation of the `lerobot/pi05_libero_finetuned` policy on the
LIBERO robot-manipulation benchmark. The simulated robot is a Franka Emika
Panda with a parallel-jaw gripper, running in MuJoCo through robosuite and
LIBERO.

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

## What is stored

- Every episode video (`.mp4`)
- Every episode step record (`.jsonl`)
- Aggregate benchmark summaries (`.json`)
- Raw evaluation databases (`.sqlite`)
- Reproducible local configs and setup/run scripts

## Important interpretation

These are pilot baselines, not evidence that π0.5 has solved LIBERO. The
checkpoint is fine-tuned on LIBERO, only three tasks per suite were tested,
and each task used five episodes under standard conditions. The next planned
study is controlled robustness evaluation under LIBERO-Plus camera-view
distribution shifts.

## Local platform notes

- Windows 11 + Ubuntu 22.04 under WSL2
- NVIDIA RTX 5090 Laptop GPU (24 GB)
- VLA Evaluation Harness v0.4.0
- Docker Desktop
- Local server override disables checkpoint `torch.compile` because the saved
  `max-autotune` setting caused first-action timeouts on this RTX 5090/WSL2
  setup.

