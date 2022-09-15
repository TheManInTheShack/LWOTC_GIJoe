@ECHO OFF

git remote set-url origin https://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@github.com/TheManInTheShack/LWOTC_GIJoe.git

git status

git pull

git add -A
git commit -m %*

git push

