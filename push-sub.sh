
#!/bin/bash

# Forzar ejecución desde la raíz del repo
cd "$(git rev-parse --show-toplevel)"

DIRECTORY=.          # Carpeta que quieres extraer
BRANCH=sub        # Nombre temporal de la rama
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

# Verifica que la carpeta existe
if [ ! -d "$DIRECTORY" ]; then
  echo "❌ Error: la carpeta '$DIRECTORY' no existe."
  exit 1
fi

# Crea la rama
git subtree split -P $DIRECTORY -b $BRANCH

# Verifica que se creó la rama
if ! git rev-parse --verify $BRANCH >/dev/null 2>&1; then
  echo "❌ Error: la rama '$BRANCH' no fue creada. Verifica que la carpeta tenga commits."
  exit 1
fi

# Push al nuevo repo
git push $REPO_URL $BRANCH:main --force

# Borra la rama temporal
git branch -D $BRANCH

echo "✅ Subida exitosa de '$DIRECTORY/' a $REPO_URL"

