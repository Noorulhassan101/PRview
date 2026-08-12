# Previewer — Planning Docs

Give your coding agent this whole folder (or paste its contents into your repo under `/docs`) before it writes any code. Point it at this README first.

## Read in this order
1. `00-PROJECT_SPEC.md` — what we're building and why, fixed tech stack, definition of done
2. `01-SCOPE.md` — hard in-scope / out-of-scope boundaries — the agent should treat this as non-negotiable
3. `02-ARCHITECTURE.md` — diagram and component responsibilities
4. `03-SECURITY.md` — required security controls and the final security checklist
5. `04-TASKS.md` — the actual day-by-day build checklist with acceptance criteria
6. `05-AGENT_INSTRUCTIONS.md` — operating rules, expected repo structure, when to stop and report back

## Suggested first message to your agent
> "Read all 6 files in this docs folder in order before doing anything. Then start on Day 1 of 04-TASKS.md. Follow 01-SCOPE.md strictly — do not add anything not listed as in-scope. Stop and report back after Day 1's acceptance criteria are met before continuing."
