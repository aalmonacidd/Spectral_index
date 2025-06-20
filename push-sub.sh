
#!/bin/bash

# Ir a la raíz del repositorio
cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

# Verificar que la carpeta existe
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Carpeta '$DIRECTORY' no encontrada."
  exit 1
fi

# Crear la rama con historial reducido de la carpeta
git subtree split -P "$DIRECTORY" -b "$BRANCH" || {
  echo "❌ Error creando rama '$BRANCH'"
  exit 1
}

# Push usando el entorno SSH actual del usuario
git push "$REPO_URL" "$BRANCH:main" --force || {
  echo "❌ Error al hacer push. Verifica que tengas tu SSH cargado y permisos en el repo."
  exit 1
}

# Limpieza opcional
# git branch -D "$BRANCH"

echo "✅ Push completado exitosamente."

