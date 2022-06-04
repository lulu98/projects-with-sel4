cmake_minimum_required(VERSION 3.7.2)

project(printer-app C)

set(CAmkESCPP ON CACHE BOOL "" FORCE)
includeMyComponents()

DeclareCAmkESComponent(Client SOURCES components/Client/src/client.c)
DeclareCAmkESComponent(Printer SOURCES components/Printer/src/printer.c)

DeclareCAmkESRootserver(printer-app.camkes)
