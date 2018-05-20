#!/bin/bash -e

echo "Make sure all dependencies are installed ..."
npm install

./build_scripts/install.sh
