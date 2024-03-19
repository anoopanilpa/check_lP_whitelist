#!/bin/bash

regions=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)

# Your IP address to check
MY_IP="IP here"

for region in $regions; do
 
# List of AWS security groups to check
SECURITY_GROUPS=$(aws ec2 describe-security-groups --region "$region" --query 'SecurityGroups[*].GroupId' --output text)

# Iterate through each security group
  for sg_id in $SECURITY_GROUPS ; do
      #echo "Checking security group: $sg_id"
      # Describe ingress rules of the security group
      aws ec2 describe-security-groups --region $region --group-ids "$sg_id" --query 'SecurityGroups[].IpPermissions[]' --output text | \
      while read -r line; do
          # Check if your IP is whitelisted
          if echo "$line" | grep -q "$MY_IP"; then
              echo "Your IP $MY_IP is whitelisted in security group $sg_id region $region"
              # You can exit here if you only want to know if your IP is whitelisted in any of the security groups.
              # exit 0
          fi
      done
  done

done
