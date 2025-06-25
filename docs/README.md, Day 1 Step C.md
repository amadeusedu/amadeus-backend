# Day 1 – Task C: Reserve dev/stage FQDNs

This Terraform creates **placeholder DNS records** inside Route 53 for:

- `api.dev.amadeus-academics.com`
- `api.stage.amadeus-academics.com`

They point to `example.com.` for now—so the names are claimed.

## How to use

1. Copy your Route 53 **Hosted Zone ID**.
2. Create `terraform.tfvars` in this folder:

   ```hcl
   route53_zone_id = "Z0ABCDEF12345"
   ```

3. Run:

   ```bash
   terraform init
   terraform apply
   ```

Later—when your API Gateway custom domain is live—edit `records` with the real AWS alias and run `terraform apply` again.
