#!/bin/bash

# Container name
CONTAINER_NAME="stju_humble"

# Directory for volume mounting your ros2_ws for persistent storage
WORKDIR="/workdir"

# Allow access to X server on your host
xhost +local:docker

# Check if the container is already running
if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Container is already running. Connecting..."
    docker exec -it ${CONTAINER_NAME} bash entrypoint.sh
else
    echo "Starting the Docker container..."
    # Run the Docker container with GUI support and custom startup command
    docker run -it \
               --name ${CONTAINER_NAME} \
               --rm \
               --privileged \
               -e DISPLAY=$DISPLAY \
               -v ${PWD}:${WORKDIR} \
               -v /tmp/.X11-unix:/tmp/.X11-unix \
               --network=host \
               --workdir=${WORKDIR} \
               ${CONTAINER_NAME}
fi

# Revoke the access to X server after the container is closed
xhost -local:docker