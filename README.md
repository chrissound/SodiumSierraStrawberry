# New Haskell Project Bootstrap

## What problem does this solve?
Eliminates the need for the tedious `cabal init` as well creating the usefull files relating to `.ghci` etc.

## Instructions

Git clone this project, and run the following command (you'll need to modify the source and destination) in the directory of the new project:
```
git@github.com:chrissound/newHaskellProjectBootstrap.git /example/path/changeme
cd /example/path/changeme2
rsync -av --progress /example/path/changeme . --exclude .git  --exclude README.md && git init
```

## Bonus

You can use the the `ghcid.sh` script to start a ghcid session. 
