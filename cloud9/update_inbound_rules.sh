#!/bin/bash


# Update the inbound rules for the security group that associated with the instance to execute this script.



# Valiables

CIDR=32
FROM_PORT=8080
TO_PORT=8082
DESCRIPTION='Allow access to client, posts and comments of Node.js app.'
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
FIREWALL_ID=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[].Instances[].SecurityGroups[].GroupId[]' --output text)


# aws ec2 describe-security-groups --group-ids $FIREWALL_ID --query 'SecurityGroups[].IpPermissions[]' --output json


# Revoke the inbound rules with a description that matches the one configured

for i in 0 1 2 
do
    I_DESCRIPTION=$(aws ec2 describe-security-groups --group-ids $FIREWALL_ID --query "SecurityGroups[].IpPermissions[$i].IpRanges[].Description[]" --output text)
    if [ "$I_DESCRIPTION" = "$DESCRIPTION" ];then
        CIDR_IP=$(aws ec2 describe-security-groups --group-ids $FIREWALL_ID --query "SecurityGroups[].IpPermissions[$i].IpRanges[].CidrIp[]" --output text)
        aws ec2 revoke-security-group-ingress \
            --group-id $FIREWALL_ID \
            --ip-permissions IpProtocol=tcp,FromPort=$FROM_PORT,ToPort=$TO_PORT,IpRanges="[{CidrIp=$CIDR_IP,Description='$DESCRIPTION'}]"
    fi
done


# Add inbound rules to allow only one ip address.
# To find out your own global ip address, for example, you can run `curl inet-ip.info`

echo -e "\nAllow access to this instance from the ipv4 address that input here (and press Enter Key): "
echo "e.g. 0.0.0.0" && read ALLOW_IP

if [ $ALLOW_IP = 0.0.0.0 ];then
    CIDR=0
elif [[ $ALLOW_IP =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$ ]];then
    :
else
    echo "ALLOW_IP: $ALLOW_IP is unavailable" && read
    exit 0
fi

aws ec2 authorize-security-group-ingress \
    --group-id $FIREWALL_ID \
    --ip-permissions IpProtocol=tcp,FromPort=$FROM_PORT,ToPort=$TO_PORT,IpRanges="[{CidrIp=$ALLOW_IP/$CIDR,Description='$DESCRIPTION'}]"
