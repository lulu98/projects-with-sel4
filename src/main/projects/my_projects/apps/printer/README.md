# Printer application

A small demo application that has two CAmkES components interact to print
something on the screen. Furthermore, a TimeServer component is used to
demonstrate access to a hardware device of a board.

## Build instructions

To build this application for the `sabre7000` platform, execute the following
commands:

```bash
mkdir build
cd build
../init-build.sh -DAARCH32=TRUE -DPLATFORM=zynq7000 -DCAMKES_APP=printer
```

The binary located in the `images` directory can be executed on a real board.

## Simulation instructions

The application can be run as a simulation in QEMU with the following commands:

```bash
mkdir build
cd build
../init-build.sh -DAARCH32=TRUE -DPLATFORM=zynq7000 -DSIMULATION=ON -DCAMKES_APP=printer
```
