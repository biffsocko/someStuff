#!/bin/bash

DIR="/Users/tmurphy/src"

cd ${DIR}
for next in `ls`
do
  echo "working on ${next}"
  cd ${next}
  git pull
  cd ../
  echo ""
done
