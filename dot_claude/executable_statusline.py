#!/usr/bin/env python3
"""Claude Code Statusline - Braille dots pattern"""
import json, subprocess, sys

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

data = json.load(sys.stdin)

BRAILLE = " ⣀⣄⣤⣦⣶⣷⣿"
R = "\033[0m"
DIM = "\033[2m"


def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f"\033[38;2;{r};200;80m"
    else:
        g = int(200 - (pct - 50) * 4)
        return f"\033[38;2;255;{max(g, 0)};60m"


def braille_bar(pct, width=8):
    pct = min(max(pct, 0), 100)
    level = pct / 100
    bar = ""
    for i in range(width):
        seg_start = i / width
        seg_end = (i + 1) / width
        if level >= seg_end:
            bar += BRAILLE[7]
        elif level <= seg_start:
            bar += BRAILLE[0]
        else:
            frac = (level - seg_start) / (seg_end - seg_start)
            bar += BRAILLE[min(int(frac * 7), 7)]
    return bar


def fmt_tokens(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n / 1_000:.0f}k"
    return str(n)


def fmt(label, pct, suffix=""):
    p = round(pct)
    return f"{DIM}{label}{R} {gradient(pct)}{braille_bar(pct)}{R} {p}%{suffix}"


model = data.get("model", {}).get("display_name", "Claude")
parts = [model]

ctx_data = data.get("context_window", {})
ctx = ctx_data.get("used_percentage")
if ctx is not None:
    total_in = ctx_data.get("total_input_tokens", 0)
    total_out = ctx_data.get("total_output_tokens", 0)
    used = total_in + total_out
    parts.append(fmt("ctx", ctx, f"({fmt_tokens(used)})"))

five = data.get("rate_limits", {}).get("five_hour", {}).get("used_percentage")
if five is not None:
    parts.append(fmt("5h", five))

week = data.get("rate_limits", {}).get("seven_day", {}).get("used_percentage")
if week is not None:
    parts.append(fmt("7d", week))

try:
    branch = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True, timeout=2,
    ).stdout.strip()
    if branch:
        parts.append(f"{DIM}{branch}{R}")
except Exception:
    pass

print(f" {DIM}│{R} ".join(parts), end="")
