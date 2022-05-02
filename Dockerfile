# Set the base image to ubuntu
# https://hub.docker.com/_/ubuntu
FROM ubuntu:20.04

RUN apt-get -qq update \
    && apt-get install -qq -y \
        bash \
        git

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN echo "Executing to execute ./entrypoint.sh script for v0.0.18"
# Workaround for permissions issue: https://github.com/actions/checkout/issues/760
RUN git config --global --add safe.directory /github/workspace

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
