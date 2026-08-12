# Task Breakdown

Work top to bottom. Do not start a task until the previous one's acceptance criteria are met. Check items off as you go.

## Day 1 — Infrastructure

- [ ] **1.1** Initialize repo structure exactly as in `05-AGENT_INSTRUCTIONS.md`.
- [ ] **1.2** Write Terraform config to provision one VM (2 vCPU / 4GB RAM is enough) on the chosen provider.
  - Acceptance: `terraform apply` from clean state creates the VM; `terraform destroy` cleanly removes it; no hardcoded credentials (use a `.tfvars` file that is gitignored, or environment variables).
- [ ] **1.3** Add a bootstrap step (Terraform provisioner, cloud-init, or a separate script) that installs k3s on the VM.
  - Acceptance: SSH into the VM, `kubectl get nodes` shows the node Ready.
- [ ] **1.4** Configure the firewall (provider-level security group or ufw) to only allow 22, 80, 443.
  - Acceptance: external port scan (e.g. `nmap`) shows only those three ports open.
- [ ] **1.5** Set up wildcard DNS `*.preview.yourdomain.com` → VM IP.
  - Acceptance: `dig random-subdomain.preview.yourdomain.com` resolves to the VM IP.
- [ ] **1.6** Configure Traefik + Let's Encrypt for wildcard or per-host TLS.
  - Acceptance: deploying a throwaway "hello world" Ingress produces a valid HTTPS cert, verifiable with `curl -v`.
- [ ] **1.7** Create GHCR credentials and confirm k3s can pull a private image using an `imagePullSecret`.
  - Acceptance: manually push a test image, manually deploy it referencing the pull secret, confirm the pod runs.

**Day 1 done when:** a manually-created test deployment is reachable over HTTPS at a subdomain, pulling from a private GHCR image. Tear down the test deployment before moving on.

## Day 2 — App + Pipeline

- [ ] **2.1** Write the demo app (single endpoint or static page) and a non-root Dockerfile for it.
  - Acceptance: `docker build` succeeds; `docker run` serves the app; image runs as non-root (`docker inspect` confirms).
- [ ] **2.2** Write Kubernetes manifest templates (namespace, deployment, service, ingress, resourcequota, limitrange) parameterized by PR number (use `envsubst`, `kustomize`, or simple `sed` — pick the simplest option that works).
  - Acceptance: manually rendering the template for a fake "PR 999" and applying it produces a working, isolated deployment at `pr-999.preview.yourdomain.com`.
- [ ] **2.3** Write `pr-preview.yml`: build → Trivy scan (gate on HIGH/CRITICAL) → push to GHCR → render + apply manifests → comment PR with URL.
  - Acceptance: opening a real test PR triggers the workflow end-to-end and results in a working HTTPS URL commented on the PR within ~2 minutes.
- [ ] **2.4** Add basic-auth middleware (Traefik) applied to every preview Ingress.
  - Acceptance: unauthenticated `curl` to the preview URL returns 401; authenticated request succeeds.
- [ ] **2.5** Push another commit to the same test PR and confirm the workflow updates the existing deployment (not a duplicate).
  - Acceptance: same URL, new content reflected, no leftover old pods.

**Day 2 done when:** opening/updating a real PR reliably produces a live, authenticated, scanned, isolated preview environment with no manual steps.

## Day 3 — Teardown, Security Pass, Docs

- [ ] **3.1** Write `pr-teardown.yml`: on PR closed, delete the `pr-<number>` namespace.
  - Acceptance: closing the test PR removes all its Kubernetes resources within ~1 minute (`kubectl get ns` no longer lists it).
- [ ] **3.2** Run through the full Security Checklist in `03-SECURITY.md` and fix anything unchecked.
- [ ] **3.3** Load-test the ResourceQuota by deliberately deploying something that tries to exceed it; confirm it's rejected/limited rather than starving the node.
- [ ] **3.4** Write the top-level `README.md`: architecture diagram, setup instructions, how to run `terraform apply`, how to rotate secrets, known limitations, "what I'd do at scale" section.
- [ ] **3.5** Write `RUNBOOK.md`: how to manually delete a stuck namespace, how to check cluster health, how to rotate the GHCR token and basic-auth password, how to fully tear down and rebuild from scratch.
- [ ] **3.6** Do one full clean end-to-end test: destroy everything, rebuild from `terraform apply` alone, open a real PR, confirm preview works, close it, confirm teardown works.
- [ ] **3.7** Clean up: remove any test/scratch resources, confirm `.gitignore` covers all secret-bearing files, confirm no TODOs or placeholder values remain in committed files.

**Day 3 done when:** the Definition of Done in `00-PROJECT_SPEC.md` is fully met and a stranger could clone the repo, follow the README, and get a working system.
