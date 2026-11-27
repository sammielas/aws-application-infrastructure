# Application Network Infrastructure

## Engineering Ticket

INFRA-103: VPC and Network Infrastructure

## Architecture

- Region: us-east-1
- VPC CIDR: 10.20.0.0/16
- DNS support and DNS hostnames enabled
- Two public and two private subnets
- Shared public route table and Internet Gateway
- Dedicated private route table per availability zone
- Automatic public IP assignment disabled
- Default security group with no ingress or egress rules

| Subnet | CIDR | Availability Zone |
|---|---|---|
| public-a | 10.20.1.0/24 | us-east-1a |
| public-b | 10.20.2.0/24 | us-east-1b |
| private-a | 10.20.11.0/24 | us-east-1a |
| private-b | 10.20.12.0/24 | us-east-1b |

## Validation Evidence

- Terraform formatting and validation passed.
- Recursive TFLint validation passed.
- Checkov: 25 passed, 0 failed, 5 skipped.
- Initial apply: 15 added, 0 changed, 0 destroyed.
- Independent EC2 API configuration verification completed.
- All four subnet route table associations verified.
- Terraform state contains 16 managed resource instances.
- Final Terraform plan returned exit code 0.

## Security Group Remediation

Initial adoption of the default security group left an
unrestricted IPv4 egress rule.

Independent API verification and Terraform refresh
detected the configuration discrepancy.

A reviewed Terraform remediation plan removed the rule.

Remediation: 0 added, 1 changed, 0 destroyed.

Subsequent API verification confirmed empty ingress
and egress rules. Terraform converged successfully.

The underlying cause of the initial discrepancy
has not been established.

## Emulator Limitations

Floci reports inconsistent availability zone metadata.

The availability zones API maps us-east-1b to
us-east-1-az2, but subnet API responses report
us-east-1-az1 for subnets in us-east-1b.

The intended Terraform AZ configuration is preserved.

This environment validates infrastructure configuration,
not physical availability zone independence, packet
routing, traffic filtering or production resilience.

## Security Risk Acceptance

CKV2_AWS_11: VPC Flow Logs

Approved exception for the isolated Floci environment.

Residual risk: reduced network traffic visibility.

Review milestone: Project 1, Checkpoint 3,
Operational Readiness.

This exception does not authorise production deployment.

## Out of Scope

- Application Load Balancer
- EC2 and Auto Scaling Groups
- NAT Gateways
- VPC endpoints
- Application-specific security groups

These will be addressed in subsequent implementation work.
