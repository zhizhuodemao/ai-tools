# Scoring

Use this reference before recommending, preparing greeting strategy, or scheduling a job. Applying or messaging is allowed only during scheduled execution under an enabled automation task.

## Required Record

Each job record should include:

```json
{
  "job_id": "",
  "title": "",
  "company": "",
  "city": "",
  "salary": "",
  "source_direction": "",
  "job_detail_opened_by_ui_click": true,
  "company_page_attempted": true,
  "company_page_opened": true,
  "company_page_blocker": "",
  "company_facts": {},
  "company_posted_jobs_pattern": "",
  "fit_scores": {
    "role_fit": 0,
    "resume_evidence_fit": 0,
    "salary_city_fit": 0,
    "company_fit": 0,
    "risk_score": 0
  },
  "decision": "ask_user",
  "reason": "",
  "greeting_strategy": ""
}
```

## Fixed Criteria

Score with evidence, not vibes:

- `role_fit`: title, responsibilities, seniority, and direction.
- `resume_evidence_fit`: direct resume evidence for the JD.
- `salary_city_fit`: salary lower bound, city, commute, remote rules.
- `company_fit`: business, team, hiring body, company page, posted-job pattern.
- `risk_score`: outsourcing, training, sales drift, gray industry, mass scraping, privacy risk, unclear employer, mismatched recruiter, missing company page.

## Decisions

Use only these decision labels:

- `strong_candidate`: strong fit, company page inspected, safe to show prominently.
- `ask_user`: plausible fit but needs user judgment.
- `save_only`: useful market evidence but not a recommended action.
- `reject`: does not fit or violates constraints.
- `blocked_company_page`: company page was not available or could not be verified.
- `blocked_verification`: login, CAPTCHA, risk control, or other blocker.

Do not use `auto_apply` as a normal scan decision. Use `automation_eligible_after_policy` only when the job could be considered by a confirmed future automation policy. This label never authorizes immediate application.

## Greeting Strategy

Before automation exists, prepare only greeting angles or draft text for future policy review. Do not send them.

Greeting strategy must use only resume evidence and JD facts. Keep it short, specific, and truthful. If the JD asks for a skill not supported by the resume, describe adjacent experience or interest; do not claim mastery.

## Safety Stops

Do not apply, message, favorite, mark interest, upload, edit resume, change account settings, send contact details, or transmit sensitive information during profile, scan, calibration, report, or handoff. User confirmation before automation can confirm policy only; it cannot authorize immediate manual application.

Only scheduled execution under an enabled automation task may perform account-changing actions, and only inside the saved policy.

Stop for login, CAPTCHA, SMS, password, face verification, account risk, permission prompts, mismatched job page, company-page blocker for a recommended job, or uncertainty about whether an action changes account state.
