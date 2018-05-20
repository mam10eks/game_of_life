#!/bin/bash -e

if [ ! -e package.json ]; then
	echo "You need to run every build scripts from the project root."
	exit 1
fi

echo "Clean build directory ..."
rm -Rf build
mkdir build

./node_modules/elm-format/bin/elm-format src/main.elm --yes

echo "Compile the source code ..."
./node_modules/elm/binwrappers/elm-make src/main.elm --output src/generated/elm/main.js
cp src/index.html build/
cp -r src/generated build/

npm run-script build
