# Instalación en Mac

Esta guía deja tu Mac lista **antes del curso**. No hace falta saber programar ni instalar Homebrew: un solo programa instala todo, y tú solo copias un comando y das algunos clics.

Sirve para Mac con procesador **Apple (M1, M2, M3, M4…)** y con procesador **Intel**. El programa detecta cuál tienes.

**Tiempo aproximado:** 30 a 60 minutos (casi todo es esperar descargas). No hace falta reiniciar.

---

## ¿Qué se va a instalar?

| Herramienta | Para qué sirve |
|---|---|
| **Herramientas de Apple** (Command Line Tools) | Traen **Git**, que guarda el historial de cambios de los archivos. |
| **Rancher Desktop** | Prepara un espacio de trabajo idéntico para todos los participantes (Docker). Es gratuito. |
| **Claude Code** | El asistente de IA que usaremos durante el curso. |
| **herdr** | Organiza en una sola ventana varias sesiones de Claude Code. |

---

## Antes de empezar

- [ ] **macOS 13 (Ventura) o más reciente.**
  Para revisarlo: menú  (arriba a la izquierda) → **Acerca de esta Mac**.
- [ ] **Al menos 15 GB libres** en el disco. Se recomiendan **8 GB de memoria** o más (aparece en la misma ventana de *Acerca de esta Mac*).
- [ ] **Buena conexión a internet** (se descargan unos 2 GB).
- [ ] **Tres cuentas** (créalas antes; las de GitHub y DigitalOcean se usan en el curso, no en la instalación):
  - **Claude**, con un plan que incluya Claude Code (el que indique el instructor). La necesitarás al final de la instalación.
  - **GitHub** (gratuita) en [github.com](https://github.com/signup): ahí se guarda tu trabajo.
  - **DigitalOcean** en [digitalocean.com](https://www.digitalocean.com): ahí se publica tu tablero. Pide una tarjeta; el costo mensual es bajo y se puede apagar en cualquier momento.
- [ ] **Tus propios reportes** de 2 o 3 áreas en Excel (o una versión sin datos confidenciales), para aplicar lo aprendido a tu caso.
- [ ] **La carpeta del curso** descomprimida. Si la bajaste como `.zip`, haz doble clic en el archivo y la Mac la descomprime sola (normalmente en **Descargas**).

> No necesitas contraseña de administrador.

---

### Paso 1: Ejecutar el programa de instalación

1. Abre la app **Terminal**: presiona `Cmd + Espacio`, escribe `Terminal` y presiona **Enter**.
2. En la Terminal escribe `bash` seguido de **un espacio** (todavía no presiones Enter).
3. Abre la carpeta del curso en el Finder, entra a **`instalacion`** → **`mac`** y **arrastra el archivo `instalar-mac.sh`** a la ventana de la Terminal. Se escribe solo la ruta del archivo.
   La línea queda parecida a esta:

   ```bash
   bash /Users/tu-nombre/Downloads/curso-tablero-director/instalacion/mac/instalar-mac.sh
   ```

4. Presiona **Enter** y espera. Vas a ver mucho texto pasar; es normal. Durante la instalación pueden aparecer estas ventanas:
   - **"La Terminal quiere acceder a archivos de la carpeta Descargas"**: haz clic en **Permitir**.
   - **"El comando git requiere las herramientas de desarrollo..."**: haz clic en **Instalar** y luego en **Aceptar**. Tarda de 5 a 20 minutos; el programa espera solo.
   - **Bienvenida de Rancher Desktop**: deja las opciones como están y haz clic en **Aceptar**.
   - Si macOS pregunta si permites algo a **Rancher Desktop**, responde que sí.
5. Al final aparece un mensaje verde que empieza con **"Listo."**
6. Abre en tu navegador **<http://localhost:8000>**. Debe decir *"El entorno del curso funciona"* y mostrar la lista de archivos de ejemplo.

✅ **Listo cuando:** ves el mensaje verde **"Listo."** y la página <http://localhost:8000> abre.

> Si aparece un mensaje en **rojo** que empieza con *"ERROR"*, léelo: casi siempre dice qué hacer. Puedes volver a ejecutar este paso sin riesgo: lo que ya está instalado no se repite.

---

### Paso 2: Conectar Claude Code con tu cuenta

Este paso se hace una sola vez.

1. Cierra la Terminal y abre **una nueva** (`Cmd + Espacio` → `Terminal`).
2. Escribe estos dos comandos, presionando Enter después de cada uno:

   ```bash
   cd ~/proyecto-python
   claude
   ```

3. Claude Code te hará unas preguntas iniciales (por ejemplo, el tema de colores). Muévete con las **flechas** del teclado y confirma con **Enter**.
4. Cuando te pida iniciar sesión, elige la opción de tu **cuenta de Claude**. Se abre el navegador: inicia sesión y autoriza el acceso.
5. Si pregunta si confías en la carpeta (*"Do you trust the files in this folder?"*), responde que **sí**.
6. Para salir de Claude Code escribe `/exit` y presiona Enter.

✅ **¡Todo listo para el curso!**

---

## El día del curso

**Rancher Desktop** arranca solo al encender la Mac (verás su ícono en la barra de menús, arriba a la derecha). Cada vez que quieras trabajar:

1. Abre la **Terminal**.
2. Escribe:

   ```bash
   cd ~/proyecto-python
   claude
   ```

3. Lo que construyas se ve en el navegador en **<http://localhost:8000>**. La página se actualiza sola cada vez que Claude cambia algo (recárgala con `Cmd + R`).

> **Tus archivos.** Los archivos de ejemplo del curso están en `~/proyecto-python/archivos_ejemplo`. Para verlos en el Finder: menú **Ir** → **Inicio** → carpeta `proyecto-python`.

> **Opcional: varias sesiones a la vez con herdr.** En lugar de `claude`, escribe `herdr` dentro de `~/proyecto-python`. El instructor lo mostrará en el curso.

> **Atajos útiles en la Terminal:** copiar `Cmd + C`, pegar `Cmd + V`, detener lo que se esté ejecutando `Ctrl + C`.

---

## Problemas comunes

<details>
<summary><b>"Se necesita macOS 13 (Ventura) o mas reciente"</b></summary>

Actualiza desde **Configuración del Sistema → General → Actualización de software**. Si tu Mac ya no recibe actualizaciones a macOS 13, avisa al instructor.
</details>

<details>
<summary><b>"No such file or directory" al ejecutar el paso 1</b></summary>

La ruta quedó mal escrita. Escribe otra vez `bash ` (con espacio) y **arrastra** el archivo `instalar-mac.sh` en lugar de escribir la ruta a mano.
</details>

<details>
<summary><b>"Operation not permitted"</b></summary>

La Terminal no tiene permiso para leer la carpeta del curso. Ve a **Configuración del Sistema → Privacidad y seguridad → Archivos y carpetas → Terminal** y activa la carpeta donde está el curso (por ejemplo, *Descargas*). Vuelve a ejecutar el paso 1.
</details>

<details>
<summary><b>"Docker no arranco"</b></summary>

Abre **Rancher Desktop** desde la carpeta **Aplicaciones**, espera a que termine de cargar (la primera vez tarda unos minutos) y vuelve a ejecutar el paso 1.
</details>

<details>
<summary><b>"claude: command not found", "herdr: command not found" o "docker: command not found"</b></summary>

Cierra la Terminal y abre una nueva. Si sigue igual, vuelve a ejecutar el paso 1.
</details>

<details>
<summary><b>La página http://localhost:8000 no abre</b></summary>

Revisa que Rancher Desktop esté abierto (ícono en la barra de menús). Luego, en la Terminal, escribe `cd ~/proyecto-python` y después `docker compose up -d`. Espera unos segundos y recarga la página. Si sigue sin abrir, escribe `docker compose logs app` y manda una captura al instructor.
</details>

<details>
<summary><b>La red de la institución bloquea descargas</b></summary>

Intenta desde otra red (por ejemplo, la de tu casa) o consulta a tu área de sistemas.
</details>

Si nada de esto resuelve el problema, toma una **captura de pantalla del error** (`Cmd + Shift + 4` y selecciona la zona) y envíasela al instructor antes del curso.
