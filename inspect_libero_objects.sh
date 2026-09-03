#!/usr/bin/env bash
set -euo pipefail
docker run --rm --entrypoint conda ghcr.io/allenai/vla-evaluation-harness/libero:latest \
  run --no-capture-output -n libero python - <<'PY'
from pathlib import Path
from libero.libero import benchmark, get_libero_path
from libero.libero.envs import OffScreenRenderEnv

suite = benchmark.get_benchmark_dict()["libero_spatial"]()
print("n_tasks", suite.get_num_tasks())
for i in range(min(5, suite.get_num_tasks())):
    task = suite.get_task(i)
    print(f"\n=== task {i}: {task.language} ===")
    bddl = Path(get_libero_path("bddl_files")) / task.problem_folder / task.bddl_file
    env = OffScreenRenderEnv(bddl_file_name=str(bddl), camera_heights=128, camera_widths=128)
    env.reset()
    sim = getattr(env, "sim", None) or env.env.sim
    bodies = [sim.model.body_id2name(j) for j in range(sim.model.nbody)]
    joints = [sim.model.joint_id2name(j) for j in range(sim.model.njnt)]
    print("bodies:", [b for b in bodies if b and "robot" not in b.lower() and "world" not in b.lower()][:40])
    print("joints:", [j for j in joints if j and "robot" not in j.lower()][:40])
    for attr in ("obj_of_interest", "objects_dict", "objects"):
        if hasattr(env, attr):
            print(attr, getattr(env, attr))
    inner = getattr(env, "env", None)
    if inner is not None:
        for attr in ("obj_of_interest", "objects_dict", "objects"):
            if hasattr(inner, attr):
                val = getattr(inner, attr)
                print("inner."+attr, type(val), val if not callable(val) else "callable")
    env.close()
PY
