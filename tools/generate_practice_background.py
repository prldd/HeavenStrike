"""Generate the practice-mode board background (steampunk training hall interior).

Same design language as assets/board-steampunk-courtyard.png — warm wood,
brass trim, teal/crimson banners, lanterns, gear motifs — but an interior
training hall instead of the open-air courtyard platform.

Run with:  python tools/generate_practice_background.py
Output:    assets/board-steampunk-training-hall.png (2167x726, same as courtyard)
"""

import math
import random

from PIL import Image, ImageDraw, ImageFilter

W, H = 2167, 726
OUT = "assets/board-steampunk-training-hall.png"

# Palette sampled from the courtyard art direction.
INK = (36, 22, 16)
WOOD_DARK = (52, 33, 20)
WOOD_MID = (94, 63, 36)
WOOD_LIGHT = (140, 100, 58)
DECK_LIGHT = (168, 126, 76)
BRASS = (184, 138, 72)
BRASS_DARK = (110, 79, 39)
GOLD = (246, 196, 113)
TEAL = (46, 111, 106)
TEAL_DARK = (30, 74, 70)
CRIMSON = (142, 47, 50)
CRIMSON_DARK = (96, 30, 34)

random.seed(7)


def lerp(a, b, t):
	return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def vgrad(size, top, bottom):
	w, h = size
	img = Image.new("RGB", size)
	d = ImageDraw.Draw(img)
	for y in range(h):
		d.line([(0, y), (w, y)], fill=lerp(top, bottom, y / max(1, h - 1)))
	return img


def radial_glow(size, color, alpha):
	"""Soft radial glow, brightest at centre, fading to transparent."""
	glow = Image.new("L", size, 0)
	d = ImageDraw.Draw(glow)
	cx, cy = size[0] // 2, size[1] // 2
	r = min(size) // 2
	for i in range(r, 0, -1):
		a = int(alpha * (1 - i / r) ** 1.8)
		d.ellipse([cx - i, cy - i, cx + i, cy + i], fill=a)
	glow = glow.filter(ImageFilter.GaussianBlur(r * 0.18))
	layer = Image.new("RGBA", size, color + (0,))
	layer.putalpha(glow)
	return layer


def plank_lines(d, box, spacing, gap_color, horizontal=True):
	x0, y0, x1, y1 = box
	if horizontal:
		y = y0
		while y <= y1:
			d.line([(x0, y), (x1, y)], fill=gap_color, width=2)
			y += spacing
	else:
		x = x0
		while x <= x1:
			d.line([(x, y0), (x, y1)], fill=gap_color, width=2)
			x += spacing


def wood_grain(img, box, strength=10):
	"""Add per-plank tonal noise inside a region of an RGB image."""
	x0, y0, x1, y1 = [int(v) for v in box]
	region = img.crop((x0, y0, x1, y1)).convert("RGB")
	noise = Image.effect_noise(region.size, 28).point(lambda p: int((p - 128) * strength / 32 + 128))
	grain = Image.merge("RGB", (noise, noise, noise))
	img.paste(Image.blend(region, grain, 0.18), (x0, y0))


def draw_gear(d, cx, cy, r, teeth, body, rim):
	"""Flat brass gear emblem: toothed ring with hub."""
	for i in range(teeth):
		a = 2 * math.pi * i / teeth
		tx = cx + math.cos(a) * r
		ty = cy + math.sin(a) * r
		tr = r * 0.16
		d.ellipse([tx - tr, ty - tr, tx + tr, ty + tr], fill=rim)
	d.ellipse([cx - r * 0.82, cy - r * 0.82, cx + r * 0.82, cy + r * 0.82], fill=body)
	d.ellipse([cx - r * 0.82, cy - r * 0.82, cx + r * 0.82, cy + r * 0.82], outline=rim, width=3)
	d.ellipse([cx - r * 0.30, cy - r * 0.30, cx + r * 0.30, cy + r * 0.30], fill=rim)
	d.ellipse([cx - r * 0.16, cy - r * 0.16, cx + r * 0.16, cy + r * 0.16], fill=body)


def draw_arch_window(base, cx, top, w, h, frame, glass_top, glass_bot):
	"""Arched window with warm sunset glass and mullions."""
	d = ImageDraw.Draw(base)
	x0, y0, x1, y1 = cx - w // 2, top, cx + w // 2, top + h
	# Glass: vertical warm gradient with arch top.
	glass = vgrad((w, h), glass_top, glass_bot).convert("RGBA")
	mask = Image.new("L", (w, h), 0)
	md = ImageDraw.Draw(mask)
	arch_r = w // 2
	md.rectangle([0, arch_r, w, h], fill=255)
	md.ellipse([0, 0, w, arch_r * 2], fill=255)
	base.paste(glass, (x0, y0), mask)
	# Frame + mullions.
	d.arc([x0, y0, x1, y0 + arch_r * 2], 180, 360, fill=frame, width=6)
	d.line([(x0, y0 + arch_r), (x0, y1)], fill=frame, width=6)
	d.line([(x1, y0 + arch_r), (x1, y1)], fill=frame, width=6)
	d.line([(x0, y1), (x1, y1)], fill=frame, width=6)
	d.line([(cx, y0), (cx, y1)], fill=frame, width=4)
	for t in (0.38, 0.66):
		yy = y0 + int(h * t)
		d.line([(x0, yy), (x1, yy)], fill=frame, width=4)
	# Sill.
	d.rectangle([x0 - 8, y1, x1 + 8, y1 + 10], fill=frame)


def draw_banner(base, pole_x, top, w, h, cloth, cloth_dark):
	"""Hanging swallowtail banner with gold trim, like the courtyard flags."""
	d = ImageDraw.Draw(base)
	x0, x1 = pole_x, pole_x + w
	y0, y1 = top, top + h
	# Pole and finial.
	d.line([(pole_x, y0 - 26), (pole_x, y1)], fill=BRASS_DARK, width=6)
	d.polygon([(pole_x, y0 - 40), (pole_x - 7, y0 - 22), (pole_x + 7, y0 - 22)], fill=BRASS)
	# Cloth: rectangle with swallowtail notch, fold shading.
	notch = int(h * 0.16)
	d.polygon([(x0, y0), (x1, y0), (x1, y1 - notch), (x0 + w // 2, y1), (x0, y1 - notch)], fill=cloth)
	for i, t in enumerate((0.25, 0.55, 0.8)):
		fx = x0 + int(w * t)
		d.line([(fx, y0), (fx, y1 - notch + int(notch * abs(t - 0.5)))], fill=cloth_dark, width=5)
	# Gold edge trim.
	d.line([(x0, y0), (x1, y0)], fill=BRASS, width=4)
	d.line([(x0, y0), (x0, y1 - notch)], fill=BRASS, width=4)
	d.line([(x1, y0), (x1, y1 - notch)], fill=BRASS, width=4)
	# Emblem: small gear on the cloth.
	draw_gear(d, x0 + w // 2, y0 + int(h * 0.38), int(w * 0.24), 8, cloth_dark, BRASS)


def draw_lantern(base, cx, cy, scale=1.0):
	"""Brass lantern with a warm glow."""
	s = scale
	glow_r = int(70 * s)
	glow = radial_glow((glow_r * 2, glow_r * 2), GOLD, 150)
	base.alpha_composite(glow, (cx - glow_r, cy - glow_r))
	d = ImageDraw.Draw(base)
	w, h = int(18 * s), int(30 * s)
	d.polygon([(cx, cy - h - int(10 * s)), (cx - w, cy - h // 2), (cx - w, cy + h // 2),
			   (cx, cy + h // 2 + int(8 * s)), (cx + w, cy + h // 2), (cx + w, cy - h // 2)],
			  fill=BRASS_DARK)
	d.rectangle([cx - w + 5, cy - h // 2 + 4, cx + w - 5, cy + h // 2 - 4], fill=GOLD)
	d.rectangle([cx - w + 5, cy - h // 2 + 4, cx + w - 5, cy + h // 2 - 4], outline=INK, width=2)
	d.line([(cx, cy - h // 2), (cx, cy + h // 2)], fill=INK, width=2)


def main():
	# --- Back wall: warm wood panelling, darker toward the ceiling. ---
	img = vgrad((W, H), (58, 38, 22), (112, 76, 44)).convert("RGBA")
	d = ImageDraw.Draw(img)
	wall_bottom = int(H * 0.46)
	plank_lines(d, (0, 0, W, wall_bottom), 86, (24, 14, 10), horizontal=False)
	# Dado rail and cornice in brass.
	d.rectangle([0, wall_bottom - 14, W, wall_bottom - 6], fill=BRASS_DARK)
	d.rectangle([0, int(H * 0.02), W, int(H * 0.02) + 8], fill=BRASS_DARK)

	# --- Windows with golden-hour light. ---
	win_glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
	for cx in (int(W * 0.32), int(W * 0.5), int(W * 0.68)):
		g = radial_glow((int(W * 0.30), int(H * 0.75)), (247, 201, 107), 165)
		win_glow.alpha_composite(g, (cx - int(W * 0.15), int(H * 0.02)))
	img.alpha_composite(win_glow)
	for cx in (int(W * 0.32), int(W * 0.5), int(W * 0.68)):
		draw_arch_window(img, cx, int(H * 0.045), int(W * 0.085), int(H * 0.30),
						 (40, 26, 16), (252, 214, 130), (214, 128, 54))

	# Wall-mounted brass gears and pipes between the windows.
	for gx, gy, gr in ((int(W * 0.14), int(H * 0.18), 64), (int(W * 0.86), int(H * 0.18), 64),
					   (int(W * 0.205), int(H * 0.30), 36), (int(W * 0.795), int(H * 0.30), 36)):
		draw_gear(d, gx, gy, gr, 10, WOOD_DARK, BRASS_DARK)
	d.line([(0, int(H * 0.38)), (W, int(H * 0.38))], fill=BRASS_DARK, width=10)
	d.line([(0, int(H * 0.38) - 5), (W, int(H * 0.38) - 5)], fill=BRASS, width=3)

	# --- Hall floor visible beyond the deck corners. ---
	floor = vgrad((W, H - wall_bottom), WOOD_DARK, (24, 15, 10)).convert("RGBA")
	img.paste(floor, (0, wall_bottom))
	d = ImageDraw.Draw(img)
	plank_lines(d, (0, wall_bottom, W, H), 54, (18, 11, 8), horizontal=True)

	# --- The training deck platform (rounded, like the courtyard). ---
	deck = Image.new("RGBA", (W, H), (0, 0, 0, 0))
	dd = ImageDraw.Draw(deck)
	deck_box = (int(W * 0.012), int(H * 0.30), int(W * 0.988), int(H * 1.06))
	radius = int(H * 0.34)
	dd.rounded_rectangle(deck_box, radius=radius, fill=(172, 130, 78))
	# Plank shading: alternating warm horizontal bands with dark gaps.
	py = deck_box[1] + 30
	while py < deck_box[3]:
		band = lerp((150, 110, 64), (206, 164, 106), 0.5 + 0.30 * math.sin(py * 0.11))
		dd.rectangle([deck_box[0], py, deck_box[2], py + 26], fill=band)
		dd.line([(deck_box[0], py), (deck_box[2], py)], fill=(96, 68, 40), width=3)
		py += 30
	# Re-clip to the rounded shape.
	clip = Image.new("L", (W, H), 0)
	cd = ImageDraw.Draw(clip)
	cd.rounded_rectangle(deck_box, radius=radius, fill=255)
	deck.putalpha(clip)
	img.alpha_composite(deck)
	wood_grain(img, (deck_box[0], deck_box[1], deck_box[2], min(deck_box[3], H)))
	d = ImageDraw.Draw(img)

	# Deck edge: dark rim + brass trim + inner inlay lines (echoes the courtyard mat).
	dd_box = deck_box
	d.rounded_rectangle(dd_box, radius=radius, outline=INK, width=10)
	inner = (dd_box[0] + 18, dd_box[1] + 18, dd_box[2] - 18, dd_box[3] - 18)
	d.rounded_rectangle(inner, radius=radius - 18, outline=BRASS, width=5)
	mat = (int(W * 0.20), int(H * 0.40), int(W * 0.80), int(H * 0.98))
	d.rounded_rectangle(mat, radius=26, outline=BRASS_DARK, width=4)
	d.line([(mat[0], mat[1]), (dd_box[0] + 26, dd_box[1] + 26)], fill=BRASS_DARK, width=4)
	d.line([(mat[2], mat[1]), (dd_box[2] - 26, dd_box[1] + 26)], fill=BRASS_DARK, width=4)

	# --- Light beams from the windows falling onto the deck. ---
	beams = Image.new("RGBA", (W, H), (0, 0, 0, 0))
	bd = ImageDraw.Draw(beams)
	for cx in (int(W * 0.32), int(W * 0.5), int(W * 0.68)):
		bd.polygon([(cx - int(W * 0.035), int(H * 0.10)), (cx + int(W * 0.035), int(H * 0.10)),
					(cx + int(W * 0.10), int(H * 0.95)), (cx - int(W * 0.10), int(H * 0.95))],
				   fill=(247, 201, 107, 42))
	img.alpha_composite(beams.filter(ImageFilter.GaussianBlur(14)))
	# Warm light pool at deck centre.
	pool = radial_glow((int(W * 0.7), int(H * 0.8)), (247, 201, 107), 46)
	img.alpha_composite(pool, (int(W * 0.5) - int(W * 0.35), int(H * 0.65) - int(H * 0.4)))
	d = ImageDraw.Draw(img)

	# --- Sparring circles (teal left, crimson right) with gear emblems. ---
	for cx, col, col_dark in ((int(W * 0.115), TEAL, TEAL_DARK), (int(W * 0.885), CRIMSON, CRIMSON_DARK)):
		cy, r = int(H * 0.56), int(W * 0.052)
		d.ellipse([cx - r - 8, cy - r - 8, cx + r + 8, cy + r + 8], fill=INK)
		d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=col)
		d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=BRASS, width=5)
		d.ellipse([cx - int(r * 0.72), cy - int(r * 0.72), cx + int(r * 0.72), cy + int(r * 0.72)],
				  outline=col_dark, width=4)
		draw_gear(d, cx, cy, int(r * 0.42), 8, col_dark, BRASS)
		# Steps down from the circle.
		d.rectangle([cx - int(r * 0.5), cy + r + 8, cx + int(r * 0.5), cy + r + 26], fill=col_dark)
		d.line([(cx - int(r * 0.5), cy + r + 16), (cx + int(r * 0.5), cy + r + 16)], fill=INK, width=2)

	# --- Back railing with finialed posts. ---
	rail_y = int(H * 0.30)
	d.line([(int(W * 0.05), rail_y), (int(W * 0.95), rail_y)], fill=BRASS_DARK, width=8)
	d.line([(int(W * 0.05), rail_y - 3), (int(W * 0.95), rail_y - 3)], fill=BRASS, width=3)
	for i in range(13):
		px = int(W * (0.055 + 0.89 * i / 12))
		d.line([(px, rail_y - 34), (px, rail_y + 16)], fill=BRASS_DARK, width=7)
		d.polygon([(px, rail_y - 50), (px - 6, rail_y - 32), (px + 6, rail_y - 32)], fill=BRASS)

	# --- Banners: teal left, crimson right. ---
	draw_banner(img, int(W * 0.035), int(H * 0.16), int(W * 0.042), int(H * 0.34), TEAL, TEAL_DARK)
	draw_banner(img, int(W * 0.923), int(H * 0.16), int(W * 0.042), int(H * 0.34), CRIMSON, CRIMSON_DARK)

	# --- Chandelier glow at top centre. ---
	chand = radial_glow((int(W * 0.34), int(H * 0.6)), GOLD, 150)
	img.alpha_composite(chand, (int(W * 0.5) - int(W * 0.17), -int(H * 0.18)))
	d = ImageDraw.Draw(img)
	d.line([(int(W * 0.5), 0), (int(W * 0.5), int(H * 0.075))], fill=BRASS_DARK, width=5)
	d.ellipse([int(W * 0.5) - 60, int(H * 0.075) - 12, int(W * 0.5) + 60, int(H * 0.075) + 12],
			  outline=BRASS, width=6)
	for i in range(5):
		lx = int(W * 0.5) - 48 + i * 24
		d.ellipse([lx - 5, int(H * 0.075) - 22, lx + 5, int(H * 0.075) - 8], fill=GOLD)

	# --- Lanterns at the front corners of the deck. ---
	draw_lantern(img, int(W * 0.085), int(H * 0.80), 1.1)
	draw_lantern(img, int(W * 0.915), int(H * 0.80), 1.1)

	# --- Atmosphere: vignette, warm grade, grain, soft blur. ---
	vignette = Image.new("L", (W, H), 130)
	vd = ImageDraw.Draw(vignette)
	vd.ellipse([-W * 0.25, -H * 0.55, W * 1.25, H * 1.45], fill=250)
	vignette = vignette.filter(ImageFilter.GaussianBlur(120))
	dark = Image.new("RGBA", (W, H), (20, 12, 7, 255))
	img = Image.composite(img, dark, vignette)

	grain = Image.effect_noise((W, H), 22).convert("L")
	grain_rgb = Image.merge("RGBA", (grain, grain, grain, grain.point(lambda p: 14)))
	img = Image.alpha_composite(img, grain_rgb)
	img = img.filter(ImageFilter.GaussianBlur(1.1))

	img.convert("RGB").save(OUT, optimize=True)
	print(f"wrote {OUT} ({W}x{H})")


if __name__ == "__main__":
	main()
