#!/bin/bash -xe
echo "starting work..."

stack=
for FULLPATH in $(find /stack -type f -name "*.tar");do
  tar xf $FULLPATH
  stack=$(basename -- "$FULLPATH")
  extension="${stack##*.}"
  stack="${stack%.*}"
done
for FULLPATH in $(find /tfvars -type f -name "*.tar");do
  tar xf $FULLPATH -C $stack/tfvars
  tfvars=$(basename -- "$FULLPATH")
  extension="${tfvars##*.}"
  tfvars="${tfvars%.*}"
done

cd $stack
cp /tfstate/terraform.tfstate . || true

terraform init .
terraform plan -out plan.out -var-file tfvars/custom.tfvars
terraform apply plan.out

kubectl delete cm ${INSTANCE_NAME}-tfstate || true
kubectl create cm ${INSTANCE_NAME}-tfstate --from-file terraform.tfstate