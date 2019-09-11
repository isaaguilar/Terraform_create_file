#!/bin/bash -xe
# Run at root of this repo
terraform init .
terraform plan -out plan.out
terraform apply plan.out