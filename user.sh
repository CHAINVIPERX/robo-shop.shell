#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"


VALIDATION (){
    if [ $1 -eq 0 ];
    then 
        echo -e "$2 is ${CG}SUCCESSFUL${CN}"
    else
        echo -e "$2 has ${CR}FAILED${CN}"
        exit 1;
    fi
}

if [ $(id -u) != 0 ];
then
    echo -e "This script must be run as ${CY}ROOT USER${CN}"
    exit 1
else
    true;
fi

echo -e "Installing ${CY}Nodejs${CN}"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
VALIDATION $? "INSTALLING NODEJS"

echo "Creating User"
id roboshop
ES=$?
if [ $ES = 0 ];
then
    echo -e "User Already ${CY}Exists${CN}";
    echo -e "Do You want to ${CY}PROCEED-Y${CN} (or) Do You Want To ${CY}EXIT-N${CN}"
    read -r RESPONSE
    if [ "$RESPONSE" == "Y" ] || [ "$RESPONSE" == "y" ];
    then 
        true;
    elif [ "$RESPONSE" == "N" ] || [ "$RESPONSE" == "n" ];
    then
        echo -e "${CG}EXITING SCRIPT${CN}"
        exit 1;
    else
        echo -e "${CR}INVALID RESPONSE${CN}"
        return 1;
    fi
else 
    useradd roboshop;
fi
VALIDATION $? "CREATING USER"

mkdir /app
VALIDATION $? "CREATING DIRECTORY"
cd /app

echo "Downloading user.service"
wget https://roboshop-builds.s3.amazonaws.com/user.zip
unzip -o /app/user.zip
npm install
VALIDATION $? "Installing User.service"

cp /home/centos/robo-shop/user.service /etc/systemd/system/user.service
echo "Starting user.service"
systemctl daemon-reload
systemctl enable user
systemctl start user
VALIDATION $? "Starting User"
netstat -lntp

