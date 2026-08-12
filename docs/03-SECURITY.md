# Security Requirements

These are not optional. A DevOps project without them is a demo, not a portfolio piece.

## Threat model (what we're defending against)
- Secrets leaking into git history, logs, or public PR comments.
- A malicious/compromised PR running arbitrary code that escapes its namespace or exhausts node resources.
- Preview URLs being publicly discoverable and exposing unfinished/sensitive work.
- Vulnerable base images being deployed unnoticed.
- Overly broad credentials (e.g. a GitHub Actions token or kubeconfig with full cluster-admin) being used where a narrower scope would do.

## Required controls

### Secrets management
- No credential, token, API key, or `.pem`/`.kubeconfig` file is ever committed to the repo — not even in a "temporary" commit. Use `.gitignore` from the first commit.
- All secrets live in GitHub Actions encrypted secrets (`Settings → Secrets and variables → Actions`): registry credentials, kubeconfig (base64-encoded), basic-auth password, cloud provider API token for Terraform.
- Run `gitleaks` (or equivalent) as a pre-commit or CI step to catch accidental secret commits.
- Rotate the demo basic-auth password and document how to do so in the runbook.

### Container security
- Base images pinned to a specific digest or minimal tag (e.g. `node:20-alpine`), not `latest`.
- Trivy scan runs on every build; the pipeline fails the build on HIGH/CRITICAL vulnerabilities (this is a real gate, not advisory).
- Containers run as a non-root user (set `USER` in the Dockerfile).
- No privileged containers; `securityContext` in the Kubernetes manifest sets `runAsNonRoot: true` and `allowPrivilegeEscalation: false`.

### Cluster/namespace isolation
- Every PR gets its own namespace — no shared namespace across PRs.
- `ResourceQuota` and `LimitRange` applied per namespace (cap CPU/memory) so one PR cannot starve the node.
- The kubeconfig used by GitHub Actions should be scoped as narrowly as practical (a dedicated service account with RBAC limited to creating/deleting namespaces and the resources inside them — not full cluster-admin, if time allows; document as a known gap if you have to fall back to broader access for time reasons).

### Network/access security
- TLS everywhere — no plain HTTP preview URLs. Let's Encrypt via Traefik/cert-manager.
- Basic auth in front of every preview environment (Traefik middleware) since these are otherwise unauthenticated public URLs tied to unfinished code.
- Security headers on responses where feasible (HSTS at minimum, via Traefik middleware).
- Firewall the VM: only 22 (SSH, ideally key-only and IP-restricted), 80, and 443 open.

### CI/CD pipeline security
- GitHub Actions workflows use the minimum `permissions:` block needed (e.g. `contents: read`, `pull-requests: write`) rather than default broad permissions.
- Pin third-party GitHub Actions to a commit SHA, not a floating tag, to avoid supply-chain risk.
- Never echo secrets to logs; double-check `run:` steps don't accidentally print env vars containing credentials.

## Security checklist (agent must confirm each before marking the project done)
- [ ] No secrets in git history (verified with a scan tool, not just visual inspection)
- [ ] All images run as non-root
- [ ] Trivy gate is active and actually fails builds on HIGH/CRITICAL (test this — don't just assume)
- [ ] TLS certificates are valid and auto-renewing
- [ ] Basic auth is enforced on preview URLs (test with an unauthenticated curl request)
- [ ] ResourceQuota/LimitRange applied and verified with a load test that intentionally tries to exceed them
- [ ] GitHub Actions permissions are least-privilege, not default
- [ ] Firewall confirmed (only 22/80/443 reachable — verify with an external port scan)
- [ ] README documents rotation procedure for the basic-auth credential and registry token
