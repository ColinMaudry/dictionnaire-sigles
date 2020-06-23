#!/bin/bash

# abort on errors
set -e

echo Building. this may take a minute...
npm run build

# navigate into the build output directory
cd dist

# if you are deploying to a custom domain
# echo 'example.com' > CNAME

echo Deploying..
git init
git checkout -b gh-pages
git add -A
git commit -m 'deploy'

# deploy
git remote add origin git@github.com:ColinMaudry/dictionnaire-sigles.git
git push -f git@github.com:ColinMaudry/dictionnaire-sigles.git gh-pages

cd -
