# rpi-ruby #

A Dockerfile which creates a ARM docker container similar to the library/ruby container on Docker Hub (https://registry.hub.docker.com/u/library/ruby/). 

The image for this is available on Docker Hub: https://registry.hub.docker.com/u/aggronerd/rpi-ruby/

## Usage ##

After you have installed Docker on your Raspberry Pi clone this repo and run:

> docker build .

You can overwrite the environmental vales in the Dockerfile to download and build different versions of Ruby.
