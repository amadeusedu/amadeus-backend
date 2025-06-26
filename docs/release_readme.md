# Day 7 – Release Tag & Promotion

This script:

1. Creates a Git tag (default **v0.1**) and pushes it.
2. Promotes the chosen *blue* or *green* API Gateway stage to the production
   custom domain.

## Usage

```bash
chmod +x release.sh
./release.sh              # auto‑switch colour
./release.sh blue         # force blue
./release.sh green v0.2   # tag v0.2 and promote green
```

If something goes wrong, run with the previous colour to roll back:

```bash
./release.sh blue   # or green
```

### Prerequisites

* Git remote `origin` points to your main repo and you have push rights.
* `terraform output` provides `api_id` and `prod_custom_domain`.
* AWS CLI credentials allow updating API Gateway mappings.

