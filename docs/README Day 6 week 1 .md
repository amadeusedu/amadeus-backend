# WAF OWASP Top‑10 Protection

This Terraform file replaces the simple rate‑limit ACL with an AWS‑managed
Web ACL that includes:

* **AWSManagedRulesCommonRuleSet** – generic OWASP protections  
* **AWSManagedRulesSQLiRuleSet** – SQL‑injection detection  
* **AWSManagedRulesAmazonIpReputationList** – blocks IPs with bad reputation  
* A custom **rate‑limit** rule (1000 reqs per 5 min per IP)

## Steps

1. Copy this file into your Terraform repo (replace the old `waf.tf`).
2. Run:

```bash
terraform init
terraform apply
```

3. Test: send a malicious payload (e.g., `' OR 1=1;--`) and confirm WAF blocks
with **403 Forbidden**.

This completes the OWASP Top‑10 WAF task.
