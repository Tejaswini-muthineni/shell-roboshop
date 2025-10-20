#!/bin/bash

Ami_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0bc221ac9b59215f1"
ZONE_ID="Z00857241KJ14NJD1V1NJ"
DOM_NAME="tejadevops.fun"

for instance in $@
do 
    INSTANCE_ID=$(aws ec2 run-instances --image-id $Ami_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
        RECORD_NAME="$instance.$DOM_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
        RECORD_NAME="$instance.$DOM_NAME"
    fi

    echo "$instance: $IP"
    
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Updating record set"
        ,"Changes": [{
        "Action"              : "UPSERT"
       ,"ResourceRecordSet"  : {
            "Name"              : "'$RECORD_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
            "Value"         : "'$IP'"
            }]
        }
        }]
    }
    '
done