#!/bin/bash

Ami_ID=ami-09c813fb71547fc4f
SG_ID=sg-0bc221ac9b59215f1

for instance in $@
do 
    INSTANCE_ID=$(aws ec2 run-instances --image-id $Ami_ID --instance-type t3.micro $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Test}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ]; then
        aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text
    else
        aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
    fi

    echo "$instance: $IP"
done