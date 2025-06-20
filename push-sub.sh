
#!/bin/bash
DIRECTORY=~/FisUNAL/MIE/indice_espectral/ 
BRANCH=Subtree
REPO_URL=git@github.com:aalmonacidd/Spectral_index.git

git subtree split -P $DIRECTORY -b $BRANCH
git push $REPO_URL $BRANCH:main --force
git branch -D $BRANCH


