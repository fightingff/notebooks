set /p msg = 
conda activate ox
mkdocs gh-deploy
git add .
git commit -m "%msg%"
git push