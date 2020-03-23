# NodeJS-MongoDB-Demo (Jenkins + Terraform)

forked to build and deploy source codes to Docker engine by Infra-As-Code methods.
## Getting Started - Terraform
### Prerequisites

NodeJS-MongoDB-Demo has a minimum Terraform dependency of 0.12.

## 1. Install Docker
Install [Docker for Win](https://docs.docker.com/docker-for-windows/) if
you have not already.
## 2. Install Terraform
Grab the latest Terraform binary for Windows from [www.terraform.io](https://www.terraform.io/downloads.html) and place the `terraform` binary somewhere in your `PATH`.
## 3. Build Image
Build application image from `Dockerfile` file:
```
docker build -t app:1.0.0 .
```
## 4. Plan & Apply
Provision Docker container by [Terraform](.www.terraform.io).
### Initialize Terraform:

```
terraform init
```
### Generate Plan

Now, if the output from `terraform init` was without error, generate the plan:

```
terraform plan
```

### Apply Plan

Finally, if the plan is all good and without error, apply it:

```
terraform apply -auto-approve
```

The apply should complete without error and if so, you can move on to verifying the container status.

### Verify Container Status

Verify that the container is running:

```
docker ps  --format "table {{.Names}}\t{{.Status}}"
```

The output should have something like this:

```
NAMES           STATUS
app             Up 1 minutes (healthy)
db              Up 1 minutes (healthy)
```


## Getting Started - CD by Jenkins
## 1. Build builder
Build Jenkins image with `dind`(Docker in Docker) and Terraform:
```
cd terraform/jenkins
docker build -t jenkins:dind .
```
## 2. Deploy builder
Deploy Jenkins by Terraform
```
terraform init
terraform apply -auto-approve
```
## 3. Init admin password
Copy initial password from logs to enter at Jenkins console `http://localhost:8080`
```
docker logs jenkins
```
## 4. Create 2 pipelines
Create Jenkins 2 pipelines from console, Name `Build` and `Deploy`
Configure pipelines to map with `Jenkinsfile`
```
Build => Jenkinsfile.build
Deploy => Jenkinsfile.deploy
```
## 5. Web hook to pipeline
Call http `POST` to: `http://localhost:8080/github-webhook/`
