#!/bin/bash

# Displays the inbound rules for the security group associated with the instance running this script.



INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
FIREWALL_ID=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text`

aws ec2 describe-security-groups --group-ids $FIREWALL_ID --query "SecurityGroups[].IpPermissions[]" --output json
