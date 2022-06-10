#!/bin/bash

BUILD_PLATFORMS=(
    zynq7000
    #zynqmp
    #rpi4
)

BUILD_APPS=(
    hello-world
    printer
)

CONTAINER_NAME="build-container"
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname ${SCRIPT}`

# create docker build container
( cd build-dependencies; make user HOST_DIR=${SCRIPTPATH} CONTAINER_NAME=${CONTAINER_NAME} )

for PLATFORM in "${BUILD_PLATFORMS[@]}"
do
    for CAMKES_APP in "${BUILD_APPS[@]}"
    do
        if [ "${PLATFORM}" = "rpi4" ]
        then
            EXTRA_ARGS+=" -DAARCH64=ON"
        fi

        if [ "${PLATFORM}" = "zynq7000" || "${PLATFORM}" = "zynqmp" ]
        then
            EXTRA_ARGS+=" -DSIMULATION=ON"
        fi

        BUILD_DIR="build_${CAMKES_APP}_${PLATFORM}"
        DOCKER_COMMANDS="mkdir ${BUILD_DIR}; \
                         cd ${BUILD_DIR}; \
                         ../main/init-build.sh ${EXTRA_ARGS} -DPLATFORM=${PLATFORM} -DCAMKES_APP=${CAMKES_APP}; \
                         ninja"

        echo ""
        echo "#################################################################"
        echo "App: ${CAMKES_APP}, Platform: ${PLATFORM}"
        echo "#################################################################"
        echo ""

        # build binary for all platforms and apps
        docker exec -w /host ${CONTAINER_NAME} bash -c "${DOCKER_COMMANDS}"
    done
done

# stop docker build container
docker stop ${CONTAINER_NAME}
