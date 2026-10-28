#!/usr/bin/env python3
"""Generate the game's diagrams as SVG files in `images/`.

Usage: python scripts/make_diagrams.py

Regions are boolean expressions over named shapes, e.g. AND(S("A"), OR(S("B"), S("C"))), and
are shaded exactly using nested SVG masks. Images only carry language-neutral math labels:
explanations belong in the (translatable) level text around them.
"""
import math
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "images"

INK = "#1e293b"        # outlines and labels
SHADE = "#93c5fd"      # the region a diagram is about
SHADE_DARK = "#3b82f6"
HIGHLIGHT = "#fcd34d"  # a distinguished member, e.g. one set of a family
FAINT = "#e2e8f0"
CARD = "#ffffff"
SERIF = "'Latin Modern Math', 'STIX Two Math', 'Cambria Math', 'Times New Roman', serif"


# Region expressions -----------------------------------------------------------------------

def S(name): return ("S", name)
def AND(*xs): return ("and",) + xs
def OR(*xs): return ("or",) + xs
def NOT(x): return ("not", x)
def DIFF(a, b): return ("diff", a, b)


class Panel:
    """A drawing area with named shapes, placed at an offset inside a Figure."""

    def __init__(self, fig, x, y, w, h, universe=True):
        self.fig, self.x, self.y, self.w, self.h = fig, x, y, w, h
        self.shapes = {}
        if universe:
            self.shapes["U"] = lambda attrs: (
                f'<rect x="{x + 6}" y="{y + 6}" width="{w - 12}" height="{h - 12}" rx="6" {attrs}/>')

    def circle(self, name, cx, cy, r):
        cx, cy = self.x + cx, self.y + cy
        self.shapes[name] = lambda attrs: f'<circle cx="{cx}" cy="{cy}" r="{r}" {attrs}/>'

    def ellipse(self, name, cx, cy, rx, ry, angle=0):
        cx, cy = self.x + cx, self.y + cy
        self.shapes[name] = lambda attrs: (
            f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" '
            f'transform="rotate({angle} {cx} {cy})" {attrs}/>')

    def render(self, expr, fill):
        kind = expr[0]
        if kind == "S":
            return self.shapes[expr[1]](f'fill="{fill}"')
        if kind == "or":
            return "".join(self.render(e, fill) for e in expr[1:])
        if kind == "and":
            out = self.render(expr[1], fill)
            for e in expr[2:]:
                out = f'<g mask="url(#{self.mask(e)})">{out}</g>'
            return out
        if kind == "not":
            return self.render(DIFF(S("U"), expr[1]), fill)
        if kind == "diff":
            inverse = self.fig.new_mask(self.render(S("U"), "white") + self.render(expr[2], "black"))
            return f'<g mask="url(#{inverse})">{self.render(expr[1], fill)}</g>'
        raise ValueError(kind)

    def mask(self, expr):
        return self.fig.new_mask(self.render(expr, "white"))

    def shade(self, expr, fill=SHADE):
        self.fig.body.append(self.render(expr, fill))

    def outline(self, *names, dashed=False, width=2):
        dash = ' stroke-dasharray="6 5"' if dashed else ""
        for n in names:
            self.fig.body.append(self.shapes[n](f'fill="none" stroke="{INK}" stroke-width="{width}"{dash}'))

    def label(self, x, y, text, size=22, italic=True, anchor="middle", color=INK):
        style = ' font-style="italic"' if italic else ""
        self.fig.body.append(
            f'<text x="{self.x + x}" y="{self.y + y}" font-family="{SERIF}" font-size="{size}"'
            f'{style} text-anchor="{anchor}" dominant-baseline="middle" fill="{color}">{text}</text>')

    def dot(self, x, y, name="x"):
        self.fig.body.append(f'<circle cx="{self.x + x}" cy="{self.y + y}" r="4.5" fill="{INK}"/>')
        self.label(x + 13, y - 1, name, size=20)

    def universe_label(self):
        self.label(22, 24, "U", size=20)


class Figure:
    def __init__(self, w, h):
        self.w, self.h, self.defs, self.body, self.n = w, h, [], [], 0

    def new_mask(self, content):
        self.n += 1
        mid = f"m{self.n}"
        self.defs.append(f'<mask id="{mid}" maskUnits="userSpaceOnUse" x="0" y="0" '
                         f'width="{self.w}" height="{self.h}">{content}</mask>')
        return mid

    def panel(self, x, y, w, h, universe=True):
        return Panel(self, x, y, w, h, universe)

    def text(self, x, y, text, size=26):
        self.body.append(f'<text x="{x}" y="{y}" font-family="{SERIF}" font-size="{size}" '
                         f'text-anchor="middle" dominant-baseline="middle" fill="{INK}">{text}</text>')

    def arrow(self, x1, y1, x2, y2, label=None):
        self.body.append(f'<line x1="{x1}" y1="{y1}" x2="{x2 - 8}" y2="{y2}" stroke="{INK}" stroke-width="2"/>'
                         f'<path d="M{x2},{y2} l-11,-6 v12 z" fill="{INK}"/>')
        if label:
            self.text((x1 + x2) / 2, y1 - 16, label, size=20)

    def svg(self):
        return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" height="{self.h}" '
                f'viewBox="0 0 {self.w} {self.h}">'
                f'<defs>{"".join(self.defs)}</defs>'
                f'<rect width="{self.w}" height="{self.h}" rx="14" fill="{CARD}"/>'
                f'{"".join(self.body)}</svg>\n')


# Shared layouts ---------------------------------------------------------------------------

def two_sets(p, cx, cy, r, gap):
    p.circle("A", cx - gap, cy, r)
    p.circle("B", cx + gap, cy, r)


def three_sets(p, cx, cy, r, spread):
    p.circle("A", cx, cy - spread * 0.62, r)
    p.circle("B", cx - spread * 0.62, cy + spread * 0.42, r)
    p.circle("C", cx + spread * 0.62, cy + spread * 0.42, r)


def flower(p, cx, cy, n, rx, ry, d, prefix="t", start=-90):
    """n overlapping ellipses around a common centre: a family of sets with a nonempty core."""
    names = []
    for i in range(n):
        a = start + 360 * i / n
        ex, ey = cx + d * math.cos(math.radians(a)), cy + d * math.sin(math.radians(a))
        name = f"{prefix}{i}"
        p.ellipse(name, ex, ey, rx, ry, a)
        names.append(name)
    return names


def label_three(p, cx, cy, spread, r, size=22):
    p.label(cx, cy - spread * 0.62 - r - 12, "A", size=size)
    p.label(cx - spread * 0.62 - r * 0.92, cy + spread * 0.42 + r * 0.9, "B", size=size)
    p.label(cx + spread * 0.62 + r * 0.92, cy + spread * 0.42 + r * 0.9, "C", size=size)


# World images (480 x 270, shown behind the proof while playing) ----------------------------

def world_subset():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    p.circle("B", 255, 140, 100); p.circle("A", 225, 150, 48)
    p.shade(S("B"), FAINT); p.shade(S("A"))
    p.outline("U", "B", "A"); p.universe_label()
    p.label(225, 126, "A"); p.label(348, 58, "B"); p.dot(215, 162)
    return f


def world_complement():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    p.circle("A", 240, 140, 80)
    p.shade(NOT(S("A"))); p.outline("U", "A"); p.universe_label()
    p.label(240, 140, "A", size=28); p.label(400, 225, "Aᶜ", size=26)
    return f


def world_intersection():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    two_sets(p, 240, 140, 85, 50)
    p.shade(AND(S("A"), S("B"))); p.outline("U", "A", "B"); p.universe_label()
    p.label(150, 140, "A", size=28); p.label(330, 140, "B", size=28)
    return f


def world_union():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    two_sets(p, 240, 140, 85, 50)
    p.shade(OR(S("A"), S("B"))); p.outline("U", "A", "B"); p.universe_label()
    p.label(150, 140, "A", size=28); p.label(330, 140, "B", size=28)
    return f


def world_combination():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    three_sets(p, 240, 145, 68, 72)
    p.shade(AND(S("A"), OR(S("B"), S("C")))); p.outline("U", "A", "B", "C"); p.universe_label()
    label_three(p, 240, 145, 72, 68)
    return f


def family_panel(p, cx, cy, n=5, rx=72, ry=38, d=38):
    names = flower(p, cx, cy, n, rx, ry, d)
    return names


def world_faminter():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    names = family_panel(p, 230, 140)
    p.shade(AND(*[S(n) for n in names])); p.outline("U"); p.outline(*names, width=1.6)
    p.universe_label(); p.label(420, 135, "⋂₀F", size=26, italic=False); p.label(420, 170, "…", size=24, italic=False)
    return f


def world_famunion():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    names = family_panel(p, 230, 140)
    p.shade(OR(*[S(n) for n in names])); p.outline("U"); p.outline(*names, width=1.6)
    p.universe_label(); p.label(420, 135, "⋃₀F", size=26, italic=False); p.label(420, 170, "…", size=24, italic=False)
    return f


def world_famcombo():
    f = Figure(480, 270)
    bag = f.panel(14, 40, 170, 190, universe=False)
    f.body.append(f'<rect x="20" y="46" width="158" height="178" rx="22" fill="none" '
                  f'stroke="{INK}" stroke-width="2" stroke-dasharray="7 6"/>')
    blobs = [(60, 60, 34, 22, -20), (112, 92, 30, 20, 25), (66, 132, 32, 21, 10)]
    for i, (x, y, rx, ry, a) in enumerate(blobs):
        bag.ellipse(f"b{i}", x, y, rx, ry, a)
        bag.shade(S(f"b{i}"), SHADE); bag.outline(f"b{i}", width=1.6)
    bag.label(132, 160, "F", size=24)
    f.arrow(196, 135, 262, 135, "⋃₀")
    p = f.panel(270, 20, 196, 230)
    for i, (x, y, rx, ry, a) in enumerate([(70, 80, 40, 26, -20), (110, 110, 36, 24, 25), (78, 150, 38, 25, 10)]):
        p.ellipse(f"c{i}", x, y, rx, ry, a)
    p.shade(OR(S("c0"), S("c1"), S("c2"))); p.outline("U"); p.outline("c0", "c1", "c2", width=1.6)
    p.universe_label(); p.label(150, 200, "⋃₀F", size=22, italic=False)
    return f


def world_difference():
    f = Figure(480, 270); p = f.panel(0, 0, 480, 270)
    two_sets(p, 240, 140, 85, 50)
    p.shade(DIFF(S("A"), S("B"))); p.outline("U", "A", "B"); p.universe_label()
    p.label(150, 140, "A", size=28); p.label(330, 140, "B", size=28)
    return f


# Inline diagrams (at most 400 px wide, shown in level text) --------------------------------

def subset_trans():
    f = Figure(340, 210); p = f.panel(0, 0, 340, 210)
    p.circle("C", 186, 106, 88); p.circle("B", 166, 116, 58); p.circle("A", 148, 126, 28)
    p.shade(S("C"), FAINT); p.shade(S("B"), SHADE); p.shade(S("A"), SHADE_DARK)
    p.outline("U", "C", "B", "A"); p.universe_label()
    p.label(148, 126, "A", color=CARD); p.label(166, 80, "B"); p.label(284, 32, "C")
    return f


def comp_contra():
    f = Figure(340, 210); p = f.panel(0, 0, 340, 210)
    p.circle("B", 170, 108, 80); p.circle("A", 150, 116, 38)
    p.shade(NOT(S("A")), FAINT); p.shade(NOT(S("B")))
    p.outline("U", "B", "A"); p.universe_label()
    p.label(150, 116, "A"); p.label(214, 68, "B"); p.label(300, 182, "Bᶜ")
    return f


def inter_assoc():
    f = Figure(340, 230); p = f.panel(0, 0, 340, 230)
    three_sets(p, 170, 122, 58, 56)
    p.shade(AND(S("A"), S("B"), S("C"))); p.outline("U", "A", "B", "C"); p.universe_label()
    label_three(p, 170, 122, 56, 58, size=20)
    return f


def small_two(f, x, region):
    p = f.panel(x, 10, 170, 150)
    two_sets(p, 85, 78, 44, 26)
    p.shade(region); p.outline("U", "A", "B")
    p.label(48, 78, "A", size=18); p.label(122, 78, "B", size=18)
    return p


def combo_demorgan():
    f = Figure(390, 170)
    small_two(f, 4, NOT(OR(S("A"), S("B"))))
    f.text(195, 85, "=")
    small_two(f, 216, AND(NOT(S("A")), NOT(S("B"))))
    return f


def small_three(f, x, region):
    p = f.panel(x, 6, 116, 128)
    three_sets(p, 58, 70, 28, 26)
    p.shade(region); p.outline("U", "A", "B", "C")
    return p


def combo_distrib():
    f = Figure(400, 140)
    small_three(f, 2, AND(S("A"), OR(S("B"), S("C"))))
    f.text(129, 70, "=")
    small_three(f, 141, AND(S("A"), S("B")))
    f.text(269, 70, "∪")
    small_three(f, 282, AND(S("A"), S("C")))
    return f


def faminter_member():
    f = Figure(360, 230); p = f.panel(0, 0, 360, 230)
    names = flower(p, 170, 120, 5, 60, 31, 31)
    p.shade(S(names[0]), HIGHLIGHT); p.shade(AND(*[S(n) for n in names]))
    p.outline("U"); p.outline(*names, width=1.4); p.universe_label()
    p.label(170, 40, "A", size=20); p.label(310, 120, "⋂₀F", size=22, italic=False)
    return f


def faminter_larger():
    f = Figure(400, 190)
    left = f.panel(2, 8, 192, 174)
    small = flower(left, 96, 88, 3, 46, 24, 20)
    left.shade(AND(*[S(n) for n in small])); left.outline("U"); left.outline(*small, width=1.3)
    left.label(172, 154, "F", size=20)
    right = f.panel(206, 8, 192, 174)
    big = flower(right, 96, 88, 6, 46, 24, 26)
    right.shade(AND(*[S(n) for n in big])); right.outline("U"); right.outline(*big, width=1.3)
    right.label(172, 154, "G", size=20)
    return f


def famcombo_complements():
    f = Figure(390, 170)
    left = f.panel(4, 10, 160, 150)
    left.ellipse("t", 80, 78, 48, 32, -15)
    left.shade(S("t")); left.outline("U", "t"); left.label(80, 78, "t", size=20)
    f.arrow(176, 85, 214, 85)
    right = f.panel(226, 10, 160, 150)
    right.ellipse("t", 80, 78, 48, 32, -15)
    right.shade(NOT(S("t"))); right.outline("U", "t"); right.label(80, 78, "t", size=20)
    right.label(136, 128, "tᶜ", size=20)
    return f


FIGURES = {
    "world-subset": world_subset, "world-complement": world_complement,
    "world-intersection": world_intersection, "world-union": world_union,
    "world-combination": world_combination, "world-faminter": world_faminter,
    "world-famunion": world_famunion, "world-famcombo": world_famcombo,
    "world-difference": world_difference,
    "subset-trans": subset_trans, "comp-contra": comp_contra,
    "inter-assoc": inter_assoc, "combo-demorgan": combo_demorgan, "combo-distrib": combo_distrib,
    "faminter-member": faminter_member,
    "faminter-larger": faminter_larger, "famcombo-complements": famcombo_complements,
}


def main():
    OUT.mkdir(exist_ok=True)
    for name, make in FIGURES.items():
        (OUT / f"{name}.svg").write_text(make().svg(), encoding="utf-8", newline="\n")
    print(f"wrote {len(FIGURES)} diagrams to {OUT}")


if __name__ == "__main__":
    main()
