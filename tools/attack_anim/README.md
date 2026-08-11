# Attack animation pipeline

Generated attack clips become six optional sprite frames. `BoardView` loads a
complete frame set automatically and uses it in place of the unit's generic
class attack effect; units without one retain the standard static sprite lunge
and class effect. Sound, lunge motion, damage flashes, and combat timing remain
shared. Generated frames remain visible at 2×/4× speed and during autobattle
when `ANIM ON`; `ANIM OFF` is the explicit way to skip them.

## Generate the source clip

Use the unit's full-body PNG as the image-to-video reference. Ask for one short
attack followed by a return to the original idle pose. Keep the camera static,
the character centered, and the background plain white. Avoid camera motion,
lettering, borders, and ground shadows.

The runtime folder is keyed by **art ID**, not catalog icon. For example,
Brass Bastion-136 has icon `136`, but `UnitCatalog.art_id(136)` is `241`.

## Set up Python once

From Git Bash on Windows:

```bash
python -m venv .tools/anim-pipeline-venv
.tools/anim-pipeline-venv/Scripts/python.exe -m pip install -r tools/attack_anim/requirements.txt
```

`ffmpeg` and `ffprobe` must also be available on `PATH`.

## Extract a frame set

```bash
.tools/anim-pipeline-venv/Scripts/python.exe tools/attack_anim/extract_attack_frames.py \
  --video .tools/anim_inbox/241_attack.mp4 \
  --art-id 241
```

The default samples are intentionally concentrated near the start of the clip.
For a differently timed attack, provide exactly six timestamps in seconds:

```bash
.tools/anim-pipeline-venv/Scripts/python.exe tools/attack_anim/extract_attack_frames.py \
  --video .tools/anim_inbox/241_attack.mp4 \
  --art-id 241 \
  --times 0,0.15,0.30,0.50,1.00,1.50
```

Output is written to `assets/units/attack/241/attack_1.png` through
`attack_6.png`, plus `preview.png`. The script removes letterboxing and the
connected white/gray background, then scales and anchors every frame to the
unit's existing idle canvas.

Open the Godot editor after extraction so the new PNG files are imported.
Runtime loading uses those imported textures because raw image loading is not
supported in exported builds.

## Verify in Godot

The focused visual check does not depend on player save data or Reserves:

```bash
"/e/Tools/Godot/Godot_console.exe" --path . \
  --script res://tests/attack_animation_visual_check.gd
```

It validates all six imported frames and writes
`tests/attack-animation-visual.png`. Normal gameplay uses the same
`BoardView.animate_attack` path.
