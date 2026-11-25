# Tablero del director · Organización Ejemplo

## Reglas
- Responde siempre en español, con palabras sencillas: quien te pide las cosas no programa.
- Fecha de corte: domingo 15 de noviembre de 2026. Nunca calcules con la fecha de hoy.
- Los archivos de `archivos_ejemplo/` no se corrigen a mano: la herramienta detecta y avisa los errores.
- Las contraseñas nunca van en el código.

## Cómo trabajamos
- Lee CASOS_DE_USO.md y PLAN.md antes de empezar.
- Un paso del plan a la vez; marca [x] al terminar.
- Antes de dar algo por bueno, compáralo con el resultado esperado de su caso de uso.
- Guarda con Git cada paso que funcione, con un mensaje claro.

## El proyecto
- Aplicación web con Python, FastAPI, HTMX, Tailwind, ApexCharts y SQLite.
- Corre en Docker y se ve en http://localhost:8000. Se actualiza sola al cambiar el código.
- `app/`: el código. `data/`: la base SQLite. `archivos_ejemplo/`: los archivos del curso (solo lectura).
- Si agregas una librería: anótala en `requirements.txt` y ejecuta `docker compose up -d --build`.
- Si la página no responde: `docker compose logs app` muestra el error.
