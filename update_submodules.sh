#!/usr/bin/env bash

git submodule update --remote --recursive
git commit -m "Submodule updated." -a
git push
