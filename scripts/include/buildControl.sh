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

    DOCKER_BUILDKIT=1
    DOCKERFILE_NAME="galactic-cuda.Dockerfile"

    IMAGE_NAME="${CONTAINER_BUILD_USERNAME}/sitl-ros2"
    IMAGE_TAG="galactic-cuda-tensorrt-full"

    # REPLACE THE BASE IMAGE
    sed -i "s|nvidia/cuda:11.7.0-runtime-ubuntu20.04|nvcr.io/nvidia/tensorrt:22.12-py3|g" \
        ${RESOURCE_DIR}/ROS2/ros2/${DOCKERFILE_NAME}

    # FIND A LINE NUMBER WHICH CONTAINS "FROM full AS gazebo"
    GAZEBO_STAGE_LINE=$(grep -n "FROM full AS gazebo" ${RESOURCE_DIR}/ROS2/ros2/${DOCKERFILE_NAME} | cut -d: -f1)
    # DELETE FROM GAZEBO_STAGE_LINE - 3 TO THE END OF THE FILE

    if [ ! -z ${GAZEBO_STAGE_LINE} ]; then
        sed -i "${GAZEBO_STAGE_LINE},\$d" \
            ${RESOURCE_DIR}/ROS2/ros2/${DOCKERFILE_NAME}
    fi

    # READ ADDITIONAL PACKAGES LINE BY LINE FROM ${RESOURCE_DIR}/pyDeps.txt
    # SAVE IT TO SPACE SEPARATED STRING
    ADDITIONAL_PACKAGES=$(cat ${RESOURCE_DIR}/pyDeps.txt | tr '\n' ' ')

    # INSTALL torch and gym
    sed -i "s|pip install --upgrade pydocstyle|pip install --upgrade pydocstyle ${ADDITIONAL_PACKAGES}|g" \
            ${RESOURCE_DIR}/ROS2/ros2/${DOCKERFILE_NAME}

    BUILD THE IMAGE
    docker build \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -f ${RESOURCE_DIR}/ROS2/ros2/${DOCKERFILE_NAME} \
        ${RESOURCE_DIR}/ROS2/ros2

    # REVERT THE CHANGES
    git -C ${RESOURCE_DIR}/ROS2 reset --hard
    git -C ${RESOURCE_DIR}/ROS2 clean -fdx
}
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<