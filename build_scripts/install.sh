#!/bin/bash -e

if [ ! -e package.json ]; then
	echo "You need to run every build scripts from the project root."
	exit 1
fi

echo "Clean build directory ..."
rm -Rf build
mkdir build

./node_modules/elm-format/bin/elm-format src/elm/*.elm --yes

echo "Compile the source code ..."
rm -Rf src/js/generated
./node_modules/elm/binwrappers/elm-make src/elm/Main.elm --output src/js/generated/elm/main.js

cp src/index.html build/
cp -r src/js/generated build/

npm run-script webp
