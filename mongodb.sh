#!/bin/bash
USER=$( id  -u )
R="\e[31m"
N="\e[0m"
G="\e[32m"


if [ $USER -ne 0 ]; then
    echo " take root user access"
    exit 1
fi

VALIDATE()
{
    if [ $1 -ne 0 ]; then
        echo -e "$2 .... $R failed $N"
    else 
        echo -e "$2 ...$G success $N"
    fi
}

dnf install mongodb-org -y 
VALIDATE $? "Installing mongodb"

systemctl enable mongod 
VALIDATE $? "enabling mongodb"

systemctl start mongod 
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/ 0.0.0.0' /etc/mongod.conf
VALIDATE $? "Update listen address"

systemctl restart mongod
VALIDATE $? "restart mangodb"
