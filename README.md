# VB Build Script

This REPO contains a script to modify the vectorboost makefile to compile amd64 and aarch64 releases  

## Install

First install required compiles and cross compilers  
`apt-get update`  
`apt-get install -y gcc g++ gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu`  

## Build release

Clone the Repo  
Run the script  
`./build.sh`  

You will find the tgz file for amd64 and arm64 in the GigaWireVB/release folder  
