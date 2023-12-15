#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

ID=$(id -u)
if [ $ID -ne 0 ]; then
    echo -e "Please Run this Script as $CY ROOT USER $CN"
    exit 1
else
    echo -e " $CG ROOT USER $CN"
fi