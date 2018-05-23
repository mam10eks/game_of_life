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

### Tutorial

There exists a 10 step Tutorial which describes the rules of the game and some key features of this application.

![Tutorial](src/assets/readme_images/tutorial.png "Tutorial")

### Time Travel

With navigation buttons (the arrows left and right from the board) you could step through single evolution rounds.

![Time Travel](src/assets/readme_images/time_travel.png "Time Travel")

### A Collection Of Famous Patterns

Do you know some interesting patterns in Conway's game of life?
No Problem if not, since I have included a list of famous patterns from
[wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).
Simply have a look and choose a pattern if you like to try it:

![Famous Patterns](src/assets/readme_images/example_patterns.png "Famous Patterns")

### Overview Of Neighbours

TBA

![Overview Of Neighbours](src/assets/readme_images/highlight_of_neighbours.png "Overview Of Neighbours")

### About Page

TBA

![About Page](src/assets/readme_images/about.png "About Page")

### Configuration
