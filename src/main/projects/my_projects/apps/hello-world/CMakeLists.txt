cmake_minimum_required(VERSION 3.7.2)

project(hello-world C)

DeclareCAmkESComponent(Client SOURCES client.c)

DeclareCAmkESRootserver(hello.camkes)
