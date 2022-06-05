# My seL4 and CAmkES projects

This repository should give an example on how to build your own projects with
the seL4 microkernel and CAmkES. Examplery projects can be found in
`src/main/project/my_projects`.

## Project Layout

To get a better understanding on how to build your own project, the following
page is a good starting point:

- <https://docs.sel4.systems/projects/buildsystem/incorporating.html>

The project structure of this repository is mainly influenced by the following
repositories:

- <https://github.com/seL4/sel4test-manifest>
- <https://github.com/seL4/camkes-manifest>
- <https://github.com/seL4/sel4-tutorials-manifest>

This repository features the following layout:

```
src/main/
|__ kernel/
|__ projects/
|   |__ my_projects/    # directory featuring my applications
|   |__ ...other libraries...
|__ tools/
|__ easy-settings.cmake
|__ griddle
|__ init-build.sh
```

## Build files

In the top-level directory there are the following build files:

- `griddle`: not important for this project
- `easy-settings.cmake`: Symbolic link to the `easy-settings.cmake` file in
  `src/main/projects/my_projects`
- `init-build.sh`: Symbolic link to the default `init-build.sh` script in
  `src/main/tools/cmake-tool/init-build.sh`. This file determines based on the
  `easy-settings.cmake` in which directory the build process should be started,
  i.e. `src/main/projects/my_projects`.

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

## Prerequisites

CAmkES and seL4 projects have a lot of dependencies that must be installed:

- <https://docs.sel4.systems/projects/buildsystem/host-dependencies.html>

If you do not want all the dependencies on the host machine, you can simply use
a Docker container:

- <https://docs.sel4.systems/projects/dockerfiles/>

## Guidelines

### Git

In this project, commit flags are used in order for the developer to have a
better understanding of what type a commit is. This project uses the following
commit flags:

- DEV: this flag refers to changes in the source code
- DOC: this flag refers to changes in the documentation, e.g. Readme files
- TEST: this flag refers to changes in test files
- FIX: this flag refers to a functional fix
- FORM: this flag refers to a fix that enhances the form, e.g. fixing spelling
  errors
- CICD: this flag refers to changes in the CICD pipeline

A commit has the following form:

```bash
<hash> [<commit-flag>] <commit-message>
```

## TODOs

- Implement linter stages.
- Create a simple CI/CD pipeline that builds and tests images for the Zynq7000
  and Zynqmp platform in QEMU.
- Add unit tests for printer and hello world application.
- Test the hello-world and printer app on the RPi4 hardware.
- Create the LED Matrix Driver.
- Create the LED Matrix App.
- Extend CI/CD pipeline to also include the RPi4.
- Extend CI/CD pipeline for a deployment stage onto RPi4.
