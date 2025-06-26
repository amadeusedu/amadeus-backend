# Day 6 – Load Test & Autoscaling Tune

This folder gives you:

* **loadtest.js** – a k6 script that drives ≈500 requests per second
* **variables.tf / tuning.tf** – parameters to resize your Lambda and set reserved concurrency

---

## 1  Run the load test (beginner steps)

1. **Install k6**  
   - macOS: `brew install k6`  
   - Windows (Chocolatey): `choco install k6`  
   - Or use Docker:  
     ```bash
     docker run -i grafana/k6 run - < loadtest.js
     ```

2. **Set TEST_URL** to your API status endpoint and run:  
   ```bash
   TEST_URL=https://api.dev.amadeus-academics.com/status k6 run loadtest.js
   ```

   The script spins up **500 virtual users** for **15 minutes**.  
   Watch the summary at the end—look for:

   * `http_req_failed < 1 %`
   * `http_req_duration (p95) < 500 ms`

---

## 2  Interpret results

| Symptom | Fix |
|---------|-----|
| `http_req_duration` > 500 ms | Increase `lambda_memory_mb` (e.g., 512 → 1024) |
| `http_req_failed` > 1 % with 429s | Increase `lambda_reserved_concurrency` |
| 5xx errors | Check CloudWatch logs for stack trace; may need DB capacity |

---

## 3  Tune Lambda limits

1. Open **terraform.tfvars** and add overrides, e.g.:

   ```hcl
   lambda_memory_mb           = 1024
   lambda_reserved_concurrency = 200
   ```

2. Apply changes:

   ```bash
   terraform init
   terraform apply
   ```

Lambda now has more headroom; re‑run the load test until latency and error rate meet targets.

---

## Autoscaling Notes

* API Gateway (HTTP) auto‑scales by design—no extra config.
* Reserved concurrency guarantees capacity for critical functions.
* Optionally set DynamoDB or Aurora Serverless auto‑scaling if those backends appear as hotspots.

After you reach stable metrics (<500 ms p95, <1 % errors), Day 6 Dev A is complete.


---

## High throttle limits for the load test

Global throttle limits from Day 2 (50 burst / 20 rps) would block a 500 RPS test.
Two variables let you lift the ceiling **only during the load test**:

```hcl
enable_high_rate_limits = true
high_rate_limit_burst   = 1000
high_rate_limit_rate    = 600
```

After the test, set `enable_high_rate_limits = false` and apply again
to return to normal protections.
