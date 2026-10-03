#!/bin/bash
# Procedural wallpaper and preview generator for Apex Linux themes
# Generates minimal, elegant geometric/gradient wallpapers based on each theme's colors.toml.

set -euo pipefail

APEX_PATH="${APEX_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
THEMES_DIR="$APEX_PATH/themes"

usage() {
  cat <<'USAGE'
Usage: scripts/gen-wallpapers.sh [THEME_NAME]

Procedurally generates minimal geometric/gradient wallpapers for Apex Linux themes.
If no THEME_NAME is specified, generates wallpapers and previews for all themes.

Options:
  -h, --help    Show this help message
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

TARGET_THEME="${1:-}"

export APEX_PATH THEMES_DIR TARGET_THEME

python3 - <<'PYTHON_SCRIPT'
import os
import sys
import math
from PIL import Image, ImageDraw

themes_dir = os.environ.get("THEMES_DIR", "themes")
target_theme = os.environ.get("TARGET_THEME", "").strip()

def hex_to_rgb(hex_str, default=(0, 0, 0)):
    if not hex_str:
        return default
    s = hex_str.strip().lstrip("#")
    if len(s) == 6:
        try:
            return tuple(int(s[i:i+2], 16) for i in (0, 2, 4))
        except ValueError:
            return default
    return default

def parse_colors(colors_path):
    colors = {}
    if not os.path.exists(colors_path):
        return colors
    with open(colors_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                k, v = line.split("=", 1)
                k = k.strip()
                v = v.strip().strip('"').strip("'")
                colors[k] = v
    return colors

def generate_wallpaper(colors, out_path, width=1920, height=1080):
    c_bg = hex_to_rgb(colors.get("background"), (15, 23, 42))
    c_dark = hex_to_rgb(colors.get("darker_background", colors.get("dark_background")), (2, 6, 23))
    c_accent = hex_to_rgb(colors.get("accent"), (14, 165, 233))
    c_sel = hex_to_rgb(colors.get("selection", colors.get("muted")), (30, 41, 59))
    mode = colors.get("mode", "dark")

    # Base diagonal/vertical linear gradient
    img = Image.new("RGBA", (width, height))
    draw = ImageDraw.Draw(img)

    for y in range(height):
        ratio = y / height
        r = int(c_dark[0] * (1 - ratio) + c_bg[0] * ratio)
        g = int(c_dark[1] * (1 - ratio) + c_bg[1] * ratio)
        b = int(c_dark[2] * (1 - ratio) + c_bg[2] * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))

    # Geometric layer
    geo = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(geo)

    alpha_base = 35 if mode == "dark" else 25
    alpha_bright = 55 if mode == "dark" else 40

    # Modern angled chevron/facets
    cx, cy = int(width * 0.62), int(height * 0.48)
    
    # Layer 1: Selection shadow accent
    gdraw.polygon([
        (cx - 400, cy + 450),
        (cx + 80, cy - 380),
        (cx + 420, cy - 250),
        (cx - 50, cy + 550)
    ], fill=(c_sel[0], c_sel[1], c_sel[2], alpha_base))

    # Layer 2: Main primary accent facet
    gdraw.polygon([
        (cx - 280, cy + 380),
        (cx + 120, cy - 300),
        (cx + 340, cy - 200),
        (cx - 20, cy + 440)
    ], fill=(c_accent[0], c_accent[1], c_accent[2], alpha_base + 10))

    # Layer 3: High-contrast inner peak
    gdraw.polygon([
        (cx - 150, cy + 220),
        (cx + 160, cy - 200),
        (cx + 260, cy - 140),
        (cx + 10, cy + 280)
    ], fill=(c_accent[0], c_accent[1], c_accent[2], alpha_bright))

    # Subtle apex triangle emblem near center-top
    tx, ty = int(width * 0.5), int(height * 0.35)
    gdraw.polygon([
        (tx, ty - 60),
        (tx - 60, ty + 50),
        (tx + 60, ty + 50)
    ], fill=(c_accent[0], c_accent[1], c_accent[2], alpha_bright))

    # Combine layers
    final = Image.alpha_composite(img, geo)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    final.convert("RGB").save(out_path, "PNG", optimize=True)

def generate_preview(colors, wallpaper_path, preview_path, width=600, height=400):
    if not os.path.exists(wallpaper_path):
        return
    wp = Image.open(wallpaper_path).resize((width, height), Image.Resampling.LANCZOS)
    draw = ImageDraw.Draw(wp, "RGBA")

    c_bg = hex_to_rgb(colors.get("background"), (15, 23, 42))
    c_dark = hex_to_rgb(colors.get("darker_background", colors.get("dark_background")), (2, 6, 23))
    c_accent = hex_to_rgb(colors.get("accent"), (14, 165, 233))
    c_fg = hex_to_rgb(colors.get("foreground"), (226, 232, 240))
    c_muted = hex_to_rgb(colors.get("muted"), (71, 85, 105))

    # Draw simulated top bar
    bar_height = 24
    draw.rectangle([(0, 0), (width, bar_height)], fill=(c_dark[0], c_dark[1], c_dark[2], 230))
    # Workspaces
    for i in range(5):
        wx = 12 + i * 16
        col = (c_accent[0], c_accent[1], c_accent[2], 255) if i == 0 else (c_muted[0], c_muted[1], c_muted[2], 180)
        draw.ellipse([(wx, 8), (wx + 8, 16)], fill=col)
    
    # Active app pill in top bar
    draw.rounded_rectangle([(int(width * 0.42), 4), (int(width * 0.58), 20)], radius=4, fill=(c_bg[0], c_bg[1], c_bg[2], 200))

    # Simulated floating terminal window
    win_x1, win_y1 = 60, 55
    win_x2, win_y2 = 540, 355
    draw.rounded_rectangle([(win_x1, win_y1), (win_x2, win_y2)], radius=8, fill=(c_dark[0], c_dark[1], c_dark[2], 240), outline=(c_accent[0], c_accent[1], c_accent[2], 220), width=2)
    # Window title bar
    draw.rounded_rectangle([(win_x1, win_y1), (win_x2, win_y1 + 26)], radius=8, fill=(c_bg[0], c_bg[1], c_bg[2], 255))
    # Terminal text lines
    draw.rectangle([(win_x1 + 16, win_y1 + 42), (win_x1 + 160, win_y1 + 50)], fill=(c_accent[0], c_accent[1], c_accent[2], 255))
    draw.rectangle([(win_x1 + 16, win_y1 + 58), (win_x1 + 280, win_y1 + 66)], fill=(c_fg[0], c_fg[1], c_fg[2], 200))
    draw.rectangle([(win_x1 + 16, win_y1 + 74), (win_x1 + 220, win_y1 + 82)], fill=(c_muted[0], c_muted[1], c_muted[2], 180))
    draw.rectangle([(win_x1 + 16, win_y1 + 90), (win_x1 + 340, win_y1 + 98)], fill=(c_fg[0], c_fg[1], c_fg[2], 220))

    wp.convert("RGB").save(preview_path, "PNG", optimize=True)

theme_list = [target_theme] if target_theme else sorted(os.listdir(themes_dir))

for t in theme_list:
    tdir = os.path.join(themes_dir, t)
    cpath = os.path.join(tdir, "colors.toml")
    if not os.path.isdir(tdir) or not os.path.exists(cpath):
        continue

    colors = parse_colors(cpath)
    wp_path = os.path.join(tdir, "backgrounds", "wallpaper.png")
    prev_path = os.path.join(tdir, "preview.png")

    print(f"Generating wallpaper and preview for: {t}")
    generate_wallpaper(colors, wp_path)
    generate_preview(colors, wp_path, prev_path)

print("All wallpapers and previews successfully generated.")
PYTHON_SCRIPT
