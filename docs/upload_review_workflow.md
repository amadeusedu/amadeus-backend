# Tutor Upload & Review Workflow

The workflow consists of the uploader requesting a pre-signed S3 URL, uploading the file, and then the reviewer approving or rejecting it.

```mermaid
sequenceDiagram
  participant Uploader
  participant System
  participant Reviewer

  Uploader->>System: POST /uploads/sign (filename)
  System-->>Uploader: Return presigned S3 URL
  Uploader->>S3: Upload file to S3
  System->>System: Store upload record & publish SNS message
  System-->>Reviewer: SNS push (creates pending review)
  Reviewer->>System: PATCH /reviews/rev-<id>/approve or /reject
  System-->>Uploader: Notify (asset published or rejected)
