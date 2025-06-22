# Day 1 – Task B (No Custom Domain)

This Terraform configuration builds:

* VPC + public/private subnets  
* Internet Gateway & routing  
* HTTP API Gateway skeleton with auto‑deploy stage

No Route 53 hosted zone, SSL certificate, or custom domain is created yet, so AWS will give you a default URL such as:

```
https://<random>.execute-api.<region>.amazonaws.com
```

## Deploy now

```bash
terraform init
terraform apply
```

After `apply`, Terraform will print **api_base_url** – copy it and open in a browser; you should see an AWS JSON error (proves the gateway is live).

---

## Later – when you buy the domain

1. Purchase **amadeus-academics.com** and create a *public hosted zone* in Route 53.  
2. Note the **Hosted Zone ID**.  
3. Add these extra files/resources:

   * `aws_acm_certificate` (DNS‑validated)  
   * `aws_apigatewayv2_domain_name`  
   * `aws_apigatewayv2_api_mapping`  
   * `aws_route53_record` alias to the custom domain

4. Run `terraform apply` again – it will add the domain & SSL on top of the existing stack.

You can copy the ACM + Route 53 blocks from the earlier **day1_taskB_refined** version.
