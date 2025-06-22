# Day 1 – Task A: Gateway Selection Rationale

## Chosen Stack
**AWS API Gateway + Lambda**

## Rationale
- **Low operational overhead**: Fully managed by AWS; no servers to provision or maintain.
- **Fast MVP deployment**: Quickly scaffold and deploy functions and APIs with minimal setup.
- **Cost-effective for early stages**: Pay-per-request billing keeps fixed costs low.
- **Seamless AWS integration**: Native support for IAM, Cognito, CloudWatch, and other AWS services.
- **Auto-scaling**: Automatically handles spikes in traffic without manual intervention.

## Alternatives Considered
- **ALB + Kong**: More plugin flexibility and predictable server costs, but requires managing EC2/ECS instances and more ops effort.
- **Traefik on EKS**: Advanced Kubernetes-native routing and middleware, ideal for microservices, but adds significant complexity and requires Kubernetes expertise.

## What It Means
Selecting AWS API Gateway + Lambda means all API calls (e.g., fetching courses, submitting quizzes) go through a serverless gateway that routes requests to Lambda functions.

## What It Does for Amadeus Academics
- **Defines the API entrypoint**: `api.dev.amadeus-academics.com` serves as the single HTTPS endpoint for students and tutors.
- **Provides built-in security**: AWS manages SSL certificates and HTTPS configuration.
- **Enables scalability**: Handles varying loads without manual scaling.
- **Accelerates development**: Lets the team focus on application logic, not infrastructure management.
