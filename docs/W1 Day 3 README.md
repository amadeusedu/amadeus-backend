# Day 3 – Enable JWT Policy

This adds a **JWT authorizer** to the existing HTTP API so the gateway checks
every incoming token *before* traffic reaches your Lambdas/containers.

## Files

| File | Purpose |
|------|---------|
| `variables.tf` | `auth_issuer_url` and `auth_audience` placeholders |
| `authorizer.tf` | Creates the `jwt-authorizer` resource |
| `route_protection.tf` | Example of how to attach the authorizer to a route |

## Manual steps (beginner version)

1. **Decide the placeholder issuer URL**  
   For now keep the default:  
   ```
   https://auth.dev.amadeus-academics.com
   ```
   Later, when you build the real Auth service, make sure it issues tokens with
   `iss` = this URL and `aud` = `"amadeus-academics-api"`.

2. Optionally override in `terraform.tfvars`:

   ```hcl
   auth_issuer_url = "https://auth.stage.amadeus-academics.com"
   auth_audience   = ["amadeus-academics-api"]
   ```

3. **Run Terraform**  
   ```bash
   terraform init
   terraform apply
   ```

4. **Test**  
   - Hitting `/protected` without a token returns **401 Unauthorized**.  
   - Later, after Auth is live, send a valid JWT in  
     `Authorization: Bearer <token>` and you’ll get the normal response.

That’s the complete Day 3 Dev A task—gateway now enforces JWT security.


---

## Global Authorizer (added)

The file **stage_jwt.tf** now applies the JWT authorizer and rate‑limit settings
to *all* routes by default. If you already had a stage resource from Day 2,
Terraform will replace it with this version.

Nothing else to do—just run:

```bash
terraform init
terraform apply
```
