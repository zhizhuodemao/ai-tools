# Automation

Use this reference when creating policy, handing off to an automation task, or running a scheduled task.

Automation is the required final handoff for a complete serious run unless the user explicitly chooses report-only mode.

## Modes

- `safe_monitor`: scheduled scans only. Produce new candidates and pending-confirmation recommendations; do not send messages.
- `guarded_apply`: scheduled scans plus limited account-changing actions allowed by policy.

Default to `safe_monitor` unless the user clearly confirms guarded apply.

Account-changing actions are allowed only during scheduled execution launched by a created automation task. Profile, scan, calibration, report, and handoff stages must never apply, message, favorite, mark interest, upload, or edit resumes.

## Policy Requirements

Before creating automation, confirm these as explicit user decisions. Agent-recommended values are only proposals until the user accepts them.

- mode,
- role directions,
- cities or remote rules,
- salary rule,
- company and job exclusions,
- daily scan limit,
- daily apply or message limit; use `0` for account-changing actions in `safe_monitor`,
- allowed actions,
- forbidden actions,
- stop rules,
- reporting expectation.

Do not create or update guarded automation when daily limits are only inferred from agent judgment. Ask the user to choose or confirm numeric limits first.

Save confirmed policy to `state/automation_policy.json`.

## Automation Handoff

After confirmation, create or update a real automation task. Do not finish with only a local policy file.

Create a real automation task when possible. If a real automation task cannot be created, stop and report that automation is unsupported. Do not replace the required automation task with local cron, manual reminders, or immediate application.

Do not apply or message during handoff. Handoff creates the task; future scheduled execution performs allowed actions under policy.

Record automation-task status in `state/automation_policy.json`:

```json
{
  "enabled": true,
  "mode": "safe_monitor",
  "automation_task_created": true,
  "task_id": "",
  "schedule": "",
  "last_handoff_at": "",
  "limits_confirmed_by_user": true
}
```

## Scheduled Execution Rules

Every scheduled run must:

- load `state/profile.json`, `state/jobs.jsonl`, `state/applications.jsonl`, and `state/automation_policy.json`,
- stop if policy is missing, disabled, outside scope, or missing user-confirmed daily limits,
- use the click-first browser protocol,
- wait at least 3 seconds between BOSS operations,
- search across multiple directions,
- open job detail by visible click,
- attempt company page for every candidate,
- score with the fixed rubric,
- skip already rejected, applied, or seen jobs unless recheck is needed,
- update `state/jobs.jsonl` and `reports/latest.md`,
- append account-changing actions to `state/applications.jsonl`.

Guarded apply runs must also re-open and verify each selected job and company page immediately before action.

## Automation Stop Rules

Stop the task for login, CAPTCHA, SMS, password, face verification, account risk, browser permission prompts, company-page blocker on an actionable job, policy ambiguity, missing user-confirmed daily limits, daily limit reached, sensitive data request, resume upload/edit request, or any page mismatch.

Report blockers clearly in `reports/latest.md`.
