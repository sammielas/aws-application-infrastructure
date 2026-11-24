# Terraform Remote State

## Purpose

Provide a durable, versioned Terraform state backend
with native S3 state locking in an isolated development
environment.

## Architecture

- Terraform 1.16.0
- AWS provider 6.73.0
- Floci with persistent storage
- S3 backend with native lockfile support
- Dedicated Docker named volume

The bootstrap root provisions the state backend using
local Terraform state.

The infrastructure root consumes the S3 backend using
the dev/terraform.tfstate object key.

The backend endpoint is http://127.0.0.1:4567.

## Security Controls

- S3 versioning enabled
- SSE-S3 encryption configured
- All four public access restrictions enabled
- Terraform prevent_destroy protection
- Native S3 state locking
- Incomplete multipart uploads aborted after seven days
- State files and saved plans excluded from Git

## Validation Evidence

- S3 configuration independently verified through APIs
- Concurrent lock acquisition rejected with HTTP 412
- Successful apply and subsequent lock absence observed
- Remote state unchanged across a container restart
- S3 object version ID preserved across restart
- Bootstrap and infrastructure plans returned exit code 0
- Local state backup captured and checksum verified

## Storage Incident

The initial emulator configuration used memory storage
despite having a mounted Docker volume.

A container restart resulted in the loss of the S3
bucket and its remote state contents.

Root cause: persistent storage mode was not explicitly
enabled.

Remediation:

- Enabled FLOCI_STORAGE_MODE=persistent
- Configured FLOCI_STORAGE_PERSISTENT_PATH=/app/data
- Recreated backend infrastructure using Terraform
- Rebuilt the disposable validation resource
- Captured a protected state backup
- Repeated the persistence regression test

The original remote state and version history were not
restored.

## Known Compatibility Issues

Initial S3 bucket creation did not persist resource tags.

A subsequent Terraform in-place update successfully
applied the tags and restored configuration convergence.

The underlying cause remains unconfirmed.

During the persistent-mode locking regression, a
temporary resource was observed in a tainted state.
Resource IDs differed between the supplied apply and
cleanup evidence. The cause remains unresolved.

Cleanup completed successfully and the final Terraform
plan reported no changes.

## Security Exceptions

The following Checkov exceptions are explicitly scoped:

- CKV_AWS_144: Cross-region replication outside current scope.
- CKV_AWS_18: Access logging deferred to operational readiness.
- CKV2_AWS_62: No event-driven consumers currently required.
- CKV_AWS_145: SSE-S3 accepted for local emulation only.

## CI Validation

Both Terraform roots are initialized without backend
access during pull request validation.

Quality gates include formatting, Terraform validation,
TFLint, Checkov and Gitleaks.

CI also scans committed history reachable from fetched
Git references independently of local staged scanning.

## Limitations

- Restart persistence is not disaster recovery.
- Recovery backups currently reside on the same host.
- Volume deletion and host failure recovery remain untested.
- Original state history was lost during the incident.
- Emulator behaviour does not establish production AWS
  security or durability guarantees.
- Production IAM enforcement has not been validated.
- Full disaster recovery testing is outside this ticket.
