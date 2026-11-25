"""Punto de partida del tablero. Claude Code ira construyendo sobre este archivo."""
import os
import sqlite3
from html import escape
from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import HTMLResponse

DB_PATH = os.environ.get("DB_PATH", "curso.db")
ARCHIVOS_DIR = Path(os.environ.get("ARCHIVOS_DIR", "archivos_ejemplo"))

app = FastAPI(title="Tablero del director")


@app.get("/", response_class=HTMLResponse)
def inicio():
    with sqlite3.connect(DB_PATH) as conn:
        version = conn.execute("SELECT sqlite_version()").fetchone()[0]

    archivos = sorted(
        p.relative_to(ARCHIVOS_DIR).as_posix()
        for p in ARCHIVOS_DIR.rglob("*")
        if p.is_file()
    ) if ARCHIVOS_DIR.exists() else []
    lista = "".join(f"<li>{escape(a)}</li>" for a in archivos) or "<li>(no se encontraron archivos)</li>"

    return f"""<!doctype html>
<html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Tablero del director</title></head>
<body style="font-family: system-ui, sans-serif; max-width: 720px; margin: 40px auto; padding: 0 16px">
<h1>El entorno del curso funciona</h1>
<p>Python y SQLite {escape(version)} listos. Desde aquí Claude Code construirá tu tablero.</p>
<h2>Archivos de ejemplo ({len(archivos)})</h2>
<ul>{lista}</ul>
</body></html>"""
