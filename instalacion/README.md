# Instalación: preparar tu computadora

Esta guía explica cómo dejar tu computadora lista **antes del curso**. No hace falta saber programar: solo hay que seguir los pasos en orden y copiar y pegar algunos comandos.

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
- [ ] **La carpeta del curso** descomprimida en un lugar fácil de encontrar, por ejemplo `Documentos\cursoSEDU`.
  Si te llegó como `.zip`: clic derecho → **Extraer todo**.

---

## Instalación en Windows

### Cómo abrir PowerShell en la carpeta de instalación

Vas a necesitar esto en los pasos 1 y 3:

1. En el Explorador de archivos, entra a la carpeta del curso y luego a **`instalacion`** → **`windows`**. Ahí están los archivos `1-instalar-wsl.ps1` y `2-configurar-docker.ps1`.
2. Haz clic en la **barra de direcciones** de arriba (donde aparece la ruta de la carpeta), borra lo que haya, escribe `powershell` y presiona **Enter**.
3. Se abre una ventana azul o negra. Esa es PowerShell, ya ubicada en la carpeta correcta.

> **Para pegar un comando** en PowerShell: cópialo de esta guía y haz **clic derecho** dentro de la ventana (o presiona `Ctrl + V`). Después presiona **Enter**.

---

### Paso 1: Instalar Ubuntu (WSL)

1. Abre PowerShell en la carpeta `instalacion\windows` (ver arriba).
2. Pega este comando y presiona Enter:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\1-instalar-wsl.ps1
   ```

3. Windows te preguntará: *"¿Quieres permitir que esta aplicación haga cambios?"*. Responde **Sí**.
   - Si tu cuenta **no es de administrador**, Windows te pedirá el usuario y la contraseña de un administrador. Puede escribirlos alguien de tu área de sistemas; la instalación de Ubuntu queda de todos modos en **tu** cuenta.
   - Se abre una segunda ventana que trabaja sola y **se cierra sola** al terminar. Después todo sigue en la primera ventana.
4. Espera a que termine. Puede tardar varios minutos y mostrar barras de progreso.
5. Al final el mensaje verde te dice qué sigue:
   - **"Falta un reinicio..."**: responde `s` para reiniciar y, al volver, **ejecuta este paso 1 otra vez** (esta vez instala Ubuntu y ya no pide administrador).
   - **"Siguientes pasos: Abre Ubuntu 24.04..."**: pasa al paso 2.

> ⚠️ Abre PowerShell de la forma normal, **no** con "Ejecutar como administrador": el script pide el permiso solo cuando lo necesita.

✅ **Listo cuando:** el mensaje verde dice *"Siguientes pasos: Abre 'Ubuntu 24.04'..."*.

> Si el mensaje dice *"Ubuntu-24.04 ya esta instalado"*, ya tenías este paso hecho: pasa directo al paso 3.

---

### Paso 2: Crear tu usuario de Ubuntu

1. Abre el menú Inicio, busca **Ubuntu 24.04** y ábrelo.
   (Si después de un reinicio se abrió una ventana negra solita, usa esa.)
2. Espera mientras dice *"Installing, this may take a few minutes..."*.
3. Te pedirá:
   - **`Enter new UNIX username:`** escribe un nombre de usuario **corto, en minúsculas, sin espacios ni acentos** (ejemplo: `maria`) y presiona Enter.
   - **`New password:`** escribe una contraseña y presiona Enter.
   - **`Retype new password:`** escríbela otra vez.

   > ⚠️ **Mientras escribes la contraseña no aparece nada en pantalla**, ni puntos ni asteriscos. Es normal: sí se está escribiendo.
   >
   > 📝 **Anota tu usuario y contraseña.** Te los pueden pedir más adelante.

4. Cuando veas algo como `maria@NOMBRE-PC:~$`, ya terminó. Puedes cerrar esa ventana.

✅ **Listo cuando:** ves la línea que termina en `$`.

> Si **Ubuntu 24.04** no aparece en el menú Inicio, abre PowerShell y ejecuta `wsl --install -d Ubuntu-24.04`. Luego sigue desde el punto 2.

---

### Paso 3: Instalar Docker, Git, Claude Code y el proyecto

1. Abre PowerShell en la carpeta `instalacion\windows` otra vez (esta vez **no** hace falta como administrador).
2. Pega este comando y presiona Enter:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\2-configurar-docker.ps1
   ```

3. Espera. Este es el paso más largo (10 a 30 minutos). Vas a ver mucho texto pasar; es normal. El script:
   - instala Git y Docker,
   - instala Claude Code y herdr y los actualiza a la última versión,
   - copia el proyecto del curso y los archivos de ejemplo a Ubuntu (carpeta `~/proyecto-python`),
   - arranca la aplicación del curso.
4. Al final aparece un recuadro verde que empieza con **"Listo."**
5. Abre en tu navegador **<http://localhost:8000>**. Debe decir *"El entorno del curso funciona"* y mostrar la lista de archivos de ejemplo.

✅ **Listo cuando:** ves el mensaje verde **"Listo."** y la página <http://localhost:8000> abre.

> Si aparece un mensaje en **rojo** que empieza con *"Fallo..."*, revisa la sección [Problemas comunes](#problemas-comunes). Puedes volver a ejecutar este paso sin riesgo: lo que ya está instalado no se repite.

---

### Paso 4: Conectar Claude Code con tu cuenta

Este paso se hace una sola vez.

1. Abre **Ubuntu 24.04** desde el menú Inicio.
2. Escribe estos dos comandos, presionando Enter después de cada uno:

   ```bash
   cd ~/proyecto-python
   claude
   ```

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

1. Abre **Ubuntu 24.04** desde el menú Inicio.
2. Escribe:

   ```bash
   cd ~/proyecto-python
   claude
   ```

3. Lo que construyas se ve en el navegador en **<http://localhost:8000>**. La página se actualiza sola cada vez que Claude cambia algo (recárgala con `F5`).

> **Tus archivos.** Los archivos de ejemplo del curso están en `~/proyecto-python/archivos_ejemplo`. Las reglas del proyecto (fecha de corte, cómo trabajar) están en `~/proyecto-python/CLAUDE.md`, que Claude lee solo al abrirse.

> **Opcional: varias sesiones a la vez con herdr.** En lugar de `claude`, escribe `herdr` dentro de `~/proyecto-python`. Te permite tener varias sesiones de Claude Code en la misma ventana y ver cuál necesita tu atención. El instructor lo mostrará en el curso.

> **Atajos útiles en la ventana de Ubuntu:**
> - Copiar: seleccionar con el mouse y `Ctrl + Shift + C`
> - Pegar: clic derecho o `Ctrl + Shift + V`
> - Detener lo que se esté ejecutando: `Ctrl + C`

---

## Problemas comunes

<details>
<summary><b>"No se puede cargar el archivo... la ejecución de scripts está deshabilitada"</b></summary>

Asegúrate de copiar el comando **completo**, incluyendo `-ExecutionPolicy Bypass`. No hagas doble clic en el archivo `.ps1`: usa el comando de esta guía.
</details>

<details>
<summary><b>Error 0x80370102 o un mensaje sobre "virtualización"</b></summary>

La virtualización está apagada en tu computadora. Hay que activarla en la BIOS/UEFI; el nombre de la opción cambia según la marca (*Intel VT-x*, *Intel Virtualization Technology*, *AMD-V* o *SVM Mode*). Si no te sientes cómodo haciéndolo, pide ayuda a tu área de sistemas o avisa al instructor.

Para revisar si ya está activa: `Ctrl + Shift + Esc` → pestaña **Rendimiento** → **CPU** → debe decir **Virtualización: Habilitado**.
</details>

<details>
<summary><b>"Se requiere Windows 10 version 2004 o superior" o "tu version de Windows no reconoce los comandos nuevos de WSL"</b></summary>

Actualiza Windows desde **Configuración → Windows Update** e instala **todas** las actualizaciones (pueden ser varias rondas). Reinicia y vuelve a ejecutar el paso 1.
</details>

<details>
<summary><b>"no se dio el permiso de administrador"</b></summary>

Respondiste "No" a la ventana de permiso, o no se escribió la clave de un administrador. Vuelve a ejecutar el paso 1 y responde **Sí**. Si no tienes clave de administrador, pide ayuda a tu área de sistemas.
</details>

<details>
<summary><b>"ERROR: Abre 'Ubuntu 24.04' desde el menu Inicio y crea tu usuario"</b></summary>

Te saltaste el paso 2. Hazlo y luego repite el paso 3.
</details>

<details>
<summary><b>"ERROR: Ubuntu-24.04 no esta instalado"</b></summary>

Repite el paso 1 y reinicia la computadora.
</details>

<details>
<summary><b>"claude: command not found" o "herdr: command not found"</b></summary>

Cierra la ventana de Ubuntu y ábrela de nuevo. Si sigue igual, repite el paso 3.
</details>

<details>
<summary><b>Se quedó detenido mucho tiempo sin avanzar</b></summary>

Algunas descargas tardan. Si pasan más de 20 minutos sin cambios, cierra la ventana, reinicia la computadora y repite el paso donde te quedaste. Los scripts se pueden ejecutar varias veces sin problema.
</details>

<details>
<summary><b>La red de la institución bloquea descargas</b></summary>

Algunas redes bloquean las descargas que hacen estos programas. Si ves errores de conexión, intenta desde otra red (por ejemplo, la de tu casa) o consulta a tu área de sistemas.
</details>

<details>
<summary><b>La página http://localhost:8000 no abre</b></summary>

Abre Ubuntu y escribe `cd ~/proyecto-python` y luego `docker compose up -d`. Espera unos segundos y recarga la página. Si sigue sin abrir, escribe `docker compose logs app` y manda una captura al instructor.
</details>

Si nada de esto resuelve el problema, toma una **captura de pantalla del error** (`Windows + Shift + S`) y envíasela al instructor antes del curso.

---

## Instalación en Mac

🚧 **Pendiente.** Esta sección se agregará más adelante. Si usas Mac, avisa al instructor.
