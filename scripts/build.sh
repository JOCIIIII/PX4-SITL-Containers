#!/bin/bash

# SCRIPT TO BUILD CONTAINERS

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
REPO_DIR=$(dirname $(dirname $(readlink -f "$0")))

DOCKER_BUILDKIT=1

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
for file in ${BASE_DIR}/include/*.sh; do
    source ${file}
done
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# INPUT STATEMENT 1 VALIDITY CHECK
# >>>----------------------------------------------------

# DECLARE DICTIONARY OF USAGE STATEMENTS 1
## KEY: ARGUMENT, CONTENT: DESCRIPTION
declare -A usageState1
usageState1["all"]="Build all containers"
usageState1["airsim"]="Build AirSim container"
usageState1["qgc"]="Build QGroundControl container"
usageState1["ros2"]="Build ROS2 container"

CheckValidity $0 usageState1 1 "$@"
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# RUN PROCESS PER ARGUMENT
# >>>----------------------------------------------------

# CREATE PLACEHOLDER FOR INPUT STATEMENTS
if [ "$1x" == "allx" ]; then
    RESOURCE_DIR=${REPO_DIR}/Dockerfile/AirSim
    BuildAirSimContainer $0 ${RESOURCE_DIR}

    RESOURCE_DIR=${REPO_DIR}/Dockerfile/QGroundControl
    BuildQGCContainer $0 ${RESOURCE_DIR}

    RESOURCE_DIR=${REPO_DIR}/Dockerfile/ROS2
    BuildROS2Container $0 ${RESOURCE_DIR}
elif [ "$1x" == "airsimx" ]; then
    RESOURCE_DIR=${REPO_DIR}/Dockerfile/AirSim
    BuildAirSimContainer $0 ${RESOURCE_DIR}
elif [ "$1x" == "qgcx" ]; then
    RESOURCE_DIR=${REPO_DIR}/Dockerfile/QGroundControl
    BuildQGCContainer $0 ${RESOURCE_DIR}
elif [ "$1x" == "ros2x" ]; then
    RESOURCE_DIR=${REPO_DIR}/Dockerfile/ROS2

    BuildROS2Container $0 ${RESOURCE_DIR}
fi
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<