#!/bin/bash

Ami_ID=ami-09c813fb71547fc4f
SC_ID=sg-0bc221ac9b59215f1

for instance in $@
do 
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0bc221ac9b59215f1 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Test}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ]; then
        aws ec2 describe-instances --instance-ids i-041dd8db66031288f --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text
    else
        aws ec2 describe-instances --instance-ids i-041dd8db66031288f --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
    fi

    echo "$instance: $IP"
done