# Challenge - Hello World
This functions as a basic example, of how to create a challenge for OCTP.
This example will take base in a Docker based challenge, whereas other challenge types can be seen in **coming soon**.

## Creating the Dockerfile
The most important aspects of this, is understanding the different components and how they function together.

A full reference of how a Dockerfile works, can be found [here](https://docs.docker.com/engine/reference/builder/).

```
# What we base our challenge on, could be Debian, Ubuntu, etc.
# But using Alpine is good, since its footprint (size) is around 5.5MB
FROM alpine:3.9

# Can be omitted, basically just tells who made it
# and who maintains the Dockerfile
LABEL maintainer="eyJhb <eyjhbb@gmail.com>"

# Current version of the challenge
# specified as MAYOR.MINOR(.PATCH)
ENV VERSION 1.0

# This will be used, to generate the 
# flag when the Docker container is started.
# This also tells that it supports dynamic flags.
# The param can be omitted, if there is not a possibility
# to change the flag at start
ENV FLAG CTF{1337HelloToYou!}

# Tell whichs ports needs to be exposed,
# before this challenge is sovleable (80/tcp).
# Will be used for mapping to another port.
EXPOSE 80

# Install nginx and make two directories.
RUN \
    apk add --no-cache nginx && \
    mkdir -p /run/nginx/ && \
    mkdir -p /var/www/html/

# Copy everything into the root of our container.
# Keep in mind! The structure of src follows that of
# the root of the container (e.g. /etc).
COPY src /

# Make this our entrypoint (what is run when the container starts)
ENTRYPOINT ["./init.sh"]
```

Reading the above Dockerfile, it should be fairly self explanatory how to make your own.
The most important params, that will be used by OCTP are the following:

- VERSION - tells which version of the challenge this is
- FLAG - tells whether or not dynamic changing the flag is supported
- EXPOSE - which ports needs to be exposed, for this challenge to work (should almost always be at least one)

## FLAG environment
If the contestants might be able to get a shell or read environment variables, then it is crucial that the FLAG environment gets safely deleted.
This can be done using the following.

```
echo $FLAG > /flag.txt
if [ ! -z $FLAG ]; then
    unset FLAG
    exec sh /init.sh
fi 
```

Make sure that this is at the beginning of the file, right after `#!/bin/sh`, as any process creating in the `init.sh` script, will have the FLAG environment set.
But what happens it that we put the flag where we want it, unset the FLAG environment variables and spawn a new shell which replaces our old shell, which calls the same `init.sh` file.
By doing this, the FLAG environment is gone.
If this is not there, the flag can still be read from `/proc/1/environ`.

## Naming of challenges (subject to change)
All challenges should be prefixed with `chal-`, then a maximum of two tags e.g. `chal-web-sqli.`, followed by a delimiter `.` and then lowercase name as e.g. `chal-web-sqli.last-man-standing`.
Remember only the following chars are allowed for naming a challenge [a-z0-9.-].

Please file a issue if there are any questions or problems!
