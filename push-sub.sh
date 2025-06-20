
#!/bin/bash

cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

# Split subtree
git subtree split -P $DIRECTORY -b $BRANCH || {
  echo "❌ Error creando rama '$BRANCH'"
  exit 1
}

# Push con SSH forzado
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes" \
git push $REPO_URL $BRANCH:main --force || {
  echo "❌ Error en push SSH"
  exit 1
}

echo "✅ Push exitoso"

