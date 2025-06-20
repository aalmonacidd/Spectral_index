cd "$(git rev-parse --show-toplevel)"

DIRECTORY=MIE/indice_espectral
BRANCH=indice-espectral-split
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

echo "🔐 Verificando claves SSH cargadas..."
if ! ssh-add -l &>/dev/null; then
  echo "⚠️  No hay claves SSH cargadas."

  # Pedir al usuario la ruta de su clave privada
 
read -e -p "🔑 Escribe la ruta a tu clave privada SSH (default: ~/.ssh/id_rsa): " SSH_KEY_PATH
SSH_KEY_PATH="${SSH_KEY_PATH:-~/.ssh/id_rsa}"
SSH_KEY_PATH=$(eval echo "$SSH_KEY_PATH")

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
