# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## To run this project locally
To Install dependancies, Run:
### `yarn` or `yarn install` 

To Build, you can run:
### `yarn build`

To Run hadolint on dockerfile, Run:
### `docker run --rm -i hadolint/hadolint < Dockerfile`

To Run project locally, Run:
### `docker run --rm -d --name react-js-app -p 8000:80 react-docker:latest`

## Core components

### AWS

The AWS infrastructure is setup using terraform in the [`./terraform`](./terraform).

The following components are deployed:

- Application Load Balancer ([`./lb.tf`](./terraform/lb.tf))
- ECS Cluster / ECS Service ([`./ecs.tf`](./terraform/ecs.tf))
- Elastic Container Registry ([`./ecr.tf`](./terraform/ecr.tf))
- IAM permissions ([`./iam.tf`](./terraform/iam.tf))

### CI/CD

The repository leverages the [AWS Github Actions](https://github.com/aws-actions/)
maintained by AWS.

The main goal is to provide an example configuration of the following workflow:

- Run the integration tests
- Build the Docker image
- Publish it to a private ECR
- Update the corresponding ECS Service (by editing the task image)