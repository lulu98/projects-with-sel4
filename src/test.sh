#!/bin/bash

TEST_PLATFORMS=(
    zynq7000
)

TEST_APPS=(
    hello-world
    printer
)

CONTAINER_NAME="test-container"
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname ${SCRIPT}`

# create docker test container
( cd build-dependencies; make user HOST_DIR=${SCRIPTPATH} CONTAINER_NAME=${CONTAINER_NAME} )

for PLATFORM in "${TEST_PLATFORMS[@]}"
do
    for CAMKES_APP in "${TEST_APPS[@]}"
    do
        if [ "${PLATFORM}" == "rpi4" ]
        then
            EXTRA_ARGS+=" -DAARCH64=ON"
        fi

        if [ "${PLATFORM}" == "zynq7000" ]
        then
            EXTRA_ARGS+=" -DSIMULATION=ON"
        fi
            
        TEST_DIR="test_${CAMKES_APP}_${PLATFORM}"
        DOCKER_COMMANDS="mkdir ${TEST_DIR}; \
                         cd ${TEST_DIR}; \
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

        # test the binaries in QEMU 
        patch -p1 ${TEST_DIR}/simulate test/unit_tests/template.patch

        echo "#################################################################"
        echo "Test - App: ${CAMKES_APP}, Platform: ${PLATFORM}"
        echo "#################################################################"
        
        QEMU_SIMULATE_COMMAND=$(./${TEST_DIR}/simulate)
        QEMU_SIMULATE_COMMAND=$(echo $QEMU_SIMULATE_COMMAND | sed 's/ *$//g') # trim trailing space
        cp test/unit_tests/${CAMKES_APP}.py test/unit_tests/conftest.py ${TEST_DIR}
        ( cd ${TEST_DIR}; pytest -s ${CAMKES_APP}.py --qemu_sim_cmd "${QEMU_SIMULATE_COMMAND}" )

        # check exit status of pytest command
        if [ $? != 0 ]
        then
            echo "Test application ${CAMKES_APP} for ${PLATFORM} failed!"
            docker stop ${CONTAINER_NAME}
            exit 1
        fi
        
        echo "#################################################################"
        echo "Test successful."
        echo "#################################################################"
    done
done

# stop docker test container
docker stop ${CONTAINER_NAME}
