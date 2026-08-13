# PRview - Automated PR Preview Environments
Welcome to **PRview**! This repository is configured with a fully automated, secure CI/CD pipeline that spins up isolated preview environments for every Pull Request.
## Developer Workflow (How to use this)
You do **not** need to understand Kubernetes, Docker, or Terraform to contribute to this project. The entire preview infrastructure is handled autonomously by GitHub Actions!
1. **Write Code**: Create a new branch and write your code locally.
2. **Open a Pull Request**: As soon as you open a PR on GitHub, our pipeline will automatically:
   - Build your code securely.
   - Scan it for vulnerabilities.
   - Deploy an isolated server environment just for your specific branch.
3. **Access the Live Preview**: Within a few minutes, a bot will leave a comment on your Pull Request containing a live, secure URL (e.g., `https://pr-5-app.164-90-128-88.sslip.io`). Click this link to see your changes running live in the cloud!
4. **Log In**: To protect unreleased work from the public internet, all preview links require a password. When prompted in your browser:
   - **Username**: `admin`
   - **Password**: *(Check with your team lead or the internal password vault for the Basic Auth credential)*
5. **Auto-Cleanup**: Once your Pull Request is approved and merged (or closed), the environment is instantly deleted to save server resources.
---
## Architecture & Infrastructure (For DevOps)
If you are maintaining the underlying infrastructure or want to learn how it works, this project relies on a strictly firewalled, self-hosted k3s cluster running on a DigitalOcean droplet (provisioned seamlessly with Terraform).
- **DNS & Routing**: Dynamic wildcard DNS via `sslip.io`.
- **Load Balancing**: Traefik Ingress Controller issuing automatic Let's Encrypt certificates (via `cert-manager`).
- **Zero-Trust Security**: 
  - **No inbound API access**: The DigitalOcean firewall explicitly blocks port `6443`. CI connects natively via a Base64 encoded SSH tunnel mapped to `127.0.0.1` locally in the generic runner.
  - **Non-Root Images**: All container images are explicitly run as non-root (using Chainguard minimal distroless).
  - **Tenant Isolation**: Namespaces are capped via `ResourceQuota` and `LimitRange` to prevent single PRs from starving the underlying VM node of resources.
  - **Vulnerability Scanning**: Trivy blocks CI deployments aggressively on `HIGH` or `CRITICAL` structural vulnerabilities.
## Local Infrastructure Setup
*(If you are setting this up for the first time)*
1. Configure Terraform variables in `terraform/terraform.tfvars`.
2. Apply infrastructure: `cd terraform && terraform apply`.
3. Add the required deployment tokens to the GitHub Secrets tab (`KUBECONFIG_DATA`, `SSH_PRIVATE_KEY_B64`, `GHCR_PAT`, and `BASIC_AUTH_CREDENTIALS`), and map the single Repository Variable (`VM_IP`).
4. Read `RUNBOOK.md` for operations/troubleshooting guidelines.
