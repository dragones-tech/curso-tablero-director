# Instalación en Windows: preparar tu computadora

> 🍎 **¿Tienes Mac?** Sigue la [guía de instalación para Mac](mac/README.md).

Esta guía explica cómo dejar tu computadora con Windows lista **antes del curso**. No hace falta saber programar: todo se instala con **doble clic en un solo archivo**.

**Tiempo aproximado:** 30 a 60 minutos (casi todo es esperar descargas). Puede haber un reinicio a mitad del proceso.

---

## ¿Qué se va a instalar?

No necesitas entender estas herramientas para el curso, pero así sabes qué está pasando:

| Herramienta | Para qué sirve |
|---|---|
| **Ubuntu (WSL)** | Un "Linux" que corre dentro de Windows. Ahí vive todo lo del curso. |
| **Docker** | Prepara un espacio de trabajo idéntico para todos los participantes. |
| **Git** | Guarda el historial de cambios de los archivos. |
| **Claude Code** | El asistente de IA que usaremos durante el curso. |
| **herdr** | Organiza en una sola ventana varias sesiones de Claude Code y muestra cuál está trabajando, cuál terminó y cuál espera tu respuesta. |

---

## Antes de empezar

Revisa que tengas todo esto:

- [ ] **Windows 10 (versión 2004 o más reciente) o Windows 11.**
  Para revisarlo: tecla Windows → escribe `winver` → Enter.
- [ ] **Permisos de administrador** en la computadora. Si es una computadora de la institución, quizá tengas que pedírselos a tu área de sistemas.
- [ ] **Al menos 15 GB libres** en el disco.
- [ ] **Buena conexión a internet** (se descargan varios GB).
- [ ] **Tres cuentas** (créalas antes; las de GitHub y DigitalOcean se usan en el curso, no en la instalación):
  - **Claude**, con un plan que incluya Claude Code (el que indique el instructor). La necesitarás al final de la instalación.
  - **GitHub** (gratuita) en [github.com](https://github.com/signup): ahí se guarda tu trabajo.
  - **DigitalOcean** en [digitalocean.com](https://www.digitalocean.com): ahí se publica tu tablero. Pide una tarjeta; el costo mensual es bajo y se puede apagar en cualquier momento.
- [ ] **Tus propios reportes** de 2 o 3 áreas en Excel (o una versión sin datos confidenciales), para aplicar lo aprendido a tu caso. No se usan en la instalación.

---

## Instalación en Windows

### Paso 1: Descargar y ejecutar el instalador

1. **Descarga el instalador:** [**instalar-windows.cmd**](https://github.com/dragones-tech/curso-tablero-director/releases/latest/download/instalar-windows.cmd)
   - Es posible que el navegador avise que *"este tipo de archivo puede dañar tu dispositivo"* o que *"no se descarga normalmente"*. Elige **Conservar** (en Edge, primero haz clic en los **tres puntos** `···` junto al aviso).
2. Abre la carpeta **Descargas** y haz **doble clic** en `instalar-windows`.
3. Si aparece una ventana azul que dice **"Windows protegió su PC"**: haz clic en **Más información** y luego en **Ejecutar de todas formas**.
4. Se abre una ventana negra que baja los materiales del curso y empieza a instalar. **No la cierres**: ella te dirá qué hacer.
5. Windows te preguntará: *"¿Quieres permitir que esta aplicación haga cambios?"*. Responde **Sí**.
   - Si tu cuenta **no es de administrador**, Windows te pedirá el usuario y la contraseña de un administrador. Puede escribirlos alguien de tu área de sistemas; la instalación queda de todos modos en **tu** cuenta.
   - Se abre una segunda ventana que trabaja sola y **se cierra sola**. Después todo sigue en la primera.
6. **Si te pide reiniciar** (*"Falta un reinicio..."*): escribe `s` y presiona Enter. Cuando Windows vuelva a encender, **haz doble clic otra vez en `instalar-windows`** (sigue en Descargas). Continúa donde se quedó.
7. Espera. Esta es la parte más larga (10 a 30 minutos) y vas a ver mucho texto pasar; es normal. Se instalan Git, Docker, Claude Code y herdr, y se copia el proyecto del curso con los archivos de ejemplo a Ubuntu (carpeta `~/proyecto-python`).
8. Al final aparece un recuadro verde que empieza con **"Listo."**
9. Abre en tu navegador **<http://localhost:8000>**. Debe decir *"El entorno del curso funciona"* y mostrar la lista de archivos de ejemplo.

✅ **Listo cuando:** ves el mensaje verde **"Listo."** y la página <http://localhost:8000> abre.

> Si aparece un mensaje en **rojo**, léelo y revisa la sección [Problemas comunes](#problemas-comunes). Puedes volver a dar doble clic a `instalar-windows` las veces que haga falta: lo que ya está instalado no se repite.
>
> Los materiales del curso quedan en **Documentos**, en la carpeta `curso-tablero-director`.

> 🖱️ **Accesos directos.** Al terminar, en tu **Escritorio** quedan tres accesos directos (también en la carpeta del curso):
> - **Curso - Terminal**: abre Ubuntu ya dentro del proyecto. Solo escribes `claude`.
> - **Curso - Archivos del proyecto**: los archivos que va creando Claude, en el Explorador.
> - **Curso - Mi tablero**: tu aplicación en el navegador (<http://localhost:8000>).

> 🔑 **Tu usuario de Ubuntu ya está creado:** usuario **`alumno`**, contraseña **`curso2026`**. Es igual para todos los participantes; no tienes que inventar uno. La contraseña solo se pide si alguna vez instalas algo dentro de Ubuntu (y, al escribirla, no aparece nada en pantalla: es normal).
>
> Si al abrir **Ubuntu 24.04** alguna vez te pide crear un usuario (*"Enter new UNIX username"*), escribe `alumno` y, como contraseña, `curso2026` dos veces.

<details>
<summary><b>Alternativa: instalar desde PowerShell, paso por paso</b> (si el doble clic no funciona)</summary>

1. Descarga el curso completo desde [la página del curso en GitHub](https://github.com/dragones-tech/curso-tablero-director) (**Code → Download ZIP**), haz clic derecho en el `.zip` → **Extraer todo**.
2. Si en la carpeta extraída das doble clic a `instalar-windows`, usa esos archivos en lugar de descargarlos. Si prefieres hacerlo a mano:
3. Entra a **`instalacion`** → **`windows`**, haz clic en la **barra de direcciones** del Explorador, escribe `powershell` y presiona **Enter** (en Windows 11 también sirve clic derecho → **Abrir en Terminal**).
4. Pega este comando (clic derecho para pegar) y presiona Enter. Sigue las indicaciones de los puntos 5 y 6 de arriba:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\1-instalar-wsl.ps1
   ```

5. Después pega este otro y espera el mensaje **"Listo."**:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\2-configurar-docker.ps1
   ```

</details>

---

### Paso 2: Conectar Claude Code con tu cuenta

Este paso se hace una sola vez.

1. Haz doble clic en **Curso - Terminal**, en tu Escritorio. Se abre una ventana de Ubuntu ya dentro del proyecto.
2. Escribe `claude` y presiona Enter.

3. Claude Code te hará unas preguntas iniciales (por ejemplo, el tema de colores). Muévete con las **flechas** del teclado y confirma con **Enter**.
4. Cuando te pida iniciar sesión, elige la opción de tu **cuenta de Claude**.
   - Si se abre el navegador, inicia sesión y autoriza el acceso.
   - Si **no** se abre, en la ventana aparece un enlace largo. Selecciónalo con el mouse, cópialo con **clic derecho** o `Ctrl + Shift + C`, pégalo en tu navegador e inicia sesión. Si la página te da un código, cópialo y pégalo de vuelta en Ubuntu con clic derecho o `Ctrl + Shift + V`.
5. Si pregunta si confías en la carpeta (*"Do you trust the files in this folder?"*), responde que **sí**.
6. Para salir de Claude Code escribe `/exit` y presiona Enter, o presiona `Ctrl + C` dos veces.

✅ **¡Todo listo para el curso!**

---

## El día del curso

Cada vez que quieras trabajar:

1. Haz doble clic en **Curso - Terminal**, en tu Escritorio.
2. Escribe `claude` y presiona Enter.
3. Lo que construyas se ve en el navegador en **<http://localhost:8000>** (o con doble clic en **Curso - Mi tablero**). La página se actualiza sola cada vez que Claude cambia algo (recárgala con `F5`).

> **Tus archivos.** Para verlos, doble clic en **Curso - Archivos del proyecto**. Los archivos de ejemplo del curso están en la carpeta `archivos_ejemplo`. Las reglas del proyecto (fecha de corte, cómo trabajar) están en `~/proyecto-python/CLAUDE.md`, que Claude lee solo al abrirse.

> **Opcional: varias sesiones a la vez con herdr.** En lugar de `claude`, escribe `herdr`. Te permite tener varias sesiones de Claude Code en la misma ventana y ver cuál necesita tu atención. El instructor lo mostrará en el curso.

> **Atajos útiles en la ventana de Ubuntu:**
> - Copiar: seleccionar con el mouse y `Ctrl + Shift + C`
> - Pegar: clic derecho o `Ctrl + Shift + V`
> - Detener lo que se esté ejecutando: `Ctrl + C`

---

## Problemas comunes

<details>
<summary><b>"No se puede cargar el archivo... la ejecución de scripts está deshabilitada"</b></summary>

Usa el archivo `instalar-windows` con doble clic. Si estás siguiendo la alternativa de PowerShell, copia el comando **completo**, incluyendo `-ExecutionPolicy Bypass`.
</details>

<details>
<summary><b>Error 0x80370102 o un mensaje sobre "virtualización"</b></summary>

La virtualización está apagada en tu computadora. Hay que activarla en la BIOS/UEFI; el nombre de la opción cambia según la marca (*Intel VT-x*, *Intel Virtualization Technology*, *AMD-V* o *SVM Mode*). Si no te sientes cómodo haciéndolo, pide ayuda a tu área de sistemas o avisa al instructor.

Para revisar si ya está activa: `Ctrl + Shift + Esc` → pestaña **Rendimiento** → **CPU** → debe decir **Virtualización: Habilitado**.
</details>

<details>
<summary><b>"Se requiere Windows 10 version 2004 o superior" o "tu version de Windows no reconoce los comandos nuevos de WSL"</b></summary>

Actualiza Windows desde **Configuración → Windows Update** e instala **todas** las actualizaciones (pueden ser varias rondas). Reinicia y vuelve a dar doble clic a `instalar-windows`.
</details>

<details>
<summary><b>"no se dio el permiso de administrador"</b></summary>

Respondiste "No" a la ventana de permiso, o no se escribió la clave de un administrador. Vuelve a dar doble clic a `instalar-windows` y responde **Sí**. Si no tienes clave de administrador, pide ayuda a tu área de sistemas.
</details>

<details>
<summary><b>"ERROR: Ubuntu no tiene el usuario del curso"</b></summary>

No se creó el usuario de Ubuntu. Vuelve a dar doble clic a `instalar-windows`. Si sigue igual, avisa al instructor.
</details>

<details>
<summary><b>"ERROR: Ubuntu-24.04 no esta instalado"</b></summary>

Vuelve a dar doble clic a `instalar-windows` y, si lo pide, reinicia.
</details>

<details>
<summary><b>"claude: command not found" o "herdr: command not found"</b></summary>

Cierra la ventana de Ubuntu y ábrela de nuevo. Si sigue igual, vuelve a dar doble clic a `instalar-windows`.
</details>

<details>
<summary><b>Se quedó detenido mucho tiempo sin avanzar</b></summary>

Algunas descargas tardan. Si pasan más de 20 minutos sin cambios, cierra la ventana, reinicia la computadora y vuelve a dar doble clic a `instalar-windows`. Se puede ejecutar varias veces sin problema.
</details>

<details>
<summary><b>La red de la institución bloquea descargas</b></summary>

Algunas redes bloquean las descargas que hacen estos programas. Si ves errores de conexión, intenta desde otra red (por ejemplo, la de tu casa) o consulta a tu área de sistemas.
</details>

<details>
<summary><b>La página http://localhost:8000 no abre</b></summary>

Abre **Curso - Terminal** y escribe `docker compose up -d`. Espera unos segundos y recarga la página. Si sigue sin abrir, escribe `docker compose logs app` y manda una captura al instructor.
</details>

Si nada de esto resuelve el problema, toma una **captura de pantalla del error** (`Windows + Shift + S`) y envíasela al instructor antes del curso.

---

## Instalación en Mac

Está en su propia guía: [instalación para Mac](mac/README.md).
