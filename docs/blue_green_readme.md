
# Day 4 – Blue/Green CI/CD

This adds blue/green stages, Terraform workspaces (staging & production), and a GitHub Actions workflow that:

1. Runs **plan** on pull requests.
2. Deploys to *staging* workspace (colour **blue**) when code hits the `staging` branch.
3. Flips colour in *production* workspace when `main` is updated.

Rollback: re‑run the workflow with the previous colour.

