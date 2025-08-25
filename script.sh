#!/bin/bash

# Define variables for your setup
MAIN_VM_ADI="test"
MIG_ADI="instance-group-1"
ZONE="europe-north1-a"
MACHINE_TYPE="n1-standard-4"

# Generate a unique name for the image and template
NEW_NAME="mig-vm-$(date +%Y%m%d%H%M%S)"

# --- Step 1: Stop the main VM to ensure data consistency ---
gcloud compute instances stop $GOLDEN_VM_ADI --zone=$ZONE

# --- Step 2: Create a new custom image from the VM's disk ---
# The disk name is assumed to be the same as the VM name for simplicity
gcloud compute images create $NEW_NAME --source-disk=$GOLDEN_VM_ADI --source-disk-zone=$ZONE --force

# --- Step 3: Create a new instance template from the new image ---
gcloud compute instance-templates create $NEW_NAME --machine-type=$MACHINE_TYPE --region=${ZONE%-*} --image=$NEW_NAME --no-address

# --- Step 4: Update the MIG to use the new template ---
gcloud compute instance-groups managed rolling-action start-update $MIG_ADI --version=template=$NEW_NAME --zone=$ZONE --proactive

echo "Automation complete: MIG updated to use template $NEW_NAME"
