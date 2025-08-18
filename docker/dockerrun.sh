#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No argument provided."
    echo "Usage: $0 <mode>"
    echo ""
    echo "Arguments:"
    echo "   0   Build the Docker image (gcc-scons-container)."
    echo "   1   Run the Docker container using the existing image."
    echo ""
    echo "Example:"
    echo "   $0 0   # Build the container"
    echo "   $0 1   # Run the container"
    exit 1
fi


# Build mode
if [ "$1" == "0" ]; then
    echo "Building Docker image..."
    docker build -t rco-container .

    ## kills existing containers if it exists:
    docker ps -q --filter "name=rco-env" | grep -q . && docker stop rco-env && docker rm -fv rco-env
fi

# Run mode
if [ "$1" == "1" ]; then
    echo "Running Docker container..."
    docker run -it --rm --name rco-env \
        -v $(realpath ../NimishMishra-randomized_caches-fc07ea6):/code \
        rco-container
fi
