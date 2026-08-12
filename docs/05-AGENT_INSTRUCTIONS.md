# Instructions for the Building Agent

Read `00-PROJECT_SPEC.md`, `01-SCOPE.md`, `02-ARCHITECTURE.md`, and `03-SECURITY.md` before writing any code. Then follow `04-TASKS.md` in order.

## Ground rules
1. **Scope is fixed.** Build only what's in `01-SCOPE.md` under "In Scope." If you think something else is needed, stop and ask — do not add it silently.
2. **Follow task order.** Don't jump ahead to Day 2 work while Day 1 acceptance criteria are unmet.
3. **No placeholder secrets committed anywhere**, even temporarily, even in a commit you plan to amend later. Use `.env.example` / `terraform.tfvars.example` with fake values instead, and gitignore the real files from the very first commit.
4. **Every acceptance criterion in `04-TASKS.md` must be actually verified** (run the command, see the output), not assumed to work because the config "looks right."
5. **Ask before substituting tools.** If k3s, Traefik, GHCR, or Trivy turn out to be a poor fit for some environment-specific reason, explain why and propose the smallest substitute — don't silently swap in a different stack.
6. **Keep the demo app trivial.** Do not add features to it. Its only purpose is to prove the pipeline; time spent improving it is time taken from the actual DevOps work.
7. **Commit as you go**, in small logical commits (e.g. "add terraform VM provisioning", "add k3s bootstrap script", "add pr-preview workflow"), not one giant commit at the end — this project's commit history is part of what a recruiter/reviewer will look at.

## Expected repo structure

```
previewer/
├── README.md                  # written last, in Day 3
├── RUNBOOK.md                 # written in Day 3
├── .gitignore
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── k8s/
│   ├── namespace.yaml.tmpl
│   ├── deployment.yaml.tmpl
│   ├── service.yaml.tmpl
│   ├── ingress.yaml.tmpl
│   ├── resourcequota.yaml.tmpl
│   └── limitrange.yaml.tmpl
├── demo-app/
│   ├── Dockerfile
│   └── (app source)
├── .github/
│   └── workflows/
│       ├── pr-preview.yml
│       └── pr-teardown.yml
└── docs/
    └── (copy of these 6 planning files, for reference)
```

## Stopping points (report back to the user, don't just push forward)
- End of Day 1 tasks (infra working, before touching app code)
- End of Day 2 tasks (pipeline working end-to-end on a test PR, before starting teardown/docs)
- End of Day 3 tasks (project fully done per Definition of Done)
- Any time a Security Checklist item fails and can't be immediately fixed
- Any time you're about to spend more than ~1 extra hour beyond a task's budget

## What "done" looks like when reporting back
For each stopping point, report: what was built, what was verified (with the actual command/output, not just "it should work"), and anything from Scope you deliberately deferred or couldn't complete, with a one-line reason why.
