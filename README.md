MaSyMoS Docker Image
====================

This git repository contains all scripts and links to resources for building a fully featured MaSyMoS Docker image.
[MaSyMoS](https://sems.uni-rostock.de/projects/masymos/) is a graph database for SystemsBiology models, developed within the [SEMS Project](https://sems.uni-rostock.de/) ([Repoistories](https://semsproject.github.io)).

This image includes following MaSyMoS modules:

  * [MaSyMoS-core](https://github.com/SemsProject/masymos-core)
  * [MaSyMoS-cli](https://github.com/SemsProject/masymos-cli)
  * [MaSyMoS-Morre](https://github.com/SemsProject/masymos-morre)
  * [MaSyMoS-diff](https://github.com/FreakyBytes/masymos-diff)
  * [MaSyMoS-diff-rest](https://github.com/FreakyBytes/masymos-diff-rest)

Use the Image
-------------

Using the image relatively straight forward. A precompiled version is available on [Docker Hub](https://hub.docker.com/r/freakybytes/masymos/).
Simply run:

```sh
docker run -it -p 7474:7474 -p 7687:7687 -v /path/to/masymos-data:/data freakybytes/masymos:latest
```

On the first startup the MaSyMoS image will import several ontologies into the underlaying neo4j database. These are relevant for interlinking models and build better indexes.
However this will take quite some time. (~2-4h)

Configure the Image
-------------------

Since this images is based on the [official Neo4j Docker image](https://hub.docker.com/_/neo4j/) all configuration mechanisms are also applicable to this image.
But keep in mind, that eg. mounting `/config` will override the MaSyMoS specific Neo4j config. For an overview of which configuration parameter were changed,
refer to the `patches/` directory.

Build the Image
---------------

Due to the extensive build process and the related consumtion of disk space for caching, we decided to split the process into two images:
The first one contains a build environment (`Dockerfile.build-env`) and the actual container running MaSyMoS (`Dockerfiler`). Unfortunetly this
implies, that the image is unsuitable for automated builds on Docker Hub. However to simplify building the image, we're shipping a bash script
automating the steps.

Before cloning this repository please ensure, that you have [Git LFS](https://git-lfs.github.com/) installed, since we use it to store the ontology files in this repository.
Then clone the repository with all sub-modules:

```sh
git clone --recursive git@github.com:SemsProject/masymos-docker.git
```

### The easy way

The simplest way to reproducibly build this MaSyMoS image is to run the shipped build script.

```sh
./build.sh
```

### The slightly more difficult way

Alternatively you may run the steps from `build.sh` yourself.

Start by building an image containing the build environment for MaSyMoS:

```sh
docker build -f Dockerfile.build-env -t masymos-build-env:latest .
```

Next let's utilize this environment to actually compile all MaSyMoS modules.
Doing so will run `scripts/build_masymos.sh` within the container. However to actually persist
the build result on your hard drive, we need to mount the `src` directory as volumne.

```sh
docker run --rm -t -v $(pwd)/src/:/root/src/ -e "SRC_DIR=/root/src"  masymos-build-env:latest
```

Finally we can build the actual MaSyMoS image
```sh
docker build -f Dockerfile -t freakybytes/masymos:latest .
```

Congratulations you're now able to [use the image](#use-the-image)!
