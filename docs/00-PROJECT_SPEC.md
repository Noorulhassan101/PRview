# Project: Previewer — Automated PR Preview Environments

## One-liner
A GitHub Actions–driven system that automatically deploys a temporary, isolated, live environment for every pull request, posts the URL as a PR comment, and tears it down automatically when the PR is closed or merged.

## Problem it solves
Reviewers currently have to pull a branch and run it locally to see what changed. Previewer removes that step: open a PR → get a real, running, shareable URL → close the PR → environment is gone and stops costing money. This is the same pattern used internally by platform teams at companies running Vercel/Netlify-style workflows, applied to a self-hosted Kubernetes setup.

## Target user story
"As a developer opening a pull request on `demo-app`, I want a live URL of my branch's version to appear as a PR comment within ~2 minutes of pushing, so a reviewer can click it and see the actual running change without pulling the branch."

## What gets built (deliverable)
1. A small demo application (throwaway, just enough to prove deployments work) containerized with Docker.
2. Terraform code that provisions exactly one cloud VM and installs a lightweight Kubernetes cluster (k3s) on it.
3. A GitHub Actions pipeline that, on PR open/sync: builds the image, scans it, pushes it to a registry, deploys it into a PR-specific Kubernetes namespace, and comments the live URL on the PR.
4. A teardown workflow that deletes the namespace (and everything in it) when the PR is closed or merged.
5. Baseline security controls (see `03-SECURITY.md`) — this is not optional polish, it is part of "done."
6. Documentation: architecture diagram, runbook, and a short "what I'd do differently at scale" write-up for the README (this is what recruiters actually read).

## Fixed tech stack (do not substitute without asking)
- Cloud: any one provider (DigitalOcean, Hetzner, or AWS EC2 — pick the cheapest single VM option)
- IaC: Terraform
- Orchestration: k3s (lightweight Kubernetes, single node is fine)
- Ingress/TLS: Traefik (bundled with k3s) + cert-manager or Traefik's built-in ACME for Let's Encrypt
- CI/CD: GitHub Actions
- Container registry: GitHub Container Registry (GHCR)
- Image scanning: Trivy
- Demo app: any language, kept intentionally trivial (a static page or a 1-endpoint API is enough)
- Secrets: GitHub Actions encrypted secrets (do not hardcode anything, ever)

## Definition of done
- Opening a PR against `demo-app` produces a working, HTTPS URL within ~2 minutes, posted as a bot comment.
- Closing/merging the PR removes all resources for that PR within ~1 minute, verifiable by `kubectl get ns`.
- No secret, token, or credential appears in git history, logs, or the repo.
- Running `terraform apply` from a clean state reproduces the entire cluster with no manual steps.
- README documents architecture, how to run it, and known limitations.

## Time budget
3 working days. See `04-TASKS.md` for the day-by-day breakdown. If a task is taking meaningfully longer than budgeted, stop and flag it rather than quietly expanding scope.
