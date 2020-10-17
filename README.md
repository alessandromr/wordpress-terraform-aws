# Scalable, HA WordPress deploy on AWS with Terraform

## Requirements

- Terraform 0.13.4 or tfswitch

## Local State (Warning)

This repo is intended as a simple demonstration of a scalable deployment of WordPress on AWS. For this example Terraform's state is mainteined locally. this approach is risky to use on real word resources, instead use a remote backend like S3+Dynamo or the simpler Terraform Cloud.  

[S3 backend](https://www.terraform.io/docs/backends/types/s3.html)
[Terraform Cloud](https://www.terraform.io/)

## Deploy guide

This repository use multiple terraform stack to improve readability and to reduce blast radius in case of human errors, the cons is that deploy is a little bit longer. 

### First Deploy:  

1. ```bash
    cd ./terraform/infra/shared
    terraform init
    terraform workspace new prod
    terraform apply --var-file=terraform.prod.tfvars
    ```

### Successive deploys

If the stack has already been deployed and you have a local state ready, you can avoid the workspace creation (`terraform workspace new prod`) and instead use `terraform workspace select prod` to select the already existing workspace.

### Destroy

```bash
    terraform destroy --var-file=terraform.prod.tfvars
```
