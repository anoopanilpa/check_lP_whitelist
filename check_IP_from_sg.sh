#!/bin/bash

regions=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)

# Your IP address to check seperate by comma
MY_IP=192.168.10.12,192.168.10.11,192.168.10.13

for region in $regions; do
 
# List of AWS security groups to check
SECURITY_GROUPS=$(aws ec2 describe-security-groups --region "$region" --query 'SecurityGroups[*].GroupId' --output text)

# Iterate through each security group
  for sg_id in $SECURITY_GROUPS ; do
      #echo "Checking security group: $sg_id"
      # Describe ingress rules of the security group
   for i in $(echo $MY_IP | sed "s/,/ /g"); do 
      aws ec2 describe-security-groups --region $region --group-ids "$sg_id" --query 'SecurityGroups[].IpPermissions[]' --output text | \
      while read -r line; do
          # Check if your IP is whitelisted
          if echo "$line" | grep -q "$i"; then
              echo "Your IP $i is whitelisted in security group $sg_id region $region"
              # You can exit here if you only want to know if your IP is whitelisted in any of the security groups.
              # exit 0
          fi
      done
      aws ec2 describe-security-groups --region $region --group-ids "$sg_id" --query 'SecurityGroups[].IpPermissionsEgress[]' --output text | \
      while read -r line; do
              if echo "$line" | grep -q "$i"; then
                      echo "Your IP $i is whitelisted in security group $sg_id region $region"
              fi
      done
   done   
  done

done
