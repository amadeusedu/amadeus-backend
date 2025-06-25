# Day 5 – Structured Logging & Metrics

This module:

1. **Switches access logs to JSON**  
   API Gateway stage now outputs structured JSON to CloudWatch Logs.

2. **Creates a dedicated log group** (`/amadeus/api/access`).

3. **(Optional)** Firehose delivery stream placeholder to push logs into
   ELK / Grafana Loki.

4. **Adds CloudWatch metric alarms**  
   * P95 latency > 1s for 2 minutes  
   * Any 5xx error in a 60‑second window

## Beginner steps

1. **Set an SNS topic ARN** in `terraform.tfvars` so alarms notify Slack/email:

   ```hcl
   alarm_sns_topic_arn = "arn:aws:sns:ap-southeast-2:123456789012:alerts"
   ```

2. *(Optional)* When you have an OpenSearch cluster or Loki, uncomment the
   Firehose block and set bucket/role/domain.

3. Run:

   ```bash
   terraform init
   terraform apply
   ```

4. Check:

   * **CloudWatch Logs** → log group `/amadeus/api/access` – each line is JSON.  
   * **CloudWatch Alarms** → you should see two alarms in state *OK*.

That completes Day 5 Dev A.


## Firehose forwarding (optional)

If you have an OpenSearch or Grafana Loki stack and want logs sent there:

1. Set in `terraform.tfvars`:
   ```hcl
   enable_firehose   = true
   logs_bucket_name  = "my-api-logs-bucket"
   ```
2. Terraform will create:
   * an S3 bucket for backups
   * an IAM role
   * a Firehose stream
   * a subscription filter from CloudWatch Logs to Firehose

You can attach the Firehose stream to OpenSearch or Grafana Loki via console.

