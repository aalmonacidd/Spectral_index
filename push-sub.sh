
#!/bin/bash

set -e  # Cualquier error hace que el script se detenga inmediatamente

# Ir a la raíz del repositorio
cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

# ✅ Paso 0: Verificar conexión SSH con GitHub
echo "🔒 Verificando autenticación SSH con GitHub..."
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "❌ No tienes autenticación SSH activa con GitHub."
  echo "   Asegúrate de tener tu clave cargada con:"
  echo "   ssh-add ~/.ssh/id_rsa  (o tu clave correspondiente)"
  exit 1
fi
echo "✅ Autenticación SSH verificada."

# Paso 1: Verificar que la carpeta existe
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Carpeta '$DIRECTORY' no encontrada."
  exit 1
fi

# Paso 2: Verificar si hay cambios en esa carpeta
if git diff --quiet HEAD -- "$DIRECTORY"; then
  echo "⚠️  No hay commits nuevos en '$DIRECTORY'. Se usará el estado actual (HEAD)."
  git subtree split -P "$DIRECTORY" HEAD -b "$BRANCH"
else
  echo "📦 Creando rama con los cambios nuevos..."
  git subtree split -P "$DIRECTORY" -b "$BRANCH"
fi

# Paso 3: Push usando el entorno SSH del usuario
echo "🚀 Haciendo push al repositorio remoto..."
git push "$REPO_URL" "$BRANCH:main" --force

# Paso 4: Limpieza opcional
git branch -D "$BRANCH"

echo "✅ Push completado correctamente."

