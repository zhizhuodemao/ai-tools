# State

Keep durable state minimal. Use the skill directory as root.

Default files:

```text
state/profile.json
state/jobs.jsonl
state/applications.jsonl
state/automation_policy.json
reports/latest.md
```

Do not create run folders by default. Use `runs/` only for debugging, failure recovery, or when the user asks for detailed artifacts.

## Roles

- `profile.json`: resume profile, target profile, constraints, and user feedback.
- `jobs.jsonl`: one inspected job per line, including detail evidence, company-page evidence, scoring, decision, and greeting strategy.
- `applications.jsonl`: append-only record of account-changing actions performed only by scheduled execution under an enabled platform automation task.
- `automation_policy.json`: confirmed policy, user-confirmed daily limits, and scheduler handoff status.
- `reports/latest.md`: latest human-readable report and blockers.

Do not store passwords, SMS codes, cookies, local storage, session storage, browser profiles, tokens, or secrets.

## Job Record Minimum

Each job line must preserve:

- discovered direction and keyword,
- clicked target evidence,
- job detail facts,
- company-page attempt result,
- company facts and posted-job pattern when visible,
- score and decision,
- reason and blocker.

## Report

`reports/latest.md` should summarize the current state, not duplicate all raw data. Include calibration findings, top candidates, rejected patterns, blockers, and automation handoff status.

When reporting automation readiness, distinguish suggested limits from user-confirmed limits. Suggested limits are not enough to create guarded automation.
