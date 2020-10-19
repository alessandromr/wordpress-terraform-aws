# Scalable, HA WordPress deploy on AWS with Terraform

## Requirements

- Terraform 0.13.4 or tfswitch
- awscli

## Implementations

### Computing

WordPress is hosted on ECS (EC2) and is containerized. Containers scale with use, Cluster scale to allows containers scaling (ECS Capacity Provider).

### Database

Mysql database is hosted on RDS using Aurora Mysql compatible. The database can scale the number of read-replica automatically based on CPU utilization and connections count.

### Application Caching

A Redis cluster is implemented and can be used for:

1. Object caching
2. Session storing

Some WordPress plugins and themes use native PHP sessions, to host WordPress behind a load balancer is necessary to distribuited those sessions.
Settings about Redis are configured in `php.ini` and natively supported by php and php-redis extension.  

Redis cluster is provisioned with Elasticache and is replicated in multiple AZs.

## Application Build

Docker images are stored in AWS ECR repository created with the first stack `shared`. So images must be pushed after deploying the first stack.

### Image Push

```bash

#wordpress
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 629528675260.dkr.ecr.eu-west-1.amazonaws.com
docker build -t example-site-shared-infra-prod-wordpress .
docker tag example-site-shared-infra-prod-wordpress:latest 629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-wordpress:latest
docker push 629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-wordpress:latest

#nginx
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 629528675260.dkr.ecr.eu-west-1.amazonaws.com
docker build -t example-site-shared-infra-prod-nginx .
docker tag example-site-shared-infra-prod-nginx:latest 629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-nginx:latest
docker push 629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-nginx:latest
```

Where `629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-nginx:latest` and `629528675260.dkr.ecr.eu-west-1.amazonaws.com/example-site-shared-infra-prod-wordpress:latest` are the URLs to your ECR repository.


## Deploy guide

### Workspaces

This repository utilizes Terraform Workspaces, S3 back-end and DynamoDB lock. Workspaces must be considered as environments, so for each environment you must have a workspace.
During the first deploy you will have to create the workspace.  

Create a workspace:
```bash
    terraform workspace new prod
```

Select a workspace:
```bash
    terraform workspace select prod
```

Show current workspace:
```bash
    terraform workspace show
```

List workspaces:
```bash
    terraform workspace list
```

Terraform will confirm the current workspaces during `apply` or `destroy` phase:
```bash
Do you want to perform these actions in workspace "prod"?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: 
```

### Var Files

This repository utilizes var-files, one for each environment. You must specify the correct var-file for your environment during `plan`, `apply` and `destroy`.

```bash
    terraform plan --var-file=terraform.prod.tfvars
    terraform apply --var-file=terraform.prod.tfvars
    terraform destroy --var-file=terraform.prod.tfvars
```

### Deploy Order

1. shared
2. cluster
3. data
4. services

### First Deploy

Before start deploying your infrastructure you have to provision an S3 bucket and a DynamoDB table for the remote backend. References of the bucket and dynamo table can be found in `main.tf` and `remote-state.tf` of each file.

1. ```bash
    cd ./terraform/infra/shared
    terraform init
    terraform workspace new prod
    terraform apply --var-file=terraform.prod.tfvars
    ```

2. ```bash
    cd ../cluster/
    terraform init
    terraform workspace new prod
    terraform apply --var-file=terraform.prod.tfvars
    ```

### Successive deploys

If the stack has already been deployed and you have a state on your remote backend, you can avoid the workspace creation (`terraform workspace new prod`) and instead use `terraform workspace select prod` to select the already existing workspace.

### Destroy

#### Notes:  

ASG is created with `protect_from_scale_in` set to true, to avoid ASG killing instances with active containers running.
With this parameter enabled terraform will wait for the user to terminate instances during `destroy` phase manually. 
So is necessary to terminate instances of ASG manually during `destroy` phase.

This behaviour is intended and expected from Terraform.

#### Commands

```bash
    terraform destroy --var-file=terraform.prod.tfvars
```

## Errors

The stack is probably not supported on account that still have the old ECS ARN format. Please opt into the new format as advised by AWS.  
[Reference](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html#ecs-resource-ids)  

## Missing Points

1. Full ARM support
2. Wordpress on alpine linux OR smaller wordpres image
3. Custom domain and SSL 
4. Static assets with S3
5. Monitoring and Alerting
6. Backup and restore
7. Better nginx configuration
