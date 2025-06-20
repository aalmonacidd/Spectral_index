
#!/bin/bash

# Moverse a la raíz del repo
cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=https://github.com/aalmonacidd/Spectral_index.git  # <- HTTPS en vez de SSH

# Verificar que la carpeta exista
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Carpeta '$DIRECTORY' no encontrada."
  exit 1
fi

# Crear rama con commits de la carpeta
git subtree split -P $DIRECTORY -b $BRANCH || {
  echo "❌ Error creando rama '$BRANCH'"
  exit 1
}

# Push interactivo: pedirá tu usuario y PAT (token)
git push $REPO_URL $BRANCH:main --force || {
  echo "❌ Error al hacer push (verifica tu usuario/token)"
  exit 1
}

# Limpieza opcional
# git branch -D $BRANCH

echo "✅ Push exitoso a $REPO_URL (autenticación interactiva)"

