#!/bin/bash -e

if [ ! -e package.json ]; then
	echo "You need to run every build scripts from the project root."
	exit 1
fi

echo "Clean build directory ..."
rm -Rf build
mkdir build

echo "Make sure all dependencies are installed ..."
npm install

echo "Compile the source code ..."
./node_modules/elm/binwrappers/elm-make src/main.elm --output build/main.js
cp src/index.html build/
