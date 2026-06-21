# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""InstrumentCard — the SHARED instrument-reading widget (explorer ↔ simulator).

A read-only card that shows an operating value coloured by its range status,
a min/ideal/max gauge (healthy band + ideal mark + value marker), and a
provenance badge (🟦 sheet / 🟨 researched, with confidence/citation tooltip).

``range_status`` is pure (no Qt) and carries the same in/warn/alert semantics as
the pH status slice — it is unit-tested independently and reused by the gauge.
"""

from __future__ import annotations

from PySide6.QtCore import Qt, QRectF
from PySide6.QtGui import QColor, QFont, QPainter, QBrush, QPen
from PySide6.QtWidgets import QWidget, QVBoxLayout, QLabel, QSizePolicy

# --- Status semantics --------------------------------------------------------
Status = str  # "ok" | "warn" | "alert" | "n/a"

STATUS_COLOR: dict[str, str] = {
    "ok": "#16a34a",     # 🟢 verde — en rango
    "warn": "#d97706",   # 🟡 ámbar — advertencia (borde)
    "alert": "#dc2626",  # 🔴 rojo — fuera de rango
    "n/a": "#64748b",    # ⚪ gris — sin rango / sin valor
}

SOURCE_BADGE: dict[str, str] = {
    "sheet": "🟦 sheet",
    "researched": "🟨 researched",
    "experiment": "🟩 experiment",
    "agronomist": "🟪 agronomist",
}

DEFAULT_WARN_BAND = 0.08  # 8% del rango cerca de cada borde -> "warn"


def range_status(
    value: float | None,
    lo: float | None,
    hi: float | None,
    ideal: float | None = None,
    warn_band: float = DEFAULT_WARN_BAND,
) -> Status:
    """Clasifica ``value`` contra el rango [lo, hi].

    - Sin valor o sin rango completo (lo/hi None) -> "n/a".
    - Fuera de [lo, hi] -> "alert".
    - Dentro pero a <= warn_band del borde (o exactamente en el borde) -> "warn".
    - Resto del rango interior -> "ok".

    ``warn_band`` es la fracción del ancho del rango considerada "borde". Para un
    rango degenerado (lo == hi) sólo el valor exacto es "ok".
    """
    if value is None or lo is None or hi is None:
        return "n/a"

    if value < lo or value > hi:
        return "alert"

    span = hi - lo
    if span <= 0:
        # Rango puntual: exacto -> ok; ya sabemos lo<=value<=hi => value==lo.
        return "ok"

    margin = span * warn_band
    if value <= lo + margin or value >= hi - margin:
        return "warn"
    return "ok"


# --- Gauge -------------------------------------------------------------------
class _RangeGauge(QWidget):
    """Barra horizontal: banda saludable + marca del ideal + marcador del valor."""

    def __init__(self, value, lo, hi, ideal, status, parent=None):
        super().__init__(parent)
        self._value = value
        self._lo = lo
        self._hi = hi
        self._ideal = ideal
        self._status = status
        self.setMinimumHeight(22)
        self.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

    def paintEvent(self, _event):  # noqa: N802 (Qt override)
        p = QPainter(self)
        p.setRenderHint(QPainter.Antialiasing)
        w = self.width()
        h = self.height()
        track_h = 8
        y = (h - track_h) / 2

        # Track de fondo.
        p.setPen(Qt.NoPen)
        p.setBrush(QBrush(QColor("#e2e8f0")))
        p.drawRoundedRect(QRectF(0, y, w, track_h), 4, 4)

        if self._lo is None or self._hi is None or self._hi <= self._lo:
            p.end()
            return

        span = self._hi - self._lo
        # Banda saludable = todo el rango [lo, hi] (con padding visual de 8%).
        pad = 0.08
        band_x0 = w * pad
        band_w = w * (1 - 2 * pad)
        p.setBrush(QBrush(QColor("#bbf7d0")))  # verde claro
        p.drawRoundedRect(QRectF(band_x0, y, band_w, track_h), 4, 4)

        def to_x(v):
            frac = (v - self._lo) / span
            frac = max(0.0, min(1.0, frac))
            return band_x0 + frac * band_w

        # Marca del ideal (línea punteada).
        if self._ideal is not None and self._lo <= self._ideal <= self._hi:
            ix = to_x(self._ideal)
            pen = QPen(QColor("#15803d"), 1, Qt.DashLine)
            p.setPen(pen)
            p.drawLine(int(ix), int(y - 3), int(ix), int(y + track_h + 3))
            p.setPen(Qt.NoPen)

        # Marcador del valor.
        if self._value is not None:
            vx = to_x(self._value)
            color = QColor(STATUS_COLOR.get(self._status, "#64748b"))
            p.setBrush(QBrush(color))
            r = 6
            p.drawEllipse(QRectF(vx - r, h / 2 - r, 2 * r, 2 * r))
        p.end()


# --- Card --------------------------------------------------------------------
class InstrumentCard(QWidget):
    """Tarjeta-instrumento solo-lectura.

    Args:
        label: nombre del setpoint (ej. "pH", "EC").
        value: valor operativo (num) o None.
        unit: unidad a mostrar.
        lo/hi/ideal: límites del rango y el ideal (opcionales).
        source: provenance ("sheet"/"researched"/…).
        confidence/citation: para el tooltip del badge.
        warn_band: fracción de borde para el status (ver range_status).
    """

    def __init__(
        self,
        label: str,
        value: float | None,
        unit: str = "",
        lo: float | None = None,
        hi: float | None = None,
        ideal: float | None = None,
        source: str | None = None,
        confidence: str | None = None,
        citation: str | None = None,
        warn_band: float = DEFAULT_WARN_BAND,
        parent=None,
    ):
        super().__init__(parent)
        self._label = label
        self._value = value
        self._unit = unit
        self._lo = lo
        self._hi = hi
        self._ideal = ideal
        self._source = source
        self._confidence = confidence
        self._citation = citation
        self.status = range_status(value, lo, hi, ideal, warn_band)

        self._build()

    # --- text helpers (also used by tests) ---
    def value_text(self) -> str:
        if self._value is None:
            return "—"
        v = self._value
        txt = f"{v:g}"
        return f"{txt} {self._unit}".strip()

    def range_text(self) -> str:
        def fmt(x):
            return "—" if x is None else f"{x:g}"
        if self._lo is None and self._hi is None and self._ideal is None:
            return "sin rango"
        return f"mín {fmt(self._lo)} · ideal {fmt(self._ideal)} · máx {fmt(self._hi)}"

    def badge_text(self) -> str:
        if not self._source:
            return ""
        return SOURCE_BADGE.get(self._source, self._source)

    def _build(self):
        color = STATUS_COLOR.get(self.status, "#64748b")
        self.setStyleSheet(
            "InstrumentCard { background:#ffffff; border:1px solid #e2e8f0;"
            f" border-left:4px solid {color}; border-radius:6px; }}"
        )
        lay = QVBoxLayout(self)
        lay.setContentsMargins(10, 8, 10, 8)
        lay.setSpacing(3)

        header = QLabel(self._label)
        header.setStyleSheet("color:#475569; font-size:11px; font-weight:bold;")
        lay.addWidget(header)

        value_lbl = QLabel(self.value_text())
        vfont = QFont()
        vfont.setPointSize(18)
        vfont.setBold(True)
        value_lbl.setFont(vfont)
        value_lbl.setStyleSheet(f"color:{color};")
        lay.addWidget(value_lbl)

        gauge = _RangeGauge(self._value, self._lo, self._hi, self._ideal, self.status)
        lay.addWidget(gauge)

        range_lbl = QLabel(self.range_text())
        range_lbl.setStyleSheet("color:#64748b; font-size:10px;")
        lay.addWidget(range_lbl)

        badge = self.badge_text()
        if badge:
            badge_lbl = QLabel(badge)
            badge_lbl.setStyleSheet("color:#334155; font-size:10px;")
            tip = []
            if self._confidence:
                tip.append(f"confianza: {self._confidence}")
            if self._citation:
                tip.append(f"cita: {self._citation}")
            if tip:
                badge_lbl.setToolTip(" · ".join(tip))
            lay.addWidget(badge_lbl)
