# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""InstrumentCard — the SHARED instrument-reading widget (explorer ↔ simulator).

A card that shows an operating value coloured by its range status, a
min/ideal/max gauge (healthy band + ideal mark + value marker), and a provenance
badge (🟦 sheet / 🟨 researched, with confidence/citation tooltip).

Two modes:
  - read-only (default): the min/ideal/max line is a static label.
  - editable (``editable=True``): min/ideal/max become spin-boxes with a save
    button; pressing it emits ``rangeEdited`` with the field names + new values
    so the host can persist an AUDITED setpoint edit.

``range_status`` is pure (no Qt) and carries the same in/warn/alert semantics as
the pH status slice — it is unit-tested independently and reused by the gauge.
Colours come from ``tokens.py`` (the Vertivo design system), not ad-hoc values.
"""

from __future__ import annotations

import os
import sys

from PySide6.QtCore import Qt, QRectF, Signal
from PySide6.QtGui import QColor, QFont, QPainter, QBrush, QPen
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QDoubleSpinBox,
    QAbstractSpinBox,
    QPushButton,
    QSizePolicy,
)

# tokens.py vive en el paquete padre (crop_explorer/); soportar import directo.
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import tokens as T  # noqa: E402

# --- Status semantics --------------------------------------------------------
Status = str  # "ok" | "warn" | "alert" | "n/a"

STATUS_COLOR: dict[str, str] = T.STATUS_COLOR

SOURCE_BADGE: dict[str, str] = {
    "sheet": "🟦 sheet",
    "researched": "🟨 researched",
    "experiment": "🟩 experiment",
    "agronomist": "🟪 agronomist",
}

DEFAULT_WARN_BAND = 0.08  # 8% del rango cerca de cada borde -> "warn"

# Sentinela para spin-boxes editables: el mínimo se muestra como "—" = sin valor.
_SPIN_NONE = -100000.0


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
    """
    if value is None or lo is None or hi is None:
        return "n/a"
    if value < lo or value > hi:
        return "alert"
    span = hi - lo
    if span <= 0:
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

        p.setPen(Qt.NoPen)
        p.setBrush(QBrush(QColor(T.TRACK)))
        p.drawRoundedRect(QRectF(0, y, w, track_h), 4, 4)

        if self._lo is None or self._hi is None or self._hi <= self._lo:
            p.end()
            return

        span = self._hi - self._lo
        pad = 0.08
        band_x0 = w * pad
        band_w = w * (1 - 2 * pad)
        p.setBrush(QBrush(QColor(T.BAND_HEALTHY)))
        p.drawRoundedRect(QRectF(band_x0, y, band_w, track_h), 4, 4)

        def to_x(v):
            frac = (v - self._lo) / span
            frac = max(0.0, min(1.0, frac))
            return band_x0 + frac * band_w

        if self._ideal is not None and self._lo <= self._ideal <= self._hi:
            ix = to_x(self._ideal)
            pen = QPen(QColor(T.IDEAL_MARK), 1, Qt.DashLine)
            p.setPen(pen)
            p.drawLine(int(ix), int(y - 3), int(ix), int(y + track_h + 3))
            p.setPen(Qt.NoPen)

        if self._value is not None:
            vx = to_x(self._value)
            color = QColor(STATUS_COLOR.get(self._status, T.STATUS_COLOR["n/a"]))
            p.setBrush(QBrush(color))
            r = 6
            p.drawEllipse(QRectF(vx - r, h / 2 - r, 2 * r, 2 * r))
        p.end()


# --- Stepper -----------------------------------------------------------------
class Stepper(QWidget):
    """Stepper numérico ``[−] valor [+]`` con botones visibles.

    Reemplaza el spinbox pelón (cuyas flechas se rompen con QSS custom) por un
    control tipo stepper: botón menos · campo (editable, sin flechas nativas) ·
    botón más. El mínimo se muestra como "—" (= sin valor); desde "—", [+] arranca
    en 0. ``value()`` devuelve None cuando está en "—".
    """

    valueChanged = Signal()

    def __init__(
        self,
        value: float | None,
        unit: str = "",
        *,
        minimum: float = _SPIN_NONE,
        maximum: float = 100000.0,
        step: float = 0.1,
        decimals: int = 2,
        parent=None,
    ):
        super().__init__(parent)
        lay = QHBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(0)
        self._minus = QPushButton("−")
        self._plus = QPushButton("+")
        self._spin = QDoubleSpinBox()
        self._spin.setButtonSymbols(QAbstractSpinBox.NoButtons)
        self._spin.setRange(minimum, maximum)
        self._spin.setDecimals(decimals)
        self._spin.setSingleStep(step)
        self._spin.setSpecialValueText("—")
        if unit:
            self._spin.setSuffix(f" {unit}")
        self._spin.setValue(minimum if value is None else float(value))
        self._spin.setAlignment(Qt.AlignCenter)

        btn_css = (
            f"QPushButton {{ background:{T.SURFACE_SUNKEN}; color:{T.TEXT};"
            f" border:1px solid {T.BORDER}; font-weight:bold; min-width:22px;"
            f" max-width:24px; padding:2px; }}"
            f" QPushButton:hover {{ background:{T.PRIMARY}; color:{T.BTN_FG}; }}"
        )
        self._minus.setStyleSheet(btn_css)
        self._plus.setStyleSheet(btn_css)
        self._spin.setStyleSheet(
            f"QDoubleSpinBox {{ border:1px solid {T.BORDER}; border-left:none;"
            f" border-right:none; padding:2px 4px; background:{T.SURFACE};"
            f" color:{T.TEXT}; }}"
        )
        self._minus.clicked.connect(lambda: self._step(-1))
        self._plus.clicked.connect(lambda: self._step(1))
        self._spin.valueChanged.connect(lambda *_: self.valueChanged.emit())
        lay.addWidget(self._minus)
        lay.addWidget(self._spin, 1)
        lay.addWidget(self._plus)
        self._spin.setMinimumWidth(96)  # espacio para "250,00 µmol/m²·s"

    def _step(self, n: int):
        if self._spin.value() == self._spin.minimum():
            # Desde "—": [+] arranca en 0; [−] se queda en "—".
            self._spin.setValue(0.0 if n > 0 else self._spin.minimum())
        else:
            self._spin.stepBy(n)

    def value(self) -> float | None:
        return None if self._spin.value() == self._spin.minimum() else self._spin.value()


# --- Card --------------------------------------------------------------------
class InstrumentCard(QWidget):
    """Tarjeta-instrumento (solo-lectura o editable).

    Args:
        label/value/unit: identidad y valor operativo.
        lo/hi/ideal: límites del rango y el ideal (opcionales).
        source/confidence/citation: provenance + tooltip del badge.
        editable: si True, min/ideal/máx son spin-boxes con botón Guardar.
        min_field/ideal_field/max_field: nombres de campo de setpoint para
            persistir la edición auditada (se emiten en ``rangeEdited``).

    Señal:
        rangeEdited(dict): {min_field, ideal_field, max_field, lo, ideal, hi}.
    """

    rangeEdited = Signal(dict)

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
        editable: bool = False,
        min_field: str | None = None,
        ideal_field: str | None = None,
        max_field: str | None = None,
        parent=None,
    ):
        super().__init__(parent)
        # Necesario para que el background/border del QSS pinte en un QWidget custom.
        self.setAttribute(Qt.WA_StyledBackground, True)
        self._label = label
        self._value = value
        self._unit = unit
        self._lo = lo
        self._hi = hi
        self._ideal = ideal
        self._source = source
        self._confidence = confidence
        self._citation = citation
        self._editable = editable
        self._min_field = min_field
        self._ideal_field = ideal_field
        self._max_field = max_field
        self.status = range_status(value, lo, hi, ideal, warn_band)
        self._build()

    # --- text helpers (also used by tests) ---
    def value_text(self) -> str:
        if self._value is None:
            return "—"
        return f"{self._value:g} {self._unit}".strip()

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
        color = STATUS_COLOR.get(self.status, T.STATUS_COLOR["n/a"])
        self.setStyleSheet(
            "InstrumentCard {"
            f" background:{T.SURFACE};"
            f" border:1px solid {T.BORDER};"
            f" border-left:4px solid {color};"
            " border-radius:8px; }"
            f" QLabel {{ font-family:'{T.FONT_FAMILY}'; }}"
        )
        lay = QVBoxLayout(self)
        lay.setContentsMargins(12, 10, 12, 10)
        lay.setSpacing(5)

        header = QLabel(self._label)
        header.setStyleSheet(
            f"color:{T.TEXT_MUTED}; font-size:11px; font-weight:bold;"
        )
        lay.addWidget(header)

        value_lbl = QLabel(self.value_text())
        vfont = QFont(T.FONT_FAMILY)
        vfont.setPointSize(18)
        vfont.setBold(True)
        value_lbl.setFont(vfont)
        value_lbl.setStyleSheet(f"color:{color};")
        lay.addWidget(value_lbl)

        gauge = _RangeGauge(self._value, self._lo, self._hi, self._ideal, self.status)
        lay.addWidget(gauge)

        if self._editable:
            self._build_editor(lay, unit=self._unit)
        else:
            range_lbl = QLabel(self.range_text())
            range_lbl.setStyleSheet(f"color:{T.TEXT_MUTED}; font-size:10px;")
            lay.addWidget(range_lbl)

        badge = self.badge_text()
        if badge:
            badge_lbl = QLabel(badge)
            badge_lbl.setStyleSheet(f"color:{T.TEXT}; font-size:10px;")
            tip = []
            if self._confidence:
                tip.append(f"confianza: {self._confidence}")
            if self._citation:
                tip.append(f"cita: {self._citation}")
            if tip:
                badge_lbl.setToolTip(" · ".join(tip))
            lay.addWidget(badge_lbl)

    def _build_editor(self, lay: QVBoxLayout, unit: str):
        """Fila editable: mín · ideal · máx (spin-boxes) + botón Guardar."""
        grid = QVBoxLayout()
        grid.setSpacing(2)
        for tag, val, attr in (
            ("mín", self._lo, "_sb_lo"),
            ("ideal", self._ideal, "_sb_ideal"),
            ("máx", self._hi, "_sb_hi"),
        ):
            row = QHBoxLayout()
            cap = QLabel(tag)
            cap.setFixedWidth(34)
            cap.setStyleSheet(f"color:{T.TEXT_MUTED}; font-size:10px;")
            row.addWidget(cap)
            sb = Stepper(val, unit)
            setattr(self, attr, sb)
            row.addWidget(sb, 1)
            grid.addLayout(row)
        lay.addLayout(grid)

        save = QPushButton("💾 Guardar rango")
        save.setStyleSheet(
            f"QPushButton {{ background:{T.BTN_BG}; color:{T.BTN_FG}; border:none;"
            f" border-radius:4px; padding:3px 8px; font-size:10px; }}"
            f" QPushButton:hover {{ background:{T.palette('primary', 30) or T.BTN_BG}; }}"
        )
        save.clicked.connect(self._emit_edit)
        lay.addWidget(save)

        # Feedback propio del card (operación ACID separada de la del negocio).
        self._feedback = QLabel("")
        self._feedback.setStyleSheet("font-size:10px;")
        lay.addWidget(self._feedback)

    def set_save_feedback(self, text: str, ok: bool = True):
        """Muestra el resultado del guardado DENTRO del card (no en otro panel)."""
        if not hasattr(self, "_feedback"):
            return
        color = STATUS_COLOR["ok"] if ok else STATUS_COLOR["alert"]
        self._feedback.setStyleSheet(f"color:{color}; font-size:10px;")
        self._feedback.setText(text)

    def _emit_edit(self):
        self.rangeEdited.emit(
            {
                "min_field": self._min_field,
                "ideal_field": self._ideal_field,
                "max_field": self._max_field,
                "lo": self._sb_lo.value(),
                "ideal": self._sb_ideal.value(),
                "hi": self._sb_hi.value(),
            }
        )
