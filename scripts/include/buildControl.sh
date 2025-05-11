#!/bin/bash

# FUNCTION TO BUILD CONTAINERS

BuildAirSimContainer() {
    # FUNCION TO BUILD AIRSIM CONTAINER
    # >>>------------------------------------------------
    # INPUTS:
    # $1: SCRIPT NAME
    # $2: RESOURCE DIRECTORY
    # ---------------------------------------------------
    # EXAMPLE:
    # BuildAirSimContainer $0 ${REPO_DIR}/Dockerfiles/AirSim
    # ---------------------------------------------------
    SCRIPT_NAME=$(basename "$1")
    RESOURCE_DIR=$2

    DOCKER_BUILDKIT=1
    BASE_NAME="docker.io/adamrehn/ue4-runtime"
    BASE_TAG="22.04-cudagl12-x11"

    IMAGE_NAME="${CONTAINER_BUILD_USERNAME}/airsim"
    IMAGE_TAG=${BASE_TAG}

    docker build \
        --build-arg BASE_NAME=${BASE_NAME} \
        --build-arg BASE_TAG=${BASE_TAG} \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -f ${RESOURCE_DIR}/Dockerfile \
        ${RESOURCE_DIR}
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

BuildQGCContainer() {
    # FUNCION TO BUILD QGC CONTAINER
    # >>>------------------------------------------------
    # INPUTS:
    # $1: SCRIPT NAME
    # $2: RESOURCE DIRECTORY
    # ---------------------------------------------------
    # EXAMPLE:
    # BuildQGCContainer $0 ${REPO_DIR}/Dockerfiles/QGroundControl
    # ---------------------------------------------------
    SCRIPT_NAME=$(basename "$1")
    RESOURCE_DIR=$2

    DOCKER_BUILDKIT=1
    BASE_NAME="ubuntu"
    BASE_TAG="22.04"

    IMAGE_NAME="${CONTAINER_BUILD_USERNAME}/qgc-app"
    IMAGE_TAG="4.4.0"

    docker build \
        --build-arg BASE_NAME=${BASE_NAME} \
        --build-arg BASE_TAG=${BASE_TAG} \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -f ${RESOURCE_DIR}/Dockerfile \
        ${RESOURCE_DIR}
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

BuildROS2Container() {
    # FUNCION TO BUILD ROS2 CONTAINER
    # >>>------------------------------------------------
    # INPUTS:
    # $1: SCRIPT NAME
    # $2: RESOURCE DIRECTORY
    # ---------------------------------------------------
    # EXAMPLE:
    # BuildROS2Container $0 ${REPO_DIR}/Dockerfiles/ROS2
    # ---------------------------------------------------
    SCRIPT_NAME=$(basename "$1")
    RESOURCE_DIR=$2

    ROS_DISTRO="humble"

    DOCKER_BUILDKIT=1
    DOCKERFILE_NAME="Dockerfile"

    IMAGE_NAME="reg.iacsl.org/a4-vai/a4vai-sils-container"
    IMAGE_TAG="${ROS_DISTRO}-cuda12.6-tensorrt10.7-cudnn9.7"


    # BUILD THE IMAGE
    docker build \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -f ${RESOURCE_DIR}/${DOCKERFILE_NAME} \
        ${RESOURCE_DIR}

    # # REVERT THE CHANGES
    # git -C ${RESOURCE_DIR}/ROS2 reset --hard
    # git -C ${RESOURCE_DIR}/ROS2 clean -fdx
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<