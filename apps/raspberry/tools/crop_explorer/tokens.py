# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""tokens.py — puente del design system de Vertivo (``style-dictionary/tokens.json``).

Carga los design tokens canónicos (marca morado/lima/olivo, paletas tonales,
tipografía Inter) y los expone como constantes + helpers de color para que la UI
Qt del explorador respete el MISMO sistema que el resto del producto, en vez de
colores tailwind ad-hoc. Si el JSON no se encuentra, cae a los valores de marca
por defecto (no rompe el arranque).
"""

from __future__ import annotations

import json
from pathlib import Path

_HERE = Path(__file__).resolve().parent
# crop_explorer/ -> tools/ -> raspberry/ -> apps/ -> repo-root
_CANDIDATES = [
    _HERE.parents[3] / "style-dictionary" / "tokens.json",
    _HERE.parents[2] / "vertivo_flutter" / "assets" / "style_dictionary" / "tokens.json",
]


def _load() -> dict:
    for p in _CANDIDATES:
        try:
            if p.exists():
                return json.loads(p.read_text(encoding="utf-8"))
        except Exception:
            continue
    return {}


_TOK = _load()


def _leaf(*path: str, default=None):
    node: object = _TOK
    for part in path:
        if not isinstance(node, dict):
            return default
        node = node.get(part, {})
    if isinstance(node, dict) and "value" in node:
        return node["value"]
    return default


def palette(family: str, step: int | str) -> str | None:
    """Devuelve un escalón de la paleta tonal (ej. ``palette('primary', 40)``)."""
    return _leaf("color", "palette", family, str(step))


# --- Tipografía (no cambia con el tema) --------------------------------------
FONT_FAMILY = _leaf("typography", "family", "primary", default="Inter")

# --- Estado del tema (light/dark) --------------------------------------------
# La paleta tonal de Material soporta ambos: tonos ALTOS = superficies claras /
# texto oscuro; tonos BAJOS = superficies oscuras / texto claro. set_mode()
# recalcula los tokens semánticos; STATUS_COLOR y SECTION se MUTAN in-place para
# no invalidar referencias ya importadas por los widgets.
MODE = "light"

# Botón de marca: morado fijo + texto blanco (legible sobre cualquier fondo).
BTN_BG = palette("primary", 40) or "#772583"
BTN_FG = "#FFFFFF"

# placeholders que _recompute() rellena
PRIMARY = SECONDARY = ACCENT = WARNING = ERROR = SUCCESS = "#000000"
SURFACE = SURFACE_ALT = SURFACE_SUNKEN = BORDER = TEXT = TEXT_MUTED = TRACK = "#000000"
BAND_HEALTHY = IDEAL_MARK = "#000000"
STATUS_COLOR: dict[str, str] = {}
SECTION: dict[str, tuple] = {}


def is_dark() -> bool:
    return MODE == "dark"


def _recompute():
    """Recalcula los tokens semánticos según ``MODE`` (light/dark)."""
    global PRIMARY, SECONDARY, ACCENT, WARNING, ERROR, SUCCESS
    global SURFACE, SURFACE_ALT, SURFACE_SUNKEN, BORDER, TEXT, TEXT_MUTED, TRACK
    global BAND_HEALTHY, IDEAL_MARK

    WARNING = _leaf("color", "brand", "warning", default="#FF9E1B")
    ERROR = _leaf("color", "brand", "error", default="#F4493A")

    if MODE == "dark":
        # Acentos de marca en tonos claros para contraste sobre superficie oscura.
        PRIMARY = palette("primary", 80) or "#DA99E3"
        SECONDARY = palette("secondary", 80) or "#CEDC00"
        ACCENT = palette("accent", 80) or "#AACD78"
        SUCCESS = palette("success", 70) or "#8FB35D"
        SURFACE = palette("neutral", 6) or "#141419"
        SURFACE_ALT = palette("neutral", 10) or "#1C1A1E"
        SURFACE_SUNKEN = palette("neutral", 20) or "#312F34"
        BORDER = palette("neutralVariant", 30) or "#49454E"
        TEXT = palette("neutral", 90) or "#E6E1E8"
        TEXT_MUTED = palette("neutral", 70) or "#AEAAB1"
        TRACK = palette("neutralVariant", 30) or "#49454E"
        BAND_HEALTHY = palette("accent", 30) or "#354D15"
        IDEAL_MARK = palette("accent", 70) or "#8FB35D"
        status = {
            "ok": palette("success", 70) or "#8FB35D",
            "warn": palette("warning", 70) or "#E89520",
            "alert": palette("error", 70) or "#FF897D",
            "n/a": palette("neutral", 60) or "#938F96",
        }
        section = {
            "botanic": (palette("accent", 70) or ACCENT, palette("accent", 20) or "#213409"),
            "business": (palette("primary", 70) or PRIMARY, palette("primary", 20) or "#461452"),
            "monitor": (palette("secondary", 70) or "#B0BE00", palette("secondary", 20) or "#303700"),
        }
    else:
        PRIMARY = palette("primary", 40) or "#772583"
        SECONDARY = palette("secondary", 50) or "#798500"
        ACCENT = palette("accent", 50) or "#5E7E29"
        SUCCESS = _leaf("color", "brand", "success", default="#5E7E29")
        SURFACE = palette("neutral", 100) or "#FFFFFF"
        SURFACE_ALT = palette("neutral", 98) or "#FBF6FD"
        SURFACE_SUNKEN = palette("neutral", 95) or "#F4EFF6"
        BORDER = palette("neutralVariant", 80) or "#CBC5D0"
        TEXT = palette("neutral", 10) or "#1C1A1E"
        TEXT_MUTED = palette("neutral", 50) or "#79757C"
        TRACK = palette("neutralVariant", 90) or "#E7E1EC"
        BAND_HEALTHY = palette("accent", 90) or "#C8E89A"
        IDEAL_MARK = palette("accent", 40) or "#4A661F"
        status = {
            "ok": SUCCESS,
            "warn": WARNING,
            "alert": ERROR,
            "n/a": palette("neutral", 60) or "#938F96",
        }
        section = {
            "botanic": (palette("accent", 50) or ACCENT, palette("accent", 95) or "#DFF4B8"),
            "business": (palette("primary", 50) or PRIMARY, palette("primary", 95) or "#F8E8FB"),
            "monitor": (palette("secondary", 50) or "#798500", palette("secondary", 95) or "#F2F8A0"),
        }
    # mutar in-place (preserva referencias importadas)
    STATUS_COLOR.clear()
    STATUS_COLOR.update(status)
    SECTION.clear()
    SECTION.update(section)


def set_mode(mode: str):
    """Cambia el tema ('light' | 'dark') y recalcula los tokens."""
    global MODE
    MODE = "dark" if mode == "dark" else "light"
    _recompute()


_recompute()  # inicializa en light


def groupbox_qss(section: str) -> str:
    """QSS para un ``QGroupBox`` con el color de su sección + aire bajo el título."""
    border, title_bg = SECTION.get(section, (BORDER, SURFACE_SUNKEN))
    return (
        f"QGroupBox {{ border:1px solid {border}; border-radius:8px;"
        f" margin-top:14px; background:{SURFACE}; font-weight:600; color:{TEXT};"
        f" font-family:'{FONT_FAMILY}'; }}"
        f" QGroupBox::title {{ subcontrol-origin:margin; left:10px; top:-1px;"
        f" padding:2px 8px; background:{title_bg}; border-radius:4px;"
        f" color:{TEXT}; }}"
    )
