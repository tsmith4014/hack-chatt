# Hackathon Email Signup Project

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Setup Instructions](#setup-instructions)
   - [Clone Repository](#clone-repository)
   - [Install Terraform](#install-terraform)
   - [AWS CLI Configuration](#aws-cli-configuration)
   - [Terraform Initialization and Deployment](#terraform-initialization-and-deployment)
5. [Frontend Configuration](#frontend-configuration)
6. [AWS CLI Commands](#aws-cli-commands)

## Overview

This project sets up a serverless architecture for an email signup form using AWS services. It includes a Lambda function to process the signup and store the email addresses in an S3 bucket. The frontend is hosted on another S3 bucket configured as a static website.

## Architecture

- **AWS Lambda**: Handles the email signup logic.
- **Amazon S3**: Stores the frontend website and email addresses.
- **Amazon API Gateway**: Exposes the Lambda function as an HTTP endpoint.

## Prerequisites

- AWS Account
- AWS CLI configured
- Terraform installed

## Setup Instructions

### Clone Repository

```sh
git clone <repository-url>
cd <repository-directory>
```

### Install Terraform

Install Terraform from the [official website](https://www.terraform.io/downloads.html).

### AWS CLI Configuration

Ensure AWS CLI is configured with the necessary permissions. Run:

```sh
aws configure
```

### Terraform Initialization and Deployment

1. **Initialize Terraform:**

   ```sh
   terraform init
   ```

2. **Deploy the infrastructure:**

   ```sh
   terraform apply --auto-approve
   ```

## Frontend Configuration

### index.html

Replace the placeholder URL with your API Gateway endpoint.

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hackathon Signup</title>
  </head>
  <body>
    <h1>Sign Up for the Hackathon</h1>
    <form id="emailForm">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required />
      <button type="submit">Sign Up</button>
    </form>
    <script>
      document
        .getElementById("emailForm")
        .addEventListener("submit", async function (event) {
          event.preventDefault();
          const email = document.getElementById("email").value;
          try {
            const response = await fetch(
              "https://YOUR_API_GATEWAY_ENDPOINT/prod/subscribe",
              {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({ email }),
              }
            );
            if (response.ok) {
              alert("Signed up successfully!");
            } else {
              alert("Failed to sign up.");
            }
          } catch (error) {
            console.error("Error:", error);
            alert("An error occurred.");
          }
        });
    </script>
  </body>
</html>
```

### Upload index.html to S3

Upload the `index.html` file to the S3 bucket configured for hosting the website.

```sh
aws s3 cp index.html s3://hackathon-website-bucket/
```

## AWS CLI Commands

### Check Lambda Configuration

```sh
aws lambda get-function-configuration --function-name HackathonEmailSignup
```

### Check Lambda Policy

```sh
aws lambda get-policy --function-name HackathonEmailSignup
```

### Get API Gateway Method Response

```sh
aws apigateway get-method-response --rest-api-id <rest-api-id> --resource-id <resource-id> --http-method POST --status-code 200
aws apigateway get-method-response --rest-api-id <rest-api-id> --resource-id <resource-id> --http-method OPTIONS --status-code 200
```

### Get API Gateway Integration Response

```sh
aws apigateway get-integration-response --rest-api-id <rest-api-id> --resource-id <resource-id> --http-method POST --status-code 200
aws apigateway get-integration-response --rest-api-id <rest-api-id> --resource-id <resource-id> --http-method OPTIONS --status-code 200
```

### Describe CloudWatch Log Streams

```sh
aws logs describe-log-streams --log-group-name /aws/lambda/HackathonEmailSignup
```

### Get CloudWatch Log Events

```sh
aws logs get-log-events --log-group-name /aws/lambda/HackathonEmailSignup --log-stream-name <log-stream-name>
```

---
