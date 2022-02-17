# terraform-ecs-demo
This repo contains a Terraform project that will set up a VPC with 3 public and 3 private subnets on AWS and an ECS deployment of [react-wordle](https://github.com/cwackerfuss/react-wordle) using CircleCI as the CI/CD tooling. CircleCI will build the [react-wordle](https://github.com/cwackerfuss/react-wordle) docker image and push it to an ECR repo and then create a new task definition revision and update the ECS service with then new revision of the task definition. The app can be accessed through the DNS name of the load balancer that is spun up with the terraform project.

## Instructions

```
git clone https://github.com/DrCrinkle/terraform-demo.git
cd terraform-demo
terraform init
terraform apply -var-file=./config/sample.tfvars
```

In CircleCI the following environment variables will need to be filled in
```
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID
AWS_DEFAULT_REGION - the region where your ECS cluster is located
AWS_ECR_ACCOUNT_URL
AWS_REGION - the region where your ECR repo is located
AWS_RESOURCE_NAME_PREFIX
AWS_SECRET_ACCESS_KEY
```
