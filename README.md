# My seL4 and CAmkES projects

This repository should give an example on how to build your own projects with
the seL4 microkernel and CAmkES. This project basically provides a thing wrapper
around the seL4 microkernel and supporting libraries. As a result, it could
theoretically be extended to an Operating System (OS) that is based on the seL4
microkernel. Exemplary projects can be found in `src/main/project/my_projects/`.

## Building an application

Sample applications for this project are located at `src/main/projects/my_project/apps`
and can be invoked with the `-DCAMKES_APP` compiler flag. If you want to build the
`hello-world` application in `src/main/projects/my_projects/apps/hello-world`
execute the following commands:

```bash
mkdir build
cd build
../init-build.sh -DPLATFORM=<platform> -DCAMKES_APP=hello-world
ninja
```

### Running on real HW

After letting `ninja` build the application for a platform, you can find the
binary image in the `build/images` directory. This image can be copied on a
micro-SD card and will be loaded and executed by the FSBL and SSBL.

### Simulation in QEMU

If you do not have access to the real hardware, you can add the `-DSIMULATION=ON`
compiler flag and then simulate the built image in QEMU:

```bash
mkdir build
cd build
../init-build.sh -DPLATFORM=x86_64 -DSIMULATION=ON -DCAMKES_APP=hello-world
ninja
./simulate
```

## Build dependencies

CAmkES and seL4 projects have a lot of dependencies that must be installed:

- <https://docs.sel4.systems/projects/buildsystem/host-dependencies.html>

If you do not want all the dependencies on the host machine, you can simply use
a Docker container:

- <https://docs.sel4.systems/projects/dockerfiles/>

## Wiki

For more detailed information on the implementation of this project, please
refer to the following Wiki:

- [Project Wiki](https://github.com/lulu98/projects-with-seL4/wiki)
