
#!/bin/bash
DIRECTORY=~/FisUNAL/MIE/indice_espectral/ 
BRANCH=Spectral_index
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

git subtree split -P $DIRECTORY -b $BRANCH
git push $REPO_URL $BRANCH:main --force
git branch -D $BRANCH

echo "✅ Subida exitosa de '$DIRECTORY/' al repositorio $REPO_URL"
