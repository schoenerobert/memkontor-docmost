# /// script
# requires-python = ">=3.11"
# dependencies = ["pillow>=10"]
# ///
"""Memkontor-Icons: schwarzer Grund, weißes M aus geraden Strichen, Teal-Balken darunter.
Keine Schrift nötig, das M ist ein Polygon. Erzeugt die Dateien, die Docmost unter /icons erwartet.

Aufruf: uv run --script icons_erzeugen.py   (schreibt nach ./icons)
"""
import os

from PIL import Image, ImageDraw

SCHWARZ, WEISS, TEAL = (12, 12, 12, 255), (255, 255, 255, 255), (12, 154, 138, 255)
N = 1024  # groß zeichnen, dann verkleinern, damit die Kanten sauber bleiben


def icon() -> Image.Image:
    img = Image.new("RGBA", (N, N), SCHWARZ)
    d = ImageDraw.Draw(img)
    l, r, o, u, s = 0.22 * N, 0.78 * N, 0.22 * N, 0.66 * N, 0.11 * N  # Rand links, rechts, oben, unten, Strichstärke
    m = N / 2
    d.polygon([(l, u), (l, o), (l + s, o), (m, o + 0.26 * N), (r - s, o), (r, o), (r, u), (r - s, u),
               (r - s, o + 0.17 * N), (m, o + 0.40 * N), (l + s, o + 0.17 * N), (l + s, u)], fill=WEISS)
    d.rectangle([l, 0.73 * N, r, 0.78 * N], fill=TEAL)
    return img


if __name__ == "__main__":
    ziel = os.path.join(os.path.dirname(os.path.abspath(__file__)), "icons")
    os.makedirs(ziel, exist_ok=True)
    gross = icon()
    for name, px in (("favicon-16x16.png", 16), ("favicon-32x32.png", 32),
                     ("app-icon-192x192.png", 192), ("app-icon-512x512.png", 512)):
        gross.resize((px, px), Image.LANCZOS).save(os.path.join(ziel, name), optimize=True)
        print(name)
