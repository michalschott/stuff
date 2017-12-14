#!/usr/bin/env bash

git submodule update --remote --recursive
git status
git commit -m "Submodule updated." -a
git push
