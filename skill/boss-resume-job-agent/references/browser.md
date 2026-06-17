# Browser

Use this reference for all live BOSS browser work. This skill uses Kimi WebBridge as the only browser backend. Kimi WebBridge must be installed, enabled, and connected to the user's real logged-in browser session.

```text
Kimi WebBridge health check -> navigate/find_tab -> snapshot -> visible target -> wait >= 3s -> click/fill -> wait >= 3s -> snapshot -> record
```

## Kimi WebBridge Rule

- Use Kimi WebBridge for all BOSS browser interaction.
- If Kimi WebBridge is unavailable, unhealthy, blocked, or not connected to the user's logged-in browser, stop and report the blocker. Ask the user to install, enable, reconnect, or relaunch Kimi WebBridge from the provided download or installation link.
- Do not use any browser backend other than Kimi WebBridge for BOSS discovery or actions.
- Do not use JS evaluation, CSS locator scripts, hidden DOM reads, generated job URL arrays, or direct `job_detail` URL construction as a substitute for visible Kimi WebBridge clicks.
- Do not switch browser backend mid-run. A blocked Kimi WebBridge session is a blocker, not permission to fall back to another browser path.

## Kimi WebBridge Installation

If Kimi WebBridge is missing or not connected, stop the BOSS workflow and give the user these installation options. Do not continue until the user confirms Kimi WebBridge is installed, enabled, connected, and the browser is logged in to BOSS.

Browser extension page:

```text
https://chromewebstore.google.com/detail/kimi-webbridge/fldmhceldgbpfpkbgopacenieobmligc
```

Terminal install:

```bash
curl -fsSL https://cdn.kimi.com/webbridge/install.sh | bash
```

PowerShell install:

```powershell
irm https://cdn.kimi.com/webbridge/install.ps1 | iex
```

After installation, Kimi WebBridge lets Kimi control the user's browser to complete tasks. For this skill, it must be connected to the same real browser session where the user is logged in to BOSS.

## Kimi WebBridge Protocol

Use visible page state and Kimi WebBridge element references.

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

Before an enabled automation task is running, do not click communicate, apply, favorite, mark interest, send, upload, or resume-edit controls. These controls are reserved for scheduled execution under policy.

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
