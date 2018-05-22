# Conway's Game of Life

An implementation of [conway's game](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
in [Elm](https://en.wikipedia.org/wiki/Elm_(programming_language)).

This is my submission to [IT-Talents](https://www.it-talents.de/) corresponding
[code competition](https://www.it-talents.de/foerderung/code-competition/code-competition-05-2018).

## Run It (The fast way)

Assuming that **docker** (at least version 17.04) and **docker-compose** are installed,
you could simply execute:

```
docker-compose up
```

Now point your browser to [http://localhost:8080](http://localhost:8080), where the application is running.

Be sure that you execute this command from the root of this repository
(i.e. next to the associated [docker-compose.yml](docker-compose.yml)).


This command will use a [multi stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to:

- compile the source code
- execute tests
- bundle the application
- start a [webserver](https://hub.docker.com/_/nginx/) which delivers the webapp on port 8080

## Run It (Developer mode)

Assuming that **npm** (I use 5.8) and **git** are installed,
you could simply execute:

```
TBA
```

## Features

I have added some advanced features.

### TBA
