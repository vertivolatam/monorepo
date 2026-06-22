# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""db.py — acceso de lectura/escritura a crops.db (la FUENTE DE VERDAD local).

Centraliza las consultas que usa el explorador (cultivos, setpoints activos con
provenance, nutrición) y la ESCRITURA AUDITADA de la clasificación de negocio
(``save_classification``): cambiar el perfil asignado o la prioridad de un
cultivo deja un rastro en ``setpoint_audit`` (source='experiment', supersedes,
is_active) que permite rollback. Reusa ``resolve_setpoints`` y la lógica de
discrepancias de build_db.py (single source of truth).
"""

from __future__ import annotations

import json
import sqlite3
from datetime import datetime, timezone
from pathlib import Path

from build_db import (
    PROFILE_TO_SHEET_TYPE,
    resolve_setpoints,
)

HERE = Path(__file__).resolve().parent
DEFAULT_CROPS_JSON = HERE.parent.parent / "config" / "crops.json"


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def is_discrepant(profile: str | None, sheet_type: str | None) -> bool:
    """Discrepancia = el tipo presupuesto por el perfil != el tipo de la hoja."""
    if not profile or not sheet_type:
        return False
    expected = PROFILE_TO_SHEET_TYPE.get(profile)
    return bool(expected) and expected != sheet_type


class CropDB:
    """Wrapper de conexión a crops.db con consultas y escritura auditada."""

    def __init__(self, db_path: Path, crops_json: Path | None = None):
        self.db_path = Path(db_path)
        self.conn = sqlite3.connect(str(db_path))
        self.conn.row_factory = sqlite3.Row
        self._crops_json = Path(crops_json) if crops_json else DEFAULT_CROPS_JSON
        self._profiles_cache: dict | None = None

    def close(self):
        self.conn.close()

    # --- profiles (para re-resolver setpoints al cambiar de perfil) ---
    def _profiles(self) -> dict:
        if self._profiles_cache is None:
            try:
                data = json.loads(self._crops_json.read_text(encoding="utf-8"))
                self._profiles_cache = data.get("profiles", {})
            except Exception:
                self._profiles_cache = {}
        return self._profiles_cache

    # --- lectura ---
    def crops(self) -> list[sqlite3.Row]:
        return self.conn.execute(
            "SELECT id, name_es, name_en, family, species, origin, general_use, "
            "common_use, edible_part, sheet_harvest_type, aeroponic, priority, "
            "assigned_profile FROM crops ORDER BY name_es"
        ).fetchall()

    def crop(self, crop_id: int) -> sqlite3.Row | None:
        return self.conn.execute(
            "SELECT * FROM crops WHERE id = ?", (crop_id,)
        ).fetchone()

    def active_setpoints(self, crop_id: int) -> list[sqlite3.Row]:
        """Setpoints operativos + provenance activa (setpoint_audit is_active=1)."""
        return self.conn.execute(
            """
            SELECT s.field, s.value_num, s.value_text,
                   a.source, a.confidence, a.citation, a.note,
                   a.changed_at, a.changed_by
            FROM setpoints s
            LEFT JOIN setpoint_audit a
              ON a.crop_id = s.crop_id AND a.field = s.field AND a.is_active = 1
            WHERE s.crop_id = ?
            ORDER BY s.field
            """,
            (crop_id,),
        ).fetchall()

    def nutrition(self, crop_id: int) -> list[sqlite3.Row]:
        return self.conn.execute(
            "SELECT nutrient, value_num, unit, source FROM nutrition "
            "WHERE crop_id = ? ORDER BY id",
            (crop_id,),
        ).fetchall()

    def setpoint_field(self, crop_id: int, field: str) -> sqlite3.Row | None:
        return self.conn.execute(
            "SELECT field, value_num, value_text FROM setpoints "
            "WHERE crop_id = ? AND field = ? LIMIT 1",
            (crop_id, field),
        ).fetchone()

    # --- escritura auditada ---
    def _active_audit_id(self, crop_id: int, field: str) -> int | None:
        row = self.conn.execute(
            "SELECT id FROM setpoint_audit "
            "WHERE crop_id = ? AND field = ? AND is_active = 1 LIMIT 1",
            (crop_id, field),
        ).fetchone()
        return row["id"] if row else None

    def _write_audit(
        self,
        cur: sqlite3.Cursor,
        crop_id: int,
        field: str,
        *,
        value_num: float | None,
        value_text: str | None,
        changed_by: str,
        note: str | None = None,
    ) -> int:
        """Inserta un audit source='experiment' que supersede al activo previo."""
        prior_id = self._active_audit_id(crop_id, field)
        if prior_id is not None:
            cur.execute(
                "UPDATE setpoint_audit SET is_active = 0 WHERE id = ?", (prior_id,)
            )
        cur.execute(
            "INSERT INTO setpoint_audit (crop_id, field, value_num, value_text, "
            "source, confidence, citation, note, is_active, supersedes_id, "
            "changed_at, changed_by) VALUES (?,?,?,?,?,?,?,?,1,?,?,?)",
            (
                crop_id,
                field,
                value_num,
                value_text,
                "experiment",
                None,
                None,
                note,
                prior_id,
                _now_iso(),
                changed_by,
            ),
        )
        return cur.lastrowid

    def _resync_setpoints(self, cur: sqlite3.Cursor, crop_id: int, profile_key: str):
        """Re-resuelve los setpoints de un cultivo desde su (nuevo) perfil.

        Borra los setpoints actuales y los re-inserta resueltos. Cada uno deja
        además un audit source='experiment' que supersede al activo previo
        (preserva el historial de provenance por campo)."""
        profile = self._profiles().get(profile_key)
        cur.execute("DELETE FROM setpoints WHERE crop_id = ?", (crop_id,))
        if not isinstance(profile, dict):
            return
        for sp in resolve_setpoints(profile):
            cur.execute(
                "INSERT INTO setpoints (crop_id, field, value_num, value_text) "
                "VALUES (?,?,?,?)",
                (crop_id, sp["field"], sp["value_num"], sp["value_text"]),
            )
            prior_id = self._active_audit_id(crop_id, sp["field"])
            if prior_id is not None:
                cur.execute(
                    "UPDATE setpoint_audit SET is_active = 0 WHERE id = ?", (prior_id,)
                )
            cur.execute(
                "INSERT INTO setpoint_audit (crop_id, field, value_num, value_text, "
                "source, confidence, citation, note, is_active, supersedes_id, "
                "changed_at, changed_by) VALUES (?,?,?,?,?,?,?,?,1,?,?,?)",
                (
                    crop_id,
                    sp["field"],
                    sp["value_num"],
                    sp["value_text"],
                    "experiment",
                    sp["confidence"],
                    sp["citation"],
                    f"re-resuelto por cambio de perfil -> {profile_key}",
                    prior_id,
                    _now_iso(),
                    "explorer",
                ),
            )

    def save_classification(
        self,
        crop_id: int,
        *,
        profile: str | None = None,
        priority: float | None = None,
        aeroponic: bool | None = None,
        changed_by: str = "explorer",
    ) -> bool:
        """Guarda perfil/prioridad de negocio con auditoría.

        - Si ``profile`` difiere del actual: actualiza ``crops.assigned_profile``,
          re-resuelve ``setpoints`` y escribe un audit del campo 'assigned_profile'.
        - Si ``priority`` difiere del actual: actualiza ``crops.priority`` y escribe
          un audit del campo 'priority' (setpoints intactos).
        - Cambios idénticos (no-op) no escriben nada.

        Devuelve True si hubo algún cambio persistido.
        """
        crop = self.crop(crop_id)
        if crop is None:
            raise ValueError(f"crop_id {crop_id} no existe")

        cur = self.conn.cursor()
        changed = False

        cur_profile = crop["assigned_profile"]
        if profile is not None and profile != cur_profile:
            cur.execute(
                "UPDATE crops SET assigned_profile = ? WHERE id = ?",
                (profile, crop_id),
            )
            self._write_audit(
                cur,
                crop_id,
                "assigned_profile",
                value_num=None,
                value_text=profile,
                changed_by=changed_by,
                note=f"reasignado desde '{cur_profile}'",
            )
            self._resync_setpoints(cur, crop_id, profile)
            changed = True

        cur_priority = crop["priority"]
        if priority is not None and priority != cur_priority:
            cur.execute(
                "UPDATE crops SET priority = ? WHERE id = ?", (priority, crop_id)
            )
            self._write_audit(
                cur,
                crop_id,
                "priority",
                value_num=priority,
                value_text=None,
                changed_by=changed_by,
                note=f"prioridad {cur_priority} -> {priority}",
            )
            changed = True

        cur_aero = bool(crop["aeroponic"])
        if aeroponic is not None and bool(aeroponic) != cur_aero:
            cur.execute(
                "UPDATE crops SET aeroponic = ? WHERE id = ?",
                (1 if aeroponic else 0, crop_id),
            )
            self._write_audit(
                cur,
                crop_id,
                "aeroponic",
                value_num=None,
                value_text="SI" if aeroponic else "NO",
                changed_by=changed_by,
                note=f"aptitud nebuponía {cur_aero} -> {bool(aeroponic)}",
            )
            changed = True

        if changed:
            self.conn.commit()
        return changed

    def save_setpoint_range(
        self,
        crop_id: int,
        *,
        values: dict[str, float | None],
        changed_by: str = "explorer",
    ) -> bool:
        """Edición manual AUDITADA de valores numéricos de setpoint.

        ``values`` mapea nombre-de-campo -> nuevo valor (ej.
        ``{"ph_min": 5.8, "ph_ideal": 6.2, "ph_max": 6.8}``). Cada campo que
        cambie actualiza ``setpoints`` y deja un ``setpoint_audit``
        (source='experiment', supersedes, is_active) para permitir rollback.
        Campos ``None`` de nombre se ignoran; valores idénticos no escriben.

        Devuelve True si hubo algún cambio persistido.
        """
        if self.crop(crop_id) is None:
            raise ValueError(f"crop_id {crop_id} no existe")
        cur = self.conn.cursor()
        changed = False
        for field, new_val in values.items():
            if not field:
                continue
            row = self.conn.execute(
                "SELECT value_num FROM setpoints WHERE crop_id = ? AND field = ? LIMIT 1",
                (crop_id, field),
            ).fetchone()
            cur_val = row["value_num"] if row else None
            if new_val == cur_val:
                continue
            if row is None:
                cur.execute(
                    "INSERT INTO setpoints (crop_id, field, value_num, value_text) "
                    "VALUES (?,?,?,NULL)",
                    (crop_id, field, new_val),
                )
            else:
                cur.execute(
                    "UPDATE setpoints SET value_num = ? WHERE crop_id = ? AND field = ?",
                    (new_val, crop_id, field),
                )
            self._write_audit(
                cur,
                crop_id,
                field,
                value_num=new_val,
                value_text=None,
                changed_by=changed_by,
                note=f"edición manual de rango ({cur_val} -> {new_val})",
            )
            changed = True
        if changed:
            self.conn.commit()
        return changed
