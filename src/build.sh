#!/bin/bash

BUILD_APPS_PLATFORMS=(
    "hello-world zynq7000 rpi4"
    "printer     zynq7000"
)

CONTAINER_NAME="build-container"
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname ${SCRIPT}`

# create docker build container
( cd build-dependencies; make user HOST_DIR=${SCRIPTPATH} CONTAINER_NAME=${CONTAINER_NAME} )

for APPS_PLATFORMS_STRING in "${BUILD_APPS_PLATFORMS[@]}"
do
    APPS_PLATFORMS_ARR=(${APPS_PLATFORMS_STRING})
    CAMKES_APP="${APPS_PLATFORMS_ARR[0]}"    # get 1st elem
    PLATFORMS=("${APPS_PLATFORMS_ARR[@]:1}") # get array starting from 2nd elem

    for PLATFORM in "${PLATFORMS[@]}"
    do
        if [ "${PLATFORM}" == "rpi4" ]
        then
            EXTRA_ARGS+=" -DAARCH64=ON"
        fi

        if [ "${PLATFORM}" == "zynq7000" ]
        then
            EXTRA_ARGS+=" -DSIMULATION=ON"
        fi

        BUILD_DIR="build_${CAMKES_APP}_${PLATFORM}"
        DOCKER_COMMANDS="mkdir ${BUILD_DIR}; \
                         cd ${BUILD_DIR}; \
                         ../main/init-build.sh ${EXTRA_ARGS} -DPLATFORM=${PLATFORM} -DCAMKES_APP=${CAMKES_APP}; \
                         ninja"

        echo "#################################################################"
        echo "Build - App: ${CAMKES_APP}, Platform: ${PLATFORM}"
        echo "#################################################################"

        # build binary for all platforms and apps
        docker exec -w /host ${CONTAINER_NAME} bash -c "${DOCKER_COMMANDS}"

        # check exit status of docker exec command
        if [ $? -ne 0 ]
        then
            echo "Build application ${CAMKES_APP} for ${PLATFORM} failed!"
            docker stop ${CONTAINER_NAME}
            exit 1
        fi
        
        echo "#################################################################"
        echo "Build successful."
        echo "#################################################################"
    done
done

# stop docker build container
docker stop ${CONTAINER_NAME}
