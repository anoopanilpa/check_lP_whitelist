#!/bin/bash

# List all EBS volumes, their sizes, and attached instance (if any)
echo "Volume ID     Size (GB)    Attached Instance ID"
echo "==============================================="

# Get volume information
aws  --profile mine ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,Attachments[0].InstanceId]' --output text | \
while read -r volume_id size instance_id; do
    if [ -z "$instance_id" ]; then
        instance_id="Not Attached"
    fi
    # Convert size to GB
    size_gb=$((size / 1024))
    echo "$volume_id     $size     $instance_id"
done
