@ECHO OFF

REM git remote add origin https://github.com/TheManInTheShack/LWOTC_GIJoe.git
REM git branch -M main
REM git push -u origin main


git status

git pull

git add -A
git commit -m %*

git push

