FROM node:10.1.0-stretch as buildImage

WORKDIR /game_of_life

COPY webpack.config.js package.json package-lock.json elm-package.json /game_of_life/
COPY src /game_of_life/src/
COPY tests /game_of_life/tests/

RUN npm install && npm run build

FROM nginx:1.14-alpine

COPY --from=buildImage /game_of_life/dist/all.js /usr/share/nginx/html/
COPY src/assets/favicon.png src/assets/beacon.gif src/assets/beehive.png \
	src/assets/blinker_pattern.gif src/assets/block.png src/assets/boat.png \
	src/assets/loaf.png src/assets/toad_pattern.gif src/assets/tub.png \
	/usr/share/nginx/html/assets/
COPY src/index.html /usr/share/nginx/html/
COPY src/build/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY src/build/nginx/nginx.conf /etc/nginx/nginx.conf
