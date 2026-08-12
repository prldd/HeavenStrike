#!/usr/bin/env python3
"""Extract attack-animation frames from a generated video clip.

Turns a short AI-generated attack clip (character on a white background) into
the 3x2 transparent PNG atlas the game loads from
assets/units/attack/<art id>.png (see BoardView._attack_atlas_for).

Steps per frame:
  1. ffmpeg extracts the frame at a chosen timestamp.
  2. Letterbox bars (pure black rows/columns at the edges) are cropped.
  3. The white/paper background and the gray ground shadow are removed by
     flood-selecting near-white and low-saturation gray pixels connected to
     the image border (dark ink outlines enclose the character, so the fill
     stops at the silhouette).
  4. The frame is cropped to its alpha bounding box.
  5. All frames are rescaled and re-anchored onto the idle sprite's canvas
     (assets/units/full/<art id>.png): the scale comes from the LAST frame
     (the returned-to-idle pose), and every frame's feet land on the idle
     sprite's foot line, horizontally centered on the idle sprite. BoardView
     draws the full canvas, so identical canvas size and placement means the
     character does not jump or change size when the frames swap.

Usage:
  python extract_attack_frames.py --video <clip.mp4> --art-id 241
  python extract_attack_frames.py --video <clip.mp4> --art-id 241 \
      --times 0,0.15,0.3,0.5,1.0,1.5

Without --times, frames are sampled at --fractions of the clip duration
(default skews early, because generated clips usually front-load the action).
A compact preview is written under the ignored `.tools/attack-previews/` folder.
"""

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

DEFAULT_FRACTIONS = [0.0, 0.08, 0.16, 0.3, 0.5, 0.8]
FRAME_COUNT = 6
ATLAS_CELL_SIZE = 512


def probe_duration(video: Path) -> float:
    result = subprocess.run(
        [
            "ffprobe", "-v", "error", "-show_entries", "format=duration",
            "-of", "default=noprint_wrappers=1:nokey=1", str(video),
        ],
        capture_output=True, text=True, check=True,
    )
    return float(result.stdout.strip())


def extract_frame(video: Path, time_s: float, out_path: Path) -> None:
    subprocess.run(
        [
            "ffmpeg", "-y", "-v", "error", "-ss", f"{time_s:.3f}",
            "-i", str(video), "-frames:v", "1", str(out_path),
        ],
        check=True,
    )


def crop_letterbox(arr: np.ndarray) -> np.ndarray:
    """Remove contiguous near-black bars at the image edges."""
    rgb = arr[..., :3].astype(int)
    dark = rgb.max(axis=-1) < 16

    def first_light(mask: np.ndarray) -> int:
        hits = np.flatnonzero(~mask)
        return int(hits[0]) if hits.size else 0

    def last_light(mask: np.ndarray) -> int:
        hits = np.flatnonzero(~mask)
        return int(hits[-1]) + 1 if hits.size else mask.size

    top = first_light(dark.all(axis=1))
    bottom = last_light(dark.all(axis=1))
    left = first_light(dark.all(axis=0))
    right = last_light(dark.all(axis=0))
    return arr[top:bottom, left:right]


def remove_background(
    arr: np.ndarray,
    white_threshold: int,
    gray_min: int,
    gray_sat: float,
    feather: float,
) -> np.ndarray:
    """Alpha-key white background and gray shadow connected to the border."""
    rgb = arr[..., :3].astype(np.float32)
    maxc = rgb.max(axis=-1)
    minc = rgb.min(axis=-1)
    sat = np.where(maxc > 0, (maxc - minc) / np.maximum(maxc, 1.0), 0.0)

    near_white = minc >= white_threshold
    flat_gray = (sat <= gray_sat) & (maxc >= gray_min) & (maxc < white_threshold + 8)
    candidate = near_white | flat_gray

    labels, _ = ndimage.label(candidate, structure=np.ones((3, 3)))
    border_labels = np.unique(
        np.concatenate([labels[0], labels[-1], labels[:, 0], labels[:, -1]])
    )
    background = np.isin(labels, border_labels[border_labels != 0])

    foreground = ~background
    # Drop specks (compression noise) but keep large detached parts such as
    # floating shields or crests.
    fg_labels, count = ndimage.label(foreground, structure=np.ones((3, 3)))
    min_area = max(32, foreground.size // 5000)
    for label_id in range(1, count + 1):
        if (fg_labels == label_id).sum() < min_area:
            foreground[fg_labels == label_id] = False

    # Erode one pixel to cut the white halo, then feather the edge.
    foreground = ndimage.binary_erosion(foreground, iterations=1)
    alpha = foreground.astype(np.float32) * 255.0
    if feather > 0:
        alpha = np.clip(ndimage.gaussian_filter(alpha, sigma=feather), 0, 255)

    out = arr.copy()
    out[..., 3] = alpha.astype(np.uint8)
    return out


def alpha_bbox(arr: np.ndarray, threshold: int = 8) -> tuple[int, int, int, int]:
    ys, xs = np.nonzero(arr[..., 3] > threshold)
    if ys.size == 0:
        raise ValueError("frame is fully transparent after background removal")
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def crop_to_bbox(arr: np.ndarray) -> np.ndarray:
    x0, y0, x1, y1 = alpha_bbox(arr)
    return arr[y0:y1, x0:x1]


def remove_border_white_remnants(
    arr: np.ndarray, white_threshold: int = 245,
) -> np.ndarray:
    """Remove backdrop-sized white regions missed by the initial flood fill."""
    rgb = arr[..., :3]
    candidate = (rgb.min(axis=-1) >= white_threshold) & (arr[..., 3] > 8)
    labels, _ = ndimage.label(candidate, structure=np.ones((3, 3)))
    border_labels = np.unique(
        np.concatenate([labels[0], labels[-1], labels[:, 0], labels[:, -1]])
    )
    out = arr.copy()
    large_area = candidate.size // 50
    cleanup_labels = set(int(label_id) for label_id in border_labels if label_id != 0)
    for label_id in range(1, int(labels.max()) + 1):
        if (labels == label_id).sum() >= large_area:
            cleanup_labels.add(label_id)
    cleanup_mask = np.zeros(candidate.shape, dtype=bool)
    for label_id in cleanup_labels:
        mask = labels == label_id
        if mask.sum() >= 32:
            cleanup_mask |= mask
    cleanup_mask = ndimage.binary_dilation(cleanup_mask, iterations=1)
    out[cleanup_mask, 3] = 0
    return out


def paste_anchored(
    frame: np.ndarray, canvas_size: tuple[int, int], scale: float,
    foot_y: int, center_x: int,
) -> np.ndarray:
    """Scale frame and paste onto a transparent canvas, feet on foot_y."""
    h, w = frame.shape[:2]
    new_w = max(1, round(w * scale))
    new_h = max(1, round(h * scale))
    resized = np.array(
        Image.fromarray(frame).resize((new_w, new_h), Image.LANCZOS)
    )
    canvas = np.zeros((canvas_size[1], canvas_size[0], 4), dtype=np.uint8)
    x = int(round(center_x - new_w / 2))
    y = int(round(foot_y - new_h))
    # Shift into view if the pose reaches past the canvas edge.
    x = min(max(x, 0), canvas_size[0] - new_w) if new_w <= canvas_size[0] else 0
    y = min(max(y, 0), canvas_size[1] - new_h) if new_h <= canvas_size[1] else 0
    src = resized[: canvas_size[1] - y, : canvas_size[0] - x]
    canvas[y : y + src.shape[0], x : x + src.shape[1]] = src
    return canvas


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--video", required=True, type=Path)
    parser.add_argument("--art-id", required=True, type=int)
    parser.add_argument("--times", default="", help="comma-separated seconds")
    parser.add_argument("--fractions", default="", help="comma-separated 0..1")
    parser.add_argument("--idle", type=Path, default=None)
    parser.add_argument("--out", type=Path, default=None)
    parser.add_argument("--preview-out", type=Path, default=None)
    parser.add_argument("--white-threshold", type=int, default=245)
    parser.add_argument("--gray-min", type=int, default=150)
    parser.add_argument("--gray-sat", type=float, default=0.12)
    parser.add_argument("--feather", type=float, default=1.2)
    args = parser.parse_args()

    art_id = args.art_id
    idle_path = args.idle or Path(f"assets/units/full/{art_id:03d}.png")
    out_path = args.out or Path(f"assets/units/attack/{art_id:03d}.png")
    preview_path = args.preview_out or Path(
        f".tools/attack-previews/{art_id:03d}.png"
    )
    if not args.video.is_file():
        sys.exit(f"video not found: {args.video}")
    if not idle_path.is_file():
        sys.exit(f"idle sprite not found: {idle_path}")

    duration = probe_duration(args.video)
    if args.times:
        times = [float(t) for t in args.times.split(",")]
    else:
        fractions = (
            [float(f) for f in args.fractions.split(",")]
            if args.fractions else DEFAULT_FRACTIONS
        )
        times = [min(f, 0.999) * duration for f in fractions]
    if len(times) != FRAME_COUNT:
        sys.exit(
            f"expected exactly {FRAME_COUNT} timestamps, got {len(times)}; "
            "the runtime atlas always contains six cells"
        )
    if any(time_s < 0.0 or time_s >= duration for time_s in times):
        sys.exit(
            "every timestamp must be at least 0 and less than the "
            f"{duration:.2f}s clip duration"
        )
    if times != sorted(times):
        sys.exit("timestamps must be in ascending order")
    print(f"clip duration {duration:.2f}s; sampling at {['%.2f' % t for t in times]}")

    idle = np.array(Image.open(idle_path).convert("RGBA"))
    idle_x0, idle_y0, idle_x1, idle_y1 = alpha_bbox(idle)
    idle_h = idle_y1 - idle_y0
    idle_foot_y = idle_y1
    idle_center_x = (idle_x0 + idle_x1) / 2
    canvas_size = (idle.shape[1], idle.shape[0])

    out_path.parent.mkdir(parents=True, exist_ok=True)
    preview_path.parent.mkdir(parents=True, exist_ok=True)
    cropped_frames: list[np.ndarray] = []
    with tempfile.TemporaryDirectory() as tmp:
        for index, time_s in enumerate(times):
            raw_path = Path(tmp) / f"raw_{index}.png"
            extract_frame(args.video, time_s, raw_path)
            arr = np.array(Image.open(raw_path).convert("RGBA"))
            arr = crop_letterbox(arr)
            arr = remove_background(
                arr, args.white_threshold, args.gray_min, args.gray_sat, args.feather
            )
            cropped = crop_to_bbox(arr)
            cropped = remove_border_white_remnants(cropped, args.white_threshold)
            cropped_frames.append(crop_to_bbox(cropped))

    # Scale every frame by the LAST frame (the settled, idle-like pose) so the
    # whole sequence matches the idle sprite's height and crouched poses stay
    # proportionally smaller instead of being stretched to full height.
    last_h = cropped_frames[-1].shape[0]
    scale = idle_h / last_h
    print(f"idle bbox height {idle_h}px, last frame {last_h}px, scale {scale:.3f}")

    source_frames = [
        remove_border_white_remnants(
            paste_anchored(frame, canvas_size, scale, idle_foot_y, idle_center_x),
            args.white_threshold,
        )
        for frame in cropped_frames
    ]
    normalized_frames = [
        np.array(
            Image.fromarray(frame).resize(
                (ATLAS_CELL_SIZE, ATLAS_CELL_SIZE), Image.LANCZOS
            )
        )
        for frame in source_frames
    ]
    atlas = Image.new(
        "RGBA", (ATLAS_CELL_SIZE * 3, ATLAS_CELL_SIZE * 2), (0, 0, 0, 0)
    )
    for index, frame in enumerate(normalized_frames):
        atlas.alpha_composite(
            Image.fromarray(frame),
            ((index % 3) * ATLAS_CELL_SIZE, (index // 3) * ATLAS_CELL_SIZE),
        )
    atlas.save(out_path)

    # Contact sheet for review: frames side by side on a neutral checker.
    tile = 256
    sheet = Image.new("RGBA", (tile * len(cropped_frames), tile), (40, 40, 48, 255))
    for index, frame in enumerate(normalized_frames):
        thumb = Image.fromarray(frame)
        thumb.thumbnail((tile, tile), Image.LANCZOS)
        sheet.paste(thumb, (tile * index + (tile - thumb.width) // 2, tile - thumb.height), thumb)
    sheet.save(preview_path)

    print(f"wrote 3x2 attack atlas to {out_path}; preview to {preview_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
