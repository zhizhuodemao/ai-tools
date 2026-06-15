# Browser

Use this reference for all live BOSS browser work. This skill uses Kimi WebBridge as the only browser backend.

```text
Kimi health check -> navigate/find_tab -> snapshot -> @e target -> wait >= 3s -> click/fill -> wait >= 3s -> snapshot -> record
```

## Kimi-Only Rule

- Use the `kimi-webbridge` skill for all BOSS browser interaction.
- Do not use `chrome:control-chrome`, Codex Chrome, the in-app browser, Playwright, Selenium, hidden DOM scraping, or URL-construction workflows for BOSS discovery or actions.
- If Kimi WebBridge is unavailable, unhealthy, blocked, or not connected to the user's logged-in browser, stop and report the blocker. Ask the user to install, enable, reconnect, or relaunch Kimi WebBridge.
- Do not switch browser backend mid-run. A blocked Kimi session is a blocker, not permission to fall back to another browser tool.

## Kimi WebBridge Protocol

Use visible page state and Kimi element references.

Default path:

```text
navigate/find_tab -> snapshot -> @e target -> wait >= 3s -> click/fill -> wait >= 3s -> snapshot
```

Prefer `snapshot` refs for search boxes, filters, job cards, company cards, tabs, and buttons. If no suitable `@e` ref appears:

1. scroll or change visible page position,
2. take another snapshot,
3. use a visible coordinate click only when the target is visually unambiguous,
4. otherwise stop and report the UI blocker.

Do not use JS evaluation, CSS locator scripts, hidden DOM reads, generated job URL arrays, or direct `job_detail` URL construction as a substitute for visible clicks.

## 3-Second Throttle

Wait at least 3 seconds between BOSS operations that may change page state or trigger network requests, including:

- navigate to BOSS pages,
- search,
- change city or filters,
- click job cards,
- click company entries,
- paginate or load more,
- scroll when it loads more results,
- click communicate, apply, favorite, or send,
- fill or submit message fields.

Observation-only calls such as snapshots can be used for verification, but if unsure whether an action triggers BOSS requests, wait 3 seconds.

Before an enabled platform automation task is running, do not click communicate, apply, favorite, mark interest, send, upload, or resume-edit controls. These controls are reserved for scheduled execution under policy.

## Click-First Rules

- Open BOSS entry pages directly only as the initial website entry, then use visible UI.
- Discover jobs by visible search, recommendation, list, pagination, and company controls.
- Open every candidate through a visible job-card or job-link click.
- For every valid candidate, click into the company page through visible company name, card, homepage entry, or company tab.
- Saved URLs may be used only to recheck jobs or companies already discovered by visible clicks.

Do not guess job ids, construct `job_detail` URLs, iterate URL variants, use candidate URL arrays, or treat hidden DOM scraping as discovery.

## Company Page Requirement

A candidate is valid only if company-page access was attempted through visible UI. Record:

- whether the company page opened,
- company-page blocker if any,
- company facts visible on the page,
- other posted jobs or visible hiring pattern when available.

If company page cannot be opened, mark the job `blocked_company_page` or `save_only`; do not recommend, greet, or automate it.

## Stop Conditions

Stop for login, CAPTCHA, slider, SMS, password, face verification, account risk, Kimi WebBridge setup or permission prompts, browser permission prompts, or any unclear account-changing control.
