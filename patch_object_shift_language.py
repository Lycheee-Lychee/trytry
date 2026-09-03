"""Add drop_landmark_phrase to LIBEROObjectShiftBenchmark (idempotent)."""
from pathlib import Path

path = Path("/home/lychee/research/vla-evaluation-harness/src/vla_eval/benchmarks/libero/object_shift.py")
text = path.read_text(encoding="utf-8")
if "drop_landmark_phrase" in text:
    print("already patched")
    raise SystemExit(0)

old_init_sig = """        landmark_substr: str = "ramekin",
        send_state: bool = False,
        send_wrist_image: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(send_state=send_state, send_wrist_image=send_wrist_image, **kwargs)
        self.object_shift_cm = float(object_shift_cm)
"""
new_init_sig = """        landmark_substr: str = "ramekin",
        drop_landmark_phrase: bool = False,
        send_state: bool = False,
        send_wrist_image: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(send_state=send_state, send_wrist_image=send_wrist_image, **kwargs)
        self.object_shift_cm = float(object_shift_cm)
"""
if old_init_sig not in text:
    raise SystemExit("init signature not found")
text = text.replace(old_init_sig, new_init_sig, 1)

old_mode = """        self.landmark_substr = landmark_substr.lower()
        self._start_poses: dict[str, list[float]] = {}
"""
new_mode = """        self.landmark_substr = landmark_substr.lower()
        self.drop_landmark_phrase = bool(drop_landmark_phrase)
        self._start_poses: dict[str, list[float]] = {}
"""
if old_mode not in text:
    raise SystemExit("landmark_substr block not found")
text = text.replace(old_mode, new_mode, 1)

old_reset = """    def reset(self, task: Task) -> Any:
"""
new_reset = '''    def get_tasks(self) -> list[Task]:
        tasks = super().get_tasks()
        if not self.drop_landmark_phrase:
            return tasks
        rewritten = []
        for task in tasks:
            name = task.get("name", "")
            if "next to the ramekin" in name.lower():
                task = dict(task)
                task["name"] = "pick up the black bowl and place it on the plate"
            rewritten.append(task)
        return rewritten

    def reset(self, task: Task) -> Any:
'''
if old_reset not in text:
    raise SystemExit("reset not found")
text = text.replace(old_reset, new_reset, 1)

old_meta = """            "landmark_substr": self.landmark_substr,
            "target": "obj_of_interest[0]",
"""
new_meta = """            "landmark_substr": self.landmark_substr,
            "drop_landmark_phrase": self.drop_landmark_phrase,
            "target": "obj_of_interest[0]",
"""
if old_meta not in text:
    raise SystemExit("metadata block not found")
text = text.replace(old_meta, new_meta, 1)

path.write_text(text, encoding="utf-8")
print("patched", path)
