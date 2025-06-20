
#!/bin/bash

set -e  # Detener en caso de error

cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

# ✅ Paso 0: Verificar si hay alguna clave cargada en el agente SSH
if ! ssh-add -l &>/dev/null; then
  echo "🔐 No hay claves SSH cargadas en tu sesión."
  echo "📝 Por favor, selecciona o escribe la ruta de tu clave privada SSH:"
  read -e -p "Ruta (default: ~/.ssh/id_rsa): " SSH_KEY_PATH
  SSH_KEY_PATH=${SSH_KEY_PATH:-~/.ssh/id_rsa}

  # Expandir ~ manualmente
  SSH_KEY_PATH="${SSH_KEY_PATH/#\~/$HOME}"

  if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "❌ La clave '$SSH_KEY_PATH' no existe."
    exit 1
  fi

  echo "🔑 Cargando clave SSH..."
  ssh-add "$SSH_KEY_PATH" || {
    echo "❌ No se pudo cargar la clave. Verifica tu passphrase."
    exit 1
  }
else
  echo "✅ Ya hay claves SSH cargadas."
fi

# Paso 1: Verificar carpeta
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Carpeta '$DIRECTORY' no encontrada."
  exit 1
fi

# Paso 2: Verificar commits
if git diff --quiet HEAD -- "$DIRECTORY"; then
  echo "⚠️  No hay commits nuevos en '$DIRECTORY'. Usando HEAD."
  git subtree split -P "$DIRECTORY" HEAD -b "$BRANCH"
else
  echo "📦 Creando rama con cambios nuevos..."
  git subtree split -P "$DIRECTORY" -b "$BRANCH"
fi

# Paso 3: Push
echo "🚀 Haciendo push al repo remoto..."
git push "$REPO_URL" "$BRANCH:main" --force

# Paso 4: Limpiar
git branch -D "$BRANCH"

echo "✅ Push completado con éxito."

#!/bin/bash

set -e  # Salir si hay cualquier error

cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

echo "🔐 Verificando claves SSH cargadas..."
if ! ssh-add -l &>/dev/null; then
  echo "⚠️  No hay claves SSH cargadas."

  # Pedir al usuario la ruta de su clave privada
  read -e -p "🔑 Escribe la ruta a tu clave privada SSH (default: ~/.ssh/id_rsa): " SSH_KEY_PATH
  SSH_KEY_PATH="${SSH_KEY_PATH:-~/.ssh/id_rsa}"  # Default si no escribe nada
  SSH_KEY_PATH="${SSH_KEY_PATH/#\~/$HOME}"       # Expandir ~

  if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "❌ La clave privada '$SSH_KEY_PATH' no existe."
    exit 1
  fi

  echo "📥 Cargando clave. Se te pedirá la passphrase ahora:"
  ssh-add "$SSH_KEY_PATH" || {
    echo "❌ Error al cargar la clave. ¿Passphrase incorrecta?"
    exit 1
  }
else
  echo "✅ Clave SSH ya cargada."
fi

# Verificar carpeta
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Carpeta '$DIRECTORY' no encontrada."
  exit 1
fi

# Split de subtree
if git diff --quiet HEAD -- "$DIRECTORY"; then
  echo "⚠️  No hay commits nuevos. Usando HEAD de todas formas..."
  git subtree split -P "$DIRECTORY" HEAD -b "$BRANCH"
else
  echo "📦 Generando rama desde commits nuevos en '$DIRECTORY'..."
  git subtree split -P "$DIRECTORY" -b "$BRANCH"
fi

# Push
echo "🚀 Enviando a GitHub..."
git push "$REPO_URL" "$BRANCH:main" --force

# Limpieza
git branch -D "$BRANCH"

echo "✅ ¡Push completado exitosamente!"
