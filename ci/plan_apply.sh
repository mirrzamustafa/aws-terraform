#!/usr/bin/env bash

set -e

if [ -z $1 ] || [ -z $2 ]; then #if arguments not passed
    echo 'Usage: ./plan_apply.sh <workspace> print|apply'
    exit 1
fi

# Switch to new workspace
terraform -chdir=terraform/ workspace select -or-create $1

# Create plan 
terraform -chdir=terraform/ plan -var-file=vars/terraform.tfvars -out $1.plan

if [ "$2" = 'print' ]; then 
    terraform -chdir=terraform/ show $1.plan
elif [ "$2" = 'apply' ]; then
    terraform -chdir=terraform/ apply $1.plan
fi

