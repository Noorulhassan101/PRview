# Scope Boundaries

**Rule for the agent: if something is not listed under "In Scope" below, do not build it. If you think it's needed, stop and ask instead of adding it.**

## In Scope
- One Terraform config that provisions ONE VM and installs k3s on it (single-node cluster).
- One demo app (trivial — static HTML or a single JSON endpoint), Dockerized.
- One GitHub Actions workflow: `on: pull_request [opened, synchronize, reopened]` → build → scan → push → deploy to namespace `pr-<number>`.
- One GitHub Actions workflow: `on: pull_request [closed]` → delete namespace `pr-<number>`.
- A bot comment on the PR with the live URL (use `actions/github-script` or a similar lightweight approach — not a third-party paid service).
- Wildcard DNS (`*.preview.yourdomain.com`) pointed at the VM, with per-namespace Ingress routing by subdomain (`pr-12.preview.yourdomain.com`).
- TLS via Let's Encrypt (wildcard cert or per-namespace cert — pick whichever is less fiddly, wildcard is likely simpler).
- Basic auth (a single shared username/password via Kubernetes secret + Traefik middleware) on every preview environment, since these are ephemeral but still public URLs.
- Trivy scan of the built image in CI; fail the build on HIGH/CRITICAL findings.
- Kubernetes `ResourceQuota` and `LimitRange` per PR namespace so one runaway PR can't starve the node.
- A basic runbook: how to manually delete a stuck namespace, how to re-run `terraform apply`, how to rotate the registry token.

## Explicitly Out of Scope (do not build these)
- Multi-node clusters, autoscaling, or multi-cloud/multi-region setups.
- A full observability stack (Prometheus + Grafana). A single `kubectl top` / k3s built-in metrics check is enough for this project. Do not stand up Prometheus.
- Persistent databases or stateful storage for the demo app. The demo app must be stateless.
- Per-PR custom domains (subdomain-per-PR under one wildcard domain is enough).
- SSO, OAuth, or any auth beyond the single shared basic-auth credential.
- Helm chart authoring/publishing as a separate deliverable — plain Kubernetes YAML manifests (or a minimal Kustomize overlay) are enough.
- GitOps tooling (ArgoCD/Flux). The GitHub Actions workflow deploying directly via `kubectl apply` is the intended mechanism for this project size — adding ArgoCD on top is a different, bigger project.
- Blue/green or canary deploy strategies for the previewer's own infrastructure.
- Load testing, chaos engineering, or performance benchmarking.
- CDN, WAF, or DDoS protection layers.
- Notifications beyond the GitHub PR comment (no Slack/email integration).
- Any second demo app or "real" production application — the demo app exists only to prove the pipeline works.

## Day-by-day scope (see 04-TASKS.md for full checklist)
- **Day 1**: Infra only — Terraform, k3s, Traefik, wildcard TLS, GHCR auth. No app logic yet.
- **Day 2**: App + pipeline — demo app, Dockerfile, CI build/scan/push/deploy workflow, PR comment, basic auth, resource quotas.
- **Day 3**: Teardown workflow, security pass, documentation, end-to-end test, cleanup/final polish.

## Change control
If mid-build the agent believes a change to this scope is necessary (e.g. a chosen tool doesn't work as expected), it must:
1. State what's blocked and why.
2. Propose the smallest possible fix.
3. Wait for approval before implementing it — do not silently substitute tools or add components.
