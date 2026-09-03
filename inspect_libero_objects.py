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
    sim = getattr(env, "sim", None)
    if sim is None:
        sim = env.env.sim
    bodies = [sim.model.body_id2name(j) for j in range(sim.model.nbody)]
    joints = [sim.model.joint_id2name(j) for j in range(sim.model.njnt)]
    print("bodies:", [b for b in bodies if b and "robot0" not in b and b != "world"])
    print("joints:", [j for j in joints if j and "robot0" not in j])
    for obj in (env, getattr(env, "env", None)):
        if obj is None:
            continue
        for attr in ("obj_of_interest", "objects_dict", "objects"):
            if hasattr(obj, attr):
                print(attr, getattr(obj, attr))
    env.close()
