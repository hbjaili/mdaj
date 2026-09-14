# OJS/PKP Publication Readiness Audit
## Multi-Disciplinary Aviation Journal (MDAJ) — mdajournal.com
**Audit Date:** September 3, 2026 | **Auditor:** Antigravity AI

---

## Executive Summary

| Domain | Status | Score |
|--------|--------|-------|
| Platform & Infrastructure | 🟡 Mostly Ready | 80% |
| Journal Configuration & Identity | 🟡 Mostly Ready | 75% |
| Security | 🔴 Action Required | 55% |
| Content & Editorial Readiness | 🔴 Not Ready | 25% |
| Plugins & Integrations | 🟡 Mostly Ready | 70% |
| SEO & Discoverability | 🟡 Mostly Ready | 72% |
| User Management & Roles | 🟢 Ready | 85% |
| Email & Communication | 🟢 Ready | 88% |

> [!IMPORTANT]
> The journal is **not yet ready to launch publicly**. The critical blockers are: no published articles or issues, no ISSN registered, no DOI prefix/Crossref configuration, SSL not enforced, and passwords stored with a weak hash algorithm (SHA-1). Addressing these is required before launch.

---

## 1. Platform & Infrastructure

### OJS Version
- **Version Installed:** OJS 3.5.0.5 (installed 2026-08-23) — **current stable release** ✅
- **PHP Version:** 8.3.6 (NTS) ✅

### PHP Extensions
| Extension | Required | Status |
|-----------|----------|--------|
| curl | ✅ | Installed |
| gd | ✅ | Installed |
| intl | ✅ | Installed |
| mbstring | ✅ | Installed |
| mysqli / pdo_mysql | ✅ | Installed |
| xml / xmlreader / xmlwriter | ✅ | Installed |
| zip | ✅ | Installed |
| iconv | ✅ | Installed |
| filter | ✅ | Installed |
| tokenizer | ✅ | Installed |
| soap | ⚠️ | **Not detected** (needed for some integrations) |

### File System & Directories
- **`/home/mdaj/files/`** — uploads directory (outside web root ✅) — currently 324 KB, no submission files yet
- **`public/`** — 188 KB; journal logo, favicon, thumbnail, stylesheet present ✅
- **`cache/`** — 7.4 MB; opcache and template cache populated ✅
- **File permissions:** `www-data` group write access on `public/` and `cache/` ✅
- **`umask = 0022`** in config — appropriate ✅

### URL & Routing
- `restful_urls = On` ✅
- HTTP → HTTPS redirect: **301 confirmed** ✅
- HTTPS → journal path redirect: **302 to `/mda`** ✅
- `.htaccess` rewrite rules in place ✅

> [!WARNING]
> The `.htaccess` still references the **cPanel `ea-php82` handler** (`AddHandler application/x-httpd-ea-php82`). This does not match the detected PHP 8.3.6 runtime. On cPanel servers this may serve PHP 8.2 instead of 8.3 for web requests. Verify and correct the handler to `ea-php83` if appropriate.

### Web Cache
- `web_cache = Off` — acceptable for low-traffic launch, consider enabling after first issue ℹ️

### Job Queue & Scheduled Tasks
- `job_runner = On` ✅
- `task_runner = On` ✅
- Queue processing logs running every ~25 min with no errors ✅
- `failed_jobs = 0` ✅
- No pending jobs in queue ✅

---

## 2. Journal Configuration & Identity

### Basic Identity
| Setting | Value | Status |
|---------|-------|--------|
| Journal Name | Multi-Disciplinary Aviation Journal | ✅ |
| Acronym | MDA | ✅ |
| Abbreviation | Multidiscip. Aviat. J. | ✅ |
| URL | https://mdajournal.com | ✅ |
| Country | US | ✅ |
| Contact Name | Editorial Manager | ⚠️ Generic — should name a real person |
| Contact Email | em@mdajournal.com | ✅ |
| Support Email | support@mdajournal.com | ✅ |
| Site Contact Name | Open Journal Systems | 🔴 **Default placeholder — must be changed** |
| Site Contact Email | admin@mdajournal.com | ✅ |

> [!CAUTION]
> The **Site-level contact name** (`contactName` in `site_settings`) is still set to **"Open Journal Systems"** — the PKP installation default. This appears in system emails. Change it to the journal or institution name immediately.

### ISSN
| Type | Status |
|------|--------|
| Online ISSN | 🔴 **Not configured** |
| Print ISSN | 🔴 **Not configured** |

No ISSN records found in the database. An online ISSN is essential for:
- DOI registration with Crossref
- Indexing (DOAJ, Scopus, Web of Science)
- Metadata standards compliance

### Publisher
- **Publisher institution** is not configured in the journal settings. Required for metadata, DOI deposits, and indexing applications.

### Sections
| ID | Title | Status |
|----|-------|--------|
| 1 | Research Articles | ✅ |
| 2 | Review Articles | ✅ |
| 3 | Short Communication | ✅ |
| 4 | Case Report | ✅ |

Well-structured section taxonomy for an aviation journal ✅

### License & Copyright
- **`licenseURL`** — 🔴 **Not set** (no Creative Commons or other license URL configured)
- **`copyrightHolderType`** — 🔴 **Not set**
- **`copyrightYearBasis`** — set to `issue` ✅
- `pageFooter` reads: *"Copyright © MDA Journal 2025. All rights reserved."* — ⚠️ **Year is 2025; should be updated to 2026. Also conflicts with open-access positioning if no explicit CC license is set.**

> [!IMPORTANT]
> Configure the Creative Commons license (e.g., CC BY 4.0) under **Settings → Distribution → License**. This is required for DOAJ listing and for communicating reuse rights to authors and readers.

### Open Access & Archiving
- Open Access policy: present and appropriate ✅
- LOCKSS statement: configured ✅
- CLOCKSS statement: configured ✅
- OAI-PMH: enabled ✅ (`oai = On`, `repository_id = ojs.mdajournal.com`)

### Submission Settings
- Submissions: **open** (`disableSubmissions = 0`) ✅
- User self-registration: **disabled** (`disableUserReg = 1`) — acceptable if authors contact editors to register; consider enabling for public launch ⚠️
- Review mode: **Double-blind** (`defaultReviewMode = 2`) ✅
- Weeks per review: **4** ✅
- Weeks per response: **4** ✅
- Submission checklist: present ✅
- Submission acknowledgement: configured (`allAuthors`) ✅

### DOI Configuration
| Setting | Value | Status |
|---------|-------|--------|
| DOIs enabled | Yes | ✅ |
| DOI types | `["publication"]` | ✅ |
| DOI suffix type | `default` | ✅ |
| DOI creation time | `copyEditCreationTime` | ✅ |
| DOI versioning | Off | ✅ |
| **Registration agency** | 🔴 **Not configured** | — |
| **Crossref prefix** | 🔴 **Not set** | — |

DOIs are enabled but **no Crossref DOI prefix has been entered**, and the Crossref plugin has no credentials configured. DOIs cannot be deposited until this is resolved.

---

## 3. Security

| Item | Status | Detail |
|------|--------|--------|
| SSL / HTTPS | ⚠️ Partial | HTTP→HTTPS redirect works, but `force_ssl = Off` and `force_login_ssl = Off` in `config.inc.php` |
| Password hashing | 🔴 **Critical** | `encryption = sha1` — SHA-1 is cryptographically broken; OJS 3.5 supports bcrypt/argon2 |
| Salt | 🔴 **Critical** | `salt = "YouMustSetASecretKeyHere!!"` — **Default placeholder salt has not been changed** |
| API key secret | ⚠️ | `api_key_secret = ""` — empty; set a long random string if API is used |
| Session IP check | ✅ | `session_check_ip = On` |
| Session same-site | ✅ | `session_samesite = Lax` |
| Allowed hosts | ✅ | `allowed_hosts = ["mdajournal.com"]` |
| `trust_x_forwarded_for` | ✅ | Off |
| Debug mode | ✅ | Off; `display_errors = Off`; `show_stacktrace = Off` |
| Sandbox mode | ✅ | Off |
| ALTCHA captcha | ✅ | Enabled on register, login, lost password |
| reCAPTCHA | ℹ️ | Enabled in config but using placeholder keys — effectively inactive |
| `app_key` | ✅ | Set (base64 encoded) |

> [!CAUTION]
> **The salt is still the default placeholder `"YouMustSetASecretKeyHere!!"`** — this is a critical security misconfiguration that makes all stored password hashes predictable. Change this immediately (note: existing user sessions will be invalidated).

> [!CAUTION]
> **`encryption = sha1`** — SHA-1 password hashing is weak. Upgrade to `bcrypt` in `config.inc.php`. After changing, users will be migrated on next login.

> [!WARNING]
> **`force_ssl = Off`** — while HTTP is being redirected via `.htaccess`, it is best practice to enforce SSL at the OJS layer as well. Set `force_ssl = On` and `force_login_ssl = On`.

### Credentials Exposure in Config
- Database password and SMTP password are stored in `config.inc.php` in plaintext — this is standard for OJS, but ensure the file is **not readable by other users** on the server. Current permissions appear appropriate (owned by `mdaj`).
- The ALTCHA HMAC key is set ✅

---

## 4. Content & Editorial Readiness

> [!CAUTION]
> This is the most critical gap. The journal has **zero published content**.

| Metric | Count | Status |
|--------|-------|--------|
| Total users | 7 | ✅ |
| Published articles | **0** | 🔴 |
| Total submissions | 1 (in progress) | 🔴 |
| Published issues | **0** | 🔴 |
| Total issues created | **0** | 🔴 |

### The One Submission
- Title: *"The Low-Cost Carrier Ascendancy in India: An Empirical Evaluation"*
- Status: **Draft** (Stage 1 — submission)
- Not yet assigned to a section editor or sent for review

### Announcements (5 active)
1. *MDA Welcomes Submissions for the 2026 Issue* — posted 2026-08-27 ✅
2. *New LaTeX Template Available* — posted 2026-08-28 ✅
3. *Reviewer Recruitment Now Open* — posted 2026-08-29 ✅
4. *Article Processing Charge Waiver Program* — posted 2026-08-30 ✅
5. *Special Issue on Artificial Intelligence in Aviation* — posted 2026-08-31 ✅

Announcements are active and relevant ✅ — however with no published articles, they may mislead authors about the journal's operational status.

### What's needed before launch:
- [ ] At least one published issue with articles OR a clear "forthcoming" issue
- [ ] Alternatively, consider launching with a pre-publication announcement strategy
- [ ] Complete the one in-progress submission through peer review and publish it

---

## 5. Plugins & Integrations

### Enabled Plugins
| Plugin | Status | Notes |
|--------|--------|-------|
| **mdaDetox theme** | ✅ Active | Custom theme — homepage renders correctly |
| citationStyleLanguage | ✅ | Citation formatting |
| crossref | ✅ Enabled | ⚠️ No credentials configured |
| customBlockManager | ✅ | |
| customHeader | ✅ | SEO meta tags injected |
| defaultTheme | ✅ | Fallback theme |
| dublinCoreMetadata | ✅ | Metadata export |
| googleAnalytics | ✅ Enabled | ⚠️ No tracking ID configured (see below) |
| googleScholar | ✅ | Article metadata for Scholar |
| htmlArticleGalley | ✅ | HTML galley viewer |
| informationBlock | ✅ | Sidebar |
| jatsTemplate | ✅ | JATS XML export |
| lensgalley | ✅ | PDF viewer |
| makeSubmissionBlock | ✅ | Sidebar CTA |
| pdfjsViewer | ✅ | In-browser PDF |
| recommendBySimilarity | ✅ | |
| staticPages | ✅ Enabled | No static pages created yet |
| subscriptionBlock | ✅ | |
| tinyMCE | ✅ | Rich text editor |
| usageEvent | ✅ | Usage statistics |
| webfeed | ✅ | RSS/Atom feeds |
| browseBlock | ✅ | |
| languageToggle | ✅ | |

### Google Analytics
- Plugin enabled, but **no tracking ID (GA4 measurement ID)** found in plugin settings — analytics data will not be collected.

### Crossref Plugin
- Enabled, but **no DOI prefix, depositor name, or password** configured. Must be set up before DOIs can be registered.

### ORCID
- Plugin is installed but **disabled** (`orcidEnabled = 0`, `orcidClientId` is empty). Consider enabling for author verification — especially important for a new journal building credibility.

### Static Pages
- Plugin enabled but **zero static pages created**. Navigation menu includes items linking to: `review-process`, `policies`, `plagiarism-policy`, `editorial-team`, `for-authors`, `call-for-papers`, `open-access`, `charges`. **These custom navigation items exist but the corresponding static page content has not been created** — they will return 404 errors.

> [!CAUTION]
> **Multiple navigation menu links will 404 at launch.** The following custom menu paths exist without corresponding static pages: `review-process`, `policies`, `plagiarism-policy`, `editorial-team`, `for-authors`, `call-for-papers`, `open-access`, `charges`. Create static pages or link them to existing About pages.

---

## 6. SEO & Discoverability

| Item | Status | Detail |
|------|--------|--------|
| Meta description | ✅ | Set (2 instances — minor duplicate) |
| Meta keywords | ✅ | Configured |
| OAI-PMH | ✅ | Enabled |
| Dublin Core | ✅ | Plugin active |
| Google Scholar metadata | ✅ | Plugin active |
| JATS XML | ✅ | Plugin active |
| Sitemap | ⚠️ | Not detected (no sitemap plugin or file) |
| robots.txt | ⚠️ | Only disallows `/cache/` — should also block `/private/`, `/files/`, `/lib/pkp/`, etc. |
| Canonical URLs | ✅ | restful_urls enabled |
| Page title in HTML | 🔴 | Homepage `<title>` tag renders **empty** |
| ISSN in metadata | 🔴 | Not set — cannot be included |
| DOI | 🔴 | No articles published yet |

> [!WARNING]
> The `<title>` tag on the homepage is empty. This is a significant SEO problem and likely caused by a theme template issue. Investigate the `mdaDetox` theme's `header.tpl` or `frontend/pages/index.tpl`.

> [!NOTE]
> There are two `<meta name="description">` tags injected — one from OJS core settings and one from the custom headers plugin. While not harmful, it's cleaner to remove the duplicate from the custom headers.

---

## 7. User Management & Roles

### Current Users
| Username | Email | Role | Last Login |
|----------|-------|------|------------|
| ojsadmin | admin@mdajournal.com | Site Admin + Journal Manager | 2026-08-23 |
| em@mdajournal.com | em@mdajournal.com | Journal Editor | 2025-10-10 |
| mbourchak | mbourchak@kau.edu.sa | Section Editor | 2025-12-13 |
| hbjaili | hasan@bjaili.com | Section Editor | 2026-02-03 |
| ATTAR | batoul.attar@live.com | Reviewer | 2025-12-19 |
| batikh | ahmad.batikh@icam.fr | Reviewer | 2025-12-18 |
| Oozypal@gmail.com | Oozypal@gmail.com | Reviewer + Author + Reader | **Never logged in** |

### Observations
- **Editorial Manager (em@mdajournal.com)** has not logged in since October 2025 — confirm this account is still active
- **Oozypal@gmail.com** registered in March 2026 and has **never logged in** — may be an orphan account
- Only **2 reviewers** who have ever logged in (ATTAR and batikh) — minimal reviewer pool
- No Editorial Board Members assigned to the `mastheadUserGroupIds = [3,5,19]` group (group 19 = Editorial Board Member) — masthead will appear incomplete
- Self-registration is disabled — authors must be manually registered by an admin

---

## 8. Email & Communication

| Setting | Value | Status |
|---------|-------|--------|
| SMTP Server | smtp.purelymail.com:587 (TLS) | ✅ |
| Sender | noreply@mdajournal.com | ✅ |
| Envelope sender | eic@mdajournal.com | ✅ |
| Force DMARC compliant From | On | ✅ |
| DMARC display name | `%n via MDA Journal` | ✅ |
| Require email validation | On | ✅ |
| Cert check suppressed | Off | ✅ |
| Email logs | 2 entries (test emails) | ✅ |

Email configuration is well set up. DMARC-compliant sending is properly configured for PurelyMail ✅.

> [!NOTE]
> Verify that the domain `mdajournal.com` has SPF, DKIM, and DMARC DNS records configured for PurelyMail. Without these, outbound emails (review invitations, author notifications) may land in spam.

---

## 9. Theme & Branding

| Asset | Status |
|-------|--------|
| Active theme | `mdaDetox` (custom) |
| Logo (SVG) | ✅ Uploaded (updated 2026-08-26) |
| Favicon | ✅ Uploaded |
| Journal thumbnail | ✅ Uploaded |
| Custom stylesheet | ✅ Present (`public/journals/1/styleSheet.css`) |
| Footer | Set to "Copyright © MDA Journal 2025" ⚠️ (outdated year) |
| Theme colors | Accent `#C2A24E`, Base `#5D9694` |

The custom `mdaDetox` theme appears functional. The homepage renders with content (~21 KB response).

---

## 10. Critical Action Items Before Launch

### 🔴 BLOCKERS (Must fix before launch)

1. **Change the security salt** — `salt = "YouMustSetASecretKeyHere!!"` in `config.inc.php`
2. **Upgrade password encryption** — change `encryption = sha1` to `encryption = bcrypt`
3. **Register an ISSN** — apply for an online ISSN at https://www.issn.org (takes 2–4 weeks)
4. **Fix the empty `<title>` tag** — critical SEO and usability issue
5. **Create static pages** for all navigation links (`review-process`, `policies`, `for-authors`, `editorial-team`, `plagiarism-policy`, `charges`, `open-access`, `call-for-papers`)
6. **Publish at least one issue** — or accept that the journal launches in "awaiting first issue" mode with a clear notice
7. **Configure DOI prefix** — enter Crossref credentials in the Crossref plugin settings

### 🟡 HIGH PRIORITY (Fix within first week)

8. **Set the CC license URL** — Settings → Distribution → License → select CC BY 4.0 or preferred license
9. **Configure publisher institution name** in journal settings
10. **Enable SSL enforcement** — set `force_ssl = On` in `config.inc.php`
11. **Fix `.htaccess` PHP handler** — change `ea-php82` to `ea-php83` if server runs PHP 8.3
12. **Fix the site contact name** — change from "Open Journal Systems" in Site → Settings
13. **Update footer copyright year** from 2025 to 2026
14. **Configure Google Analytics tracking ID** (GA4 measurement ID in the plugin settings)
15. **Remove duplicate `<meta name="description">` tag** from custom headers

### 🟢 RECOMMENDED (Before or shortly after launch)

16. **Enable ORCID integration** — apply for ORCID membership and configure client ID/secret
17. **Enable self-registration** — or document the submission/registration process clearly on the site
18. **Build reviewer pool** — only 2 active reviewers is insufficient for a functioning journal
19. **Set up sitemap** — consider the PKP StaticPages or another approach; submit sitemap to Google Search Console
20. **Harden robots.txt** — add disallow rules for `/lib/`, `/templates/`, `/dbscripts/` etc.
21. **Apply for DOAJ listing** — requires ISSN, CC license, and at least one published issue
22. **Enable ORCID plugin** after acquiring credentials
23. **Set `api_key_secret`** to a long random string if API access will be used
24. **Verify SPF/DKIM/DMARC** DNS records for PurelyMail sending
25. **Add Editorial Board Member profiles** to the masthead

---

## Appendix: Configuration Summary

```ini
; Key config.inc.php values
installed = On
base_url = "https://mdajournal.com"
restful_urls = On
force_ssl = Off              ; ← needs to be On
encryption = sha1            ; ← needs to be bcrypt
salt = "YouMustSetASecretKeyHere!!"  ; ← critical - change immediately
oai = On
job_runner = On
task_runner = On
altcha = on                  ; ← good
recaptcha = off              ; ← placeholder keys
```

---

*Report generated by Antigravity AI on 2026-09-03 from direct database and filesystem inspection of the OJS installation at `/home/mdaj/www`.*
# MDA Journal Project Documentation

Last documentation update: 2026-09-01

## Purpose

This is the single consolidated project guide for the MDA Journal OJS
installation and its custom `mdaDetox` theme. It replaces the previous
scattered project README, theme notes, and operational checklists.

The active design is **MDA Detox**, based on the Detox reference template under
`/home/mdaj/resources/Detox`. Historical Katen references are obsolete.

## Consolidated sources

This document merges and updates the following project markdown files:

- `/home/mdaj/resources/README.md`
- `/home/mdaj/resources/theme_info.md`
- `/home/mdaj/resources/documentation/mdajournal-production-hardening.md`
- `/home/mdaj/resources/documentation/mdajournal-public-launch-roadmap.md`
- `plugins/themes/mdaDetox/README.md`
- `plugins/themes/mdaDetox/templates/README.md`

OJS upstream and third-party/vendor README files are intentionally excluded.

## Current verified state

- OJS installation: `/home/mdaj/public_html`
- Convenience symlink: `/home/mdaj/www` -> `/home/mdaj/public_html`
- OJS version: `3.5.0.5`
- PHP CLI version at verification: `8.3.6`
- Journal: `journal_id=1`, public path `mda`
- Public journal URL: `https://mdajournal.com/mda/`
- Active theme path in `journal_settings`: `mdaDetox`
- Theme plugin: `/home/mdaj/public_html/plugins/themes/mdaDetox`
- Plugin class: `MdaDetoxThemePlugin`
- Plugin release: `1.0.0.0`
- Parent theme: `defaultthemeplugin`
- `mdadetoxthemeplugin` is enabled for journal 1
- `defaultthemeplugin` is enabled for journal 1

The runtime details above were last verified on 2026-08-30. The documentation
was consolidated and updated on 2026-09-01.

## Project locations

- OJS web root: `/home/mdaj/public_html`
- Project resource root: `/home/mdaj/resources`
- Consolidated project guide: `/home/mdaj/public_html/PROJECT.md`
- Theme plugin: `/home/mdaj/public_html/plugins/themes/mdaDetox`
- Authoritative Detox reference template: `/home/mdaj/resources/Detox`
- Detox homepage reference: `/home/mdaj/resources/Detox/index.php`
- Detox header markup: `/home/mdaj/resources/Detox/parts/header/main-header.php`
- Detox header styles: `/home/mdaj/resources/Detox/assets/css/style.css`
- Detox animation definitions: `/home/mdaj/resources/Detox/assets/css/animate.css`
- Detox scroll behavior: `/home/mdaj/resources/Detox/assets/js/script.js`
- Shared project assets: `/home/mdaj/resources/assets`
- Operational documentation: `/home/mdaj/resources/documentation`

The original Detox visual reference is stored at
`/home/mdaj/resources/Detox/index.php` and should be checked with its local CSS,
JavaScript, partials, and browser presentation when refining the OJS theme. The
finished OJS theme must not depend on that source directory at runtime.

## Detox header reference behavior

The canonical Detox desktop header uses two separate elements: the large
`.main-header` content and a compact `.sticky-header`. Its implementation is:

- `assets/js/script.js` adds `.fixed-header` after the page reaches 110px.
- `assets/css/style.css` keeps `.sticky-header` fixed, white, transparent, and
  hidden initially, then reveals it when `.fixed-header` is present.
- `assets/css/animate.css` defines `fadeInDown` as an opacity fade combined with
  a small vertical movement from `translateY(-20px)` to `translateY(0)`.
- The reveal lasts 500ms and uses linear timing in the Detox header rule.
- In the compact sticky menu, the bar remains white while the current, hovered,
  or keyboard-focused top-level item uses the primary blue background with
  white text.
- The Detox responsive stylesheet hides the separate sticky header at widths
  of 991px and below.

The OJS adaptation intentionally uses one dynamic header rather than cloning
navigation markup. This preserves OJS identity, menus, search, login state,
mobile navigation, and accessibility behavior. Its scrolled state should still
match Detox visually: trigger at 110px, become compact and fixed with a white
background and shadow, show the active top-level item on the primary blue
background, then fade down over 500ms from only 20px above. The compact geometry
must be applied before it becomes visible; animating the large header's height
at the same time produces a visible jerk. Do not replace the 20px movement with
a full-header `translateY(-100%)`, which also produces an abrupt entrance.

OJS's public navigation template does not emit a selected-item class. The theme
JavaScript therefore compares each top-level primary-navigation URL with the
current URL, normalizes `/index` and `/index.php` to the journal homepage, adds
`mda_detox_nav_item--current`, and sets `aria-current="page"`. In the compact
desktop menu, each item and anchor is exactly 70px high with zero item margins,
and the compact bar itself carries no vertical padding, so the selected blue
background fills the complete bar height without gaps.

## Architecture and boundaries

OJS remains responsible for routing, authentication, submissions, editorial
workflows, journal metadata, issues, articles, search, user accounts, and
upgrades. `mdaDetox` is a native child theme that changes presentation without
replacing those functions.

Do not edit OJS core or the bundled Default Theme to implement MDA Detox. Keep
custom PHP, LESS, JavaScript, images, locale strings, and template overrides in
`plugins/themes/mdaDetox`.

Keep these items outside the web root:

- Original design archives and extracted reference templates
- Design documentation and demo pages
- Planning and operational notes
- Temporary exports, screenshots, experiments, and working files
- Backups, database dumps, logs, and diagnostic scripts

Do not move, rename, or remove an OJS distribution file merely because it is
used during development, testing, documentation, or source control.

## Theme structure

```text
plugins/themes/mdaDetox/
|-- MdaDetoxThemePlugin.php
|-- index.php
|-- version.xml
|-- locale/
|   `-- en/locale.po
|-- images/
|   |-- about-journal.png
|   |-- home-hero.png
|   |-- home-hero-detail-1.png
|   |-- home-hero-detail-2.png
|   |-- home-hero-detail-3.png
|   |-- home-hero-detail-4.png
|   |-- home-pattern-left.png
|   `-- home-pattern-right.png
|-- js/
|   `-- main.js
|-- styles/
|   |-- variables.less
|   |-- base.less
|   |-- index.less
|   |-- components/
|   |   |-- header.less
|   |   |-- cta.less
|   |   `-- footer.less
|   `-- pages/
|       |-- home.less
|       |-- about.less
|       |-- editorial-team.less
|       |-- privacy.less
|       |-- announcements.less
|       |-- custom-page.less
|       `-- issue.less
`-- templates/
    |-- frontend/
    |   |-- components/header.tpl
    |   |-- components/footer.tpl
    |   |-- pages/indexJournal.tpl
    |   |-- pages/about.tpl
    |   |-- pages/navigationMenuItemViewContent.tpl
    |   |-- pages/privacy.tpl
    |   |-- pages/announcements.tpl
    |   |-- pages/issue.tpl
    |   `-- pages/issueArchive.tpl
    `-- plugins/
        `-- blocks/information/templates/block.tpl
```

Key responsibilities:

- `MdaDetoxThemePlugin.php` registers the Default Theme parent, colour option,
  fonts, LESS, and JavaScript.
- `styles/variables.less` contains shared design tokens.
- `styles/components/header.less` controls desktop and mobile navigation.
- `styles/components/cta.less` controls the call-to-action band.
- `styles/components/footer.less` controls the footer layout and links.
- `styles/pages/home.less` controls the hero and homepage sections.
- `styles/pages/about.less`, `editorial-team.less`, `privacy.less`, and
  `announcements.less` control the corresponding public pages.
- `templates/frontend/components/header.tpl` preserves OJS identity, menus,
  search, user actions, and accessibility hooks in a Detox-style header.
- `templates/frontend/components/footer.tpl` renders the Detox-style footer from
  OJS journal metadata and navigation.
- `templates/frontend/pages/indexJournal.tpl` maps live OJS content into the
  Detox homepage.
- `templates/frontend/pages/about.tpl`, `privacy.tpl`, and `announcements.tpl`
  apply the Detox page banner/content layout.
- `templates/frontend/pages/navigationMenuItemViewContent.tpl` applies the same
  layout to custom navigation-menu pages, including Editorial Team.
- `templates/plugins/blocks/information/templates/block.tpl` keeps the sidebar
  Information links consistent with the footer.
- `js/main.js` progressively enhances the sticky header and animated heading,
  and respects the user's reduced-motion preference.

## Template overrides

The `mdaDetox` theme currently contains ten deliberate OJS template
overrides:

- `frontend/components/header.tpl`
- `frontend/components/footer.tpl`
- `frontend/pages/indexJournal.tpl`
- `frontend/pages/about.tpl`
- `frontend/pages/navigationMenuItemViewContent.tpl`
- `frontend/pages/privacy.tpl`
- `frontend/pages/announcements.tpl`
- `frontend/pages/issue.tpl`
- `frontend/pages/issueArchive.tpl`
- `plugins/blocks/information/templates/block.tpl`

Keep overrides minimal, prefer inherited OJS behavior where practical, and
review every override during an OJS upgrade.

## Implemented features

- Native OJS 3.5 theme metadata, entry point, namespace, and English locale
- Default Theme inheritance
- Configurable primary colour, defaulting to `#6377EE`
- Poppins headings and Roboto body typography
- Responsive white header with dynamic OJS identity and menus
- Mobile navigation breakpoint at 1200px
- Full-width Detox-style homepage
- Layered Detox hero illustration and background patterns
- Animated “Multi-Disciplinary Aviation Journal” heading
- CMS-managed hero introduction
- For Readers, For Authors, and For Librarians navigation cards
- Illustrated About section
- Dynamic announcements and current-issue output
- Detox-style footer with brand, quick links, information, and contact columns
- Detox page-banner and breadcrumb treatment for About, Editorial Team, Privacy,
  Announcements, Current Issue, Issue Archive, and custom policy pages
- Card-style Announcements list using OJS announcement data
- Card-style Issue Archive list using OJS issue summaries
- Generic Detox layout for custom navigation-menu pages such as Call for Papers,
  Author Guidelines, Review Process, Charges, Plagiarism Policy, and Open Access
- Keyboard focus and reduced-motion support

The individual announcement detail page remains on the default OJS layout.

## CMS content mapping

The homepage hero paragraph uses OJS's **Additional Content** field. If that
field is empty, it falls back to the localized journal description.

Manage it in:

**Settings -> Website -> Appearance -> Additional Content**

The visible hero-heading words are locale strings in
`plugins/themes/mdaDetox/locale/en/locale.po`. The configured journal name
remains available to assistive technology and metadata.

Journal titles, articles, authors, issues, metadata, navigation, and user
controls must continue to come from OJS. Do not hard-code reference-template
demo content.

## Development rules

1. Check Git status before editing anything in `public_html`.
2. Determine whether a target path belongs to the tracked OJS distribution.
3. Preserve unrelated user changes and treat ambiguous files as OJS files.
4. Extend the Default Theme unless a verified incompatibility prevents it.
5. Prefer OJS data, hooks, inherited markup, and CSS over template copies.
6. Keep every required template override as small as practical.
7. Review all template overrides during every OJS upgrade.
8. Put shared tokens in `styles/variables.less`.
9. Put reusable styling in `styles/components/` and route-specific styling in
   `styles/pages/`.
10. Import each new LESS file from `styles/index.less`.
11. Use progressive enhancement for JavaScript.
12. Preserve keyboard focus visibility and reduced-motion behavior.
13. Copy only licensed assets required by the finished theme.
14. Avoid unnecessary third-party frontend dependencies.

The Detox source's Bootstrap, PHP page composition, jQuery plugins, icon
fonts, animation libraries, demo content, and business/e-commerce features are
not runtime dependencies and should not be copied wholesale into OJS.

## Validation

From `/home/mdaj/public_html`, run:

```bash
php -l plugins/themes/mdaDetox/MdaDetoxThemePlugin.php
php -l plugins/themes/mdaDetox/index.php
php -r '$xml = simplexml_load_file("plugins/themes/mdaDetox/version.xml"); exit($xml === false ? 1 : 0);'
node --check plugins/themes/mdaDetox/js/main.js
php -r 'require "lib/pkp/lib/vendor/autoload.php"; $less = new Less_Parser(["compress" => true]); $less->parse("@mda-detox-primary:#6377EE;"); $less->parseFile("plugins/themes/mdaDetox/styles/index.less"); $less->parse("@baseUrl:\"https://example.test\";"); echo strlen($less->getCSS()), PHP_EOL;'
```

At the 2026-08-30 verification, PHP, XML, JavaScript, and LESS validation all
passed. The compiled compressed theme CSS was 21,174 bytes. After adding the
Announcements page, the LESS compile still passes.

After a meaningful change, also test public and authenticated OJS workflows:

- Homepage
- About pages
- Editorial Team, Privacy, and Announcements pages
- Announcement detail page
- Current issue and issue archive
- Article detail and galley downloads
- Search
- Login, registration, and user navigation
- Submission and editorial pages appropriate to the test account
- Mobile, tablet, laptop, and wide desktop layouts
- Keyboard navigation, focus, headings, contrast, and reduced motion

## Activation

1. Keep the bundled Default Theme plugin enabled.
2. Sign in as Journal Manager.
3. Open **Settings -> Website -> Appearance -> Theme**.
4. Select **MDA Detox Theme** and save.
5. Clear OJS template and data caches.
6. Hard-refresh the browser and review desktop and mobile layouts.

If a copied database already selects `mdaDetox`, ensure the complete plugin
directory exists before loading the journal.

## Disable or remove

1. Select Default or another installed theme in OJS.
2. Disable the MDA Detox plugin.
3. Clear OJS template and data caches.
4. Delete `plugins/themes/mdaDetox` only if permanent removal is intended and
   a recoverable copy exists.

Disabling or removing the theme must not remove journal data or alter OJS core.

## Remaining work

- Complete visual refinement of the header and navigation
- Style the individual announcement detail page to match the Announcements list
- Confirm final brand colours, logo use, and licensed imagery
- Design article summaries
- Design article detail and galley-download pages
- Design search page
- Design the sidebar blocks and supporting navigation
- Test responsive behavior across target viewport sizes
- Perform a complete accessibility review
- Test with realistic journal content and authenticated roles
- Complete the production hardening and public launch checklists
- Package and version the first production-ready theme release

## Documentation policy

This file is the single authoritative project and theme guide. Component-level
README files in `plugins/themes/mdaDetox` may contain only a pointer here plus a
short statement needed at that location. OJS's root `README.md` is upstream OJS
documentation and must remain unchanged.

The original source files under `/home/mdaj/resources` may remain for historical
reference, but this consolidated file is the current source of truth.

## Historical theme notes

The current MDA Journal project and MDA Detox theme documentation has been
consolidated into this file. The active theme is `mdaDetox`, based on the Detox
reference template under `/home/mdaj/resources/Detox`. Historical Katen build
notes are obsolete. There is no `healthSciences` theme in the active MDA Journal
setup.

## Production hardening checklist

This section separates OJS application hardening from infrastructure changes
that must be applied directly on the production server or in Cloudflare. Do not
copy secrets from the testing server. Generate new production secrets.

### OJS application changes

The following were previously applied locally:

- HTTPS enforcement enabled with `force_ssl = On`.
- Email validation required with `require_validation = On`.
- Unvalidated accounts expire after 2 days with `user_validation_period = 2`.
- OJS 3.5 ALTCHA enabled for registration, login, and lost-password forms.
- ALTCHA work factor set to `100000`.
- A unique ALTCHA HMAC secret was generated locally.
- 35,620 disabled bot accounts were deleted from the local database after backup.

At the time of this consolidation, the diagnostic scripts `check.php` and
`check_pw.php` are present in the repository root and expose SMTP configuration.
They must be removed from the production web root before deployment.

When pushing application files, confirm that the production `config.inc.php`
retains its production database and SMTP credentials. Do not overwrite them with
testing credentials. Generate a new ALTCHA HMAC key for production:

```bash
openssl rand -hex 32
```

Use the generated value in the production configuration:

```ini
user_validation_period = 2
force_ssl = On
require_validation = On

[captcha]
recaptcha = off
captcha_on_register = on
captcha_on_login = on
altcha = on
altcha_hmackey = 'REPLACE_WITH_NEW_PRODUCTION_SECRET'
altcha_on_register = on
altcha_on_login = on
altcha_on_lost_password = on
altcha_encrypt_number = 100000
```

### Credentials requiring manual action

- Rotate the SMTP password through the email provider. The former diagnostic
  scripts exposed it.
- Update only the production `smtp_password` after rotation.
- Reset passwords for administrator, journal manager, editor, and section editor
  accounts.
- Use unique passwords stored in a password manager.

### Cloudflare configuration

Apply after the production domain is proxied through Cloudflare.

#### SSL/TLS

- Set SSL/TLS encryption mode to **Full (strict)**.
- Enable **Always Use HTTPS**.
- Enable **Automatic HTTPS Rewrites**.
- Keep a valid Let's Encrypt or Cloudflare Origin certificate on production.
- Do not use Flexible SSL.

#### WAF and bot protection

- Enable Cloudflare Managed Rules.
- Enable Bot Fight Mode if available on the account.
- Challenge requests with an abnormally high threat score.
- Do not challenge verified search-engine bots.

#### Rate-limit rules

Start conservatively and review logs before tightening limits:

- Registration paths containing `/user/register`: challenge after 3 requests per
  IP in 10 minutes.
- Login paths containing `/login/signIn`: challenge after 10 requests per IP in
  5 minutes.
- Lost-password paths containing `/lostPassword`: challenge after 5 requests per
  IP in 15 minutes.
- Protect `/index/admin` and management paths with a managed challenge for
  unfamiliar countries or networks, if appropriate.

Prefer a Cloudflare Managed Challenge before blocking. Exclude trusted
office/VPN IP addresses where necessary.

#### Preserve real visitor IP addresses

Install and configure `mod_remoteip` on Apache so logs and OJS receive the
Cloudflare visitor IP rather than a Cloudflare proxy address. Trust only
Cloudflare's published IP ranges. After testing real-IP handling, set:

```ini
trust_x_forwarded_for = On
```

Do not enable this OJS setting before Apache is restricted to trusted Cloudflare
proxies; otherwise clients can spoof their IP address.

#### Lock the origin to Cloudflare

After confirming Cloudflare works, restrict ports 80 and 443 at the firewall to
Cloudflare's published IPv4 and IPv6 ranges. Keep SSH restricted to administrator
IP addresses. This prevents attackers from bypassing Cloudflare and hitting the
origin directly.

### Apache production configuration

- Redirect all HTTP traffic to `https://mdajournal.com/`.
- Use the correct certificate for both `mdajournal.com` and `www.mdajournal.com`.
- Redirect `www.mdajournal.com` to the canonical non-www hostname.
- Disable directory listing with `Options -Indexes`.
- Ensure Apache does not serve hidden files, backups, SQL dumps, logs, or
  configuration files.
- Add security headers after testing journal workflows:

```apache
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "camera=(), microphone=(), geolocation=()"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

Add HSTS only after HTTPS works correctly on every required subdomain. Build and
test a Content Security Policy separately before enforcing it because OJS themes
and plugins may require additional sources.

### File ownership and permissions

- Application code should be owned by the deployment account and not writable by
  Apache.
- Only OJS runtime directories should be writable by the web-server group.
- Keep `files_dir` outside the public web root.
- Keep `config.inc.php` readable only by the owner and web-server group.

Example pattern; adjust account names and paths for production:

```bash
chown -R mdaj:www-data /home/mdaj/public_html/cache \
  /home/mdaj/public_html/public \
  /home/mdaj/public_html/usageStats \
  /home/mdaj/public_html/scheduledTaskLogs \
  /home/mdaj/files

chmod 640 /home/mdaj/public_html/config.inc.php
chmod 2770 /home/mdaj/files
```

Do not recursively grant `777` permissions.

### Remove dangerous and unnecessary files

Confirm these are absent from the production web root:

```text
check.php
check_pw.php
*.sql
*.tar.gz
*.zip
config.inc.php.bak
delete_list.txt
delete_log.txt
```

Keep database dumps and private backups outside `public_html`.

### Database and account controls

- Take a fresh database backup before pushing the cleaned local database.
- Verify the production user count and privileged roles immediately after import.
- Confirm no disabled bot accounts remain.
- Review administrator/editor role membership monthly.
- Test registration, validation email, login, password reset, submission,
  reviewer assignment, and user removal after deployment.

### Updates and backups

- Track supported OJS releases and install security updates promptly.
- Keep PHP, Apache, MariaDB, Certbot, and OS security packages updated.
- Back up the database, `public/`, private `files_dir`, and production
  configuration daily.
- Encrypt off-server backups and test restoration regularly.
- Never restore a database dump without verifying its timestamp and origin.

### Monitoring

- Monitor registration counts, failed logins, HTTP 403/429 responses, PHP fatal
  errors, and unusual administrator activity.
- Configure Cloudflare security-event alerts.
- Review Apache access/error logs and OJS scheduled-task logs.
- Alert on unexpected PHP files created beneath writable directories.
- Recheck TLS expiry and automatic renewal after every DNS or server migration.

### Deployment verification

After pushing to production, verify:

1. DNS resolves to Cloudflare and Cloudflare resolves to the correct origin.
2. HTTPS is trusted for root and `www` hostnames.
3. HTTP redirects to HTTPS and `www` redirects to the canonical hostname.
4. ALTCHA appears on registration, login, and password reset.
5. Validation emails are delivered.
6. Legitimate registration succeeds and automated registration without ALTCHA
   fails.
7. The users API and management screens work normally.
8. Cloudflare shows the visitor's real IP in Apache logs.
9. Backups complete and a restore test succeeds.

## Public launch roadmap

### Current readiness

The OJS website is enabled and publicly accessible, but the journal is not yet
ready for formal indexing.

Current database findings:

- Journal is enabled.
- One active submission exists.
- Zero articles are published.
- Zero issues are published.
- No ISSN is configured.
- No publisher institution is configured.
- No clear publication license is configured.
- CLOCKSS wording is displayed, but it must be removed unless the journal
  actually participates in CLOCKSS.

The immediate priority is credible journal content and complete publishing
policies—not XML export plugins.

### Phase 1: Complete the journal identity

Add and verify the following information in OJS:

- Full journal title: Multi-Disciplinary Aviation Journal.
- Journal abbreviation: MDA Journal.
- Legal publisher or owner name.
- Publisher's country and physical address.
- Official journal email address.
- Primary editorial contact.
- Publication frequency.
- Complete aims and scope.
- Online ISSN once issued.
- Print ISSN, only if a print edition exists.

#### Editorial board

Publish a complete editorial-board page containing:

- Full name of every member.
- Editorial role.
- Institutional affiliation.
- Country.
- ORCID or institutional profile when available.

Do not list anyone without their permission.

### Phase 2: Complete publication policies

Publish clear, separate policies covering the following topics.

#### Editorial and review

- Editorial process.
- Peer-review model.
- Expected review stages and timelines.
- Reviewer confidentiality.
- Editorial independence.
- Handling of submissions from editors or board members.

#### Publication ethics

- Research and publication ethics.
- Plagiarism and duplicate publication.
- Authorship and contributorship criteria.
- Conflicts of interest.
- Research involving people or animals.
- Informed consent.
- Data fabrication and image manipulation.
- Handling allegations of misconduct.

#### Corrections and complaints

- Corrections and errata.
- Retractions.
- Expressions of concern.
- Complaints and appeals.
- Post-publication discussion.

#### Copyright and access

- Copyright owner.
- Open-access policy.
- Reuse license, preferably Creative Commons Attribution 4.0 (CC BY 4.0), if
  appropriate.
- Author self-archiving policy.
- Article processing charges, or a clear statement that the journal charges no
  fees.
- Fee-waiver policy if charges exist.
- Privacy policy.
- Essential-cookie notice.

#### Data and preservation

- Research-data availability policy.
- Data citation expectations.
- Repository recommendations.
- Long-term digital-preservation policy.

Do not claim participation in CLOCKSS, LOCKSS, Portico, Crossref, DataCite,
DOAJ, PubMed, MEDLINE, or another service until participation is confirmed.

### Phase 3: Prepare the first issue

The journal should have credible peer-reviewed content before it is promoted
widely.

For each initial article:

1. Confirm that it fits the journal's scope.
2. Complete editorial screening.
3. Obtain at least two appropriate independent reviews when required by policy.
4. Record editorial decisions in OJS.
5. Complete revisions.
6. Copyedit the accepted manuscript.
7. Proofread the final version.
8. Produce an accessible final PDF.
9. Verify title, abstract, keywords, references, and author metadata.
10. Verify author affiliations and countries.
11. Add ORCID identifiers when available.
12. Add funding and conflict-of-interest statements.
13. Add copyright and license information.
14. Obtain final author approval.

Create and publish the first issue only after all article metadata and final
files have been checked.

Every published article must have its own permanent public landing page.

### Phase 4: Obtain an ISSN

Apply through the appropriate national ISSN centre.

Prepare the following information:

- Journal title and abbreviation.
- Publisher's legal name and address.
- Journal URL.
- Editorial-board information.
- Aims and scope.
- Publication frequency.
- Language or languages of publication.
- First issue or evidence that publication is imminent.

After issuance:

- Add the online ISSN to OJS.
- Display it consistently on the website and article PDFs.
- Add a print ISSN only if a separate print edition exists.

### Phase 5: Register DOIs through Crossref

Crossref is normally the appropriate DOI registration agency for journal
articles.

Options:

- Join Crossref directly.
- Join through an approved sponsoring organization.
- Check eligibility for the Crossref Global Equitable Membership program.

Before registration:

- Confirm that each article has a stable landing page.
- Define a consistent DOI suffix pattern.
- Configure the OJS DOI and Crossref plugins.
- Validate exported Crossref XML.

Do not display DOI strings as active links until the records have been
successfully registered.

Crossref guidance: <https://www.crossref.org/membership/>

### Phase 6: Deploy to production

Before changing public DNS permanently:

1. Back up the production database and files.
2. Push the cleaned local database.
3. Push approved application changes.
4. Preserve production database and SMTP credentials.
5. Generate a new production ALTCHA secret.
6. Verify production SSL.
7. Verify SMTP delivery.
8. Test registration and email validation.
9. Test login and password reset.
10. Test author submission.
11. Test reviewer assignment and review submission.
12. Test editorial decisions.
13. Test issue and article publication.
14. Test user management and removal.
15. Configure scheduled tasks.
16. Configure daily backups.
17. Put the production site behind Cloudflare.
18. Confirm that Apache records the real visitor IP securely.
19. Restrict direct origin access after Cloudflare is working.

Use the production hardening checklist in this file.

### Phase 7: Public launch verification

Test the website while signed out and from a separate device or network.

Verify:

- Root domain opens over trusted HTTPS.
- `www` redirects to the canonical hostname.
- HTTP redirects to HTTPS.
- Home page clearly identifies the journal and publisher.
- Editorial board is visible.
- Policies are visible.
- Author guidelines are complete.
- Fees or the absence of fees are clearly stated.
- Published issues and articles are accessible without registration.
- Registration displays ALTCHA.
- Validation emails arrive.
- Submission workflow works.
- Privacy Policy link works.
- Essential-cookie notice is accurate.
- No test pages, diagnostic scripts, database dumps, or backup files are public.

### Phase 8: Discovery and indexing

#### Immediately after publishing

- Ensure search engines are allowed to crawl public article pages.
- Verify article metadata in page headers.
- Register the site with Google Search Console and Bing Webmaster Tools.
- Confirm Google Scholar can access article landing pages and PDFs.
- Submit an XML sitemap if available.

#### After ISSN and DOI setup

- Register article DOIs through Crossref.
- Verify every DOI resolves to the correct article landing page.
- Correct metadata errors promptly.

#### DOAJ

Apply when the journal has an established and consistent open-access publishing
record and meets all DOAJ transparency requirements.

DOAJ expects, among other requirements:

- Active scholarly publishing.
- At least five research articles per year.
- Immediate reader access without registration.
- Transparent ownership and editorial information.
- Clear peer-review, copyright, licensing, and fee policies.

DOAJ application guide: <https://doaj.org/apply/guide/>

#### MEDLINE and PubMed

Treat MEDLINE/PubMed as a later objective. The PubMed XML Export Plugin does not
automatically index a journal.

Current MEDLINE pre-application requirements include:

- Properly registered ISSN.
- At least 12 months of publication.
- At least 40 peer-reviewed articles in final form.
- Electronic publication.
- Abstracts for peer-reviewed content.
- Suitable biomedical or life-sciences scope.
- Scientific-quality review.
- Technical XML approval.
- Acceptable long-term preservation.

MEDLINE requirements:
<https://www.nlm.nih.gov/medline/medline_how_to_include.html>

### Plugin priorities

#### Enable now

- Users XML Plugin for controlled user migration and backup.
- Native XML Plugin for OJS-native article and issue migration.
- DOAJ Export Plugin for preparation and validation.
- Crossref XML Export Plugin if Crossref DOI registration is planned.

#### Use only when eligible

- DataCite registration requires DataCite credentials and is generally more
  appropriate for datasets, software, and repository objects than journal
  articles.
- PubMed XML submission requires acceptance and deposit credentials from NLM.

Exporting XML does not itself register, publish, or index content.

### Immediate next actions

Complete these in order:

1. Remove the public diagnostic scripts `check.php` and `check_pw.php`.
2. Add the legal publisher identity and address.
3. Complete the editorial-board page.
4. Select and publish the copyright and open-access license.
5. Clearly state publication fees or that there are no fees.
6. Complete ethics, peer-review, correction, complaint, and data policies.
7. Remove unsupported CLOCKSS wording unless participation is confirmed.
8. Recruit and process credible articles for the first issue.
9. Apply for an ISSN.
10. Publish the first complete issue.
11. Join Crossref directly or through a sponsor and register article DOIs.
12. Deploy and test the hardened production website.
13. Begin discovery and indexing work after publication.
# Open Journal Systems

[![Build Status](https://github.com/pkp/ojs/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/ojs/actions/workflows/main.yml)

Open Journal Systems (OJS) is open source software developed by the [Public Knowledge Project](https://pkp.sfu.ca/) to manage scholarly journals. [Learn More](https://pkp.sfu.ca/software/ojs/)

## Usage

Read one of these guides to get started using OJS:

- Read the [Admin Guide](https://docs.pkp.sfu.ca/admin-guide/) to learn how to install and configure the application from an official release package. Use this guide to deploy to production.
- Read the [Getting Started](https://docs.pkp.sfu.ca/dev/documentation/en/getting-started) guide to learn how to install the application from this source repository. Use this guide for local development.

Visit our [Documentation Hub](https://docs.pkp.sfu.ca/) for user guides, tutorials, and technical documentation.

## Requirements

<details>
<summary>PHP 8.2 or later</summary>

The following list of platform requirements was generated by the Composer `check-platform-reqs` tool. The version numbers shown are examples and should not be interpreted as minimum requirements.

  ```
$ composer -d lib/pkp check-platform-reqs
Checking platform requirements for packages in the vendor dir
composer-plugin-api  2.6.0      success                                       
composer-runtime-api 2.2.2      success                                       
ext-bcmath           8.2.28     success                                       
ext-ctype            *          success provided by symfony/polyfill-ctype    
ext-curl             8.2.28     success                                       
ext-dom              20031129   success                                       
ext-fileinfo         8.2.28     success                                       
ext-filter           8.2.28     success                                       
ext-ftp              8.2.28     success                                       
ext-gd               8.2.28     success                                       
ext-hash             8.2.28     success                                       
ext-intl             8.2.28     success                                       
ext-json             8.2.28     success                                       
ext-libxml           8.2.28     success                                       
ext-mbstring         *          success provided by symfony/polyfill-mbstring 
ext-openssl          8.2.28     success                                       
ext-pcre             8.2.28     success                                       
ext-phar             8.2.28     success                                       
ext-session          8.2.28     success                                       
ext-simplexml        8.2.28     success                                       
ext-spl              8.2.28     success                                       
ext-tokenizer        8.2.28     success                                       
ext-xml              8.2.28     success                                       
ext-xmlwriter        8.2.28     success                                       
ext-zip              1.21.1     success                                       
ext-zlib             8.2.28     success                                       
lib-pcre             10.42      success                                       
php                  8.2.28     success
  ```

</details>

MySQL 5.7.22+, MariaDB 4.1+ or PostgreSQL 9.5+

Linux, or one of the following: BSD, Solaris, Mac OS X, Windows

## Bugs / Feature Requests

> ⚠️ If you have found a security risk or vulnerability, please read our [security policy](SECURITY.md).

All issues should be filed at the [pkp/pkp-lib](https://github.com/pkp/pkp-lib/issues/) repository. Feature requests can be made at our [Community Forum](https://forum.pkp.sfu.ca/). Learn more about how to [report a problem](https://docs.pkp.sfu.ca/dev/contributors/#report-a-problem).

## Community Code of Conduct

This repository is a PKP community space. All activities here are governed by [PKP's Code of Conduct](https://pkp.sfu.ca/code-of-conduct/). Please review the Code and help us create a welcoming environment for all participants.

## Contributions

Read the [Contributor's Guide](https://docs.pkp.sfu.ca/dev/contributors/) to learn how to make a pull request. This document describes our code formatting guidelines as well as information about how we organize stable branches and submodules.

## License

This software is released under the GNU General Public License. See the file `docs/COPYING` included with this distribution for the terms of this license.

Third parties are welcome to modify and redistribute OJS in entirety or parts according to the terms of this license. PKP also welcomes patches for improvements or bug fixes to the software.
# Security Policy

## Supported Versions

| Version | Supported                                             | Released      | End Of Life   | Support |
| ------- | ----------------------------------------------------- | ------------- | ------------- | :-----: |
| 3.5.x   | :hourglass:        Pre-release                        | 2025 (est)    | 2028 (est)    | LTS     |
| 3.4.x   | :heavy_check_mark: Active development                 | 2023          | 2025 (est)    |         |
| 3.3.x   | :heavy_check_mark: Active maintenance                 | 2020          | 2026 (est)    | LTS     |
| 3.2.x   | :x: Not supported                                     | 2020          | 2023          |         |
| 3.1.x   | :x: Not supported                                     | 2017          | 2022          |         |
| 3.0.x   | :x: Not supported                                     | 2016          | 2022          |         |
| 2.x     | :x: Not supported                                     | 2005          | 2021          |         |
| 1.x     | :x: Not supported                                     | 2002          | 2005 (approx) |         |

PKP usually supports current major release and the last major release.
Other releases receive bug fixes for about two years. However, that is not guaranteed.

[LTS versions](https://pkp.sfu.ca/2022/02/15/pkp-announces-long-term-support-lts-software-releases/) are an exception to this general rule, that don't include new features but receive security patches and bug fixes for 3-5 years.
At least 12 months before a LTS version reaches EOL, a new LTS version is designated, so that you have one year to perform an upgrade.


## Reporting a Vulnerability

To report a vulnerability, please contact PKP privately using: pkp-security@lists.sfu.ca

You can expect a response via email to acknowledge your report within 2 working days.

PKP will then work to verify the vulnerability and assess the risk. This is typically done within the first week of a report. Once these details are known, PKP will file a Github issue entry with limited details for tracking purposes. This initial report will not include enough information to fully disclose the vulnerability but will serve as a point of reference for development and fixes once they are available.

When a fix is available, PKP will contact its user community privately via mailing list with details of the fix, and leave a window of typically 2 weeks for community members to patch or upgrade before public disclosure.

PKP then discloses the vulnerability publicly by updating the Github issue entry with complete details and adding a notice about the vulnerability to the software download page (e.g. https://pkp.sfu.ca/software/ojs). At this point, a CVE and credit for the discovery may be added to the entry.

Depending on the severity of the issue PKP may back-port fixes to releases that are beyond the formal software end-of-life.

We aim to have a fix available within a week of notification.
# MDA Journal Required Actions and Audit Notes

Date: 2026-09-02 (updated 2026-09-03)

Scope:

- `/home/mdaj/resources/documentation/mdajournal-production-hardening.md`
- `/home/mdaj/resources/documentation/mdajournal-public-launch-roadmap.md`
- `/home/mdaj/public_html/PROJECT.md`
- `/home/mdaj/public_html/OJS_Publication_Readiness_Audit.md`
- The active `mdaDetox` theme
- OJS configuration, database settings, and the live site at
  `https://mdajournal.com/mda/`

## Audit summary

- OJS version: 3.5.0.5
- PHP CLI version: 8.3.6
- Journal path: `mda`
- Public journal URL: `https://mdajournal.com/mda/`
- Active journal theme: `mdaDetox`
- Published issues: 0
- Published articles: 0
- Active submissions: 1
- Online ISSN: not configured
- Publisher identity/address: not configured
- Publication license: not configured
- CLOCKSS and LOCKSS wording: present in journal settings

The site is publicly reachable, but it is not ready for formal launch or
indexing. The highest-priority gaps are production security configuration,
incomplete journal identity/policies, and stale documentation.

## Site structure audit

### Primary navigation

| Menu item | Destination | Notes |
| --- | --- | --- |
| Home | `https://mdajournal.com` | Redirects to `https://mdajournal.com/mda` |
| About | `https://mdajournal.com/mda/about` | Parent item |
| About -> About the Journal | `https://mdajournal.com/mda/about` | Renders `about.tpl` |
| About -> Editorial Team | `https://mdajournal.com/mda/editorial-team` | Static custom page |
| About -> Contact | `https://mdajournal.com/mda/about/contact` | Renders `contact.tpl` |
| Current | `https://mdajournal.com/mda/issue/current` | No published issue yet |
| Archives | `https://mdajournal.com/mda/issue/archive` | No published issues yet |
| For Authors | `https://mdajournal.com/mda/for-authors` | Parent/custom page |
| For Authors -> Author Guidelines | `https://mdajournal.com/mda/about/submissions#authorGuidelines` | Remote URL item |
| For Authors -> Submissions | `https://mdajournal.com/mda/about/submissions` | Standard OJS submissions page |
| For Authors -> Call for Papers | `https://mdajournal.com/mda/call-for-papers` | Static custom page |
| For Authors -> Article Processing Charges | `https://mdajournal.com/mda/charges` | Static custom page |
| Policies | `https://mdajournal.com/mda/policies` | Parent/custom page |
| Policies -> Peer Review Process | `https://mdajournal.com/mda/review-process` | Static custom page |
| Policies -> Plagiarism Policy | `https://mdajournal.com/mda/plagiarism-policy` | Static custom page |
| Policies -> Open Access Policy | `https://mdajournal.com/mda/open-access` | Static custom page |

Other public destinations:

- `https://mdajournal.com/mda/about/privacy`
- `https://mdajournal.com/mda/announcement`
- `https://mdajournal.com/mda/search`
- `https://mdajournal.com/mda/login`

### Theme template overrides

The `mdaDetox` theme currently contains 16 `.tpl` files under
`plugins/themes/mdaDetox/templates`. They include:

- header and footer
- homepage
- about
- contact
- announcements
- announcement detail
- current issue and issue archive
- privacy
- submissions
- information
- navigation menu/custom pages
- login and lost-password pages
- information sidebar block

This is broader than the current documentation states.

## Documentation audit

### `mdajournal-production-hardening.md`

The checklist contains several claims that do not match the current local
configuration:

| Documented state | Actual state found |
| --- | --- |
| `force_ssl = On` applied | `force_ssl = Off`; corrected to `On` 2026-09-03 |
| `user_validation_period = 2` applied | `user_validation_period = 28`; corrected to `2` 2026-09-03 |
| ALTCHA work factor `100000` applied | `altcha_encrypt_number = 10000`; corrected to `100000` 2026-09-03 |
| Diagnostic scripts were removed | `check.php` and `check_pw.php` were present; removed 2026-09-03 |

Other current audit findings:

- `delete_spam.sh` was also present in the public web root; removed 2026-09-03.
- `www.mdajournal.com` currently returns HTTP 400 rather than redirecting to
  the canonical `https://mdajournal.com/`.
- The expected security headers are not present on the public response.
- `config.inc.php` is currently world-readable (`0644`) rather than `0640`.
- Cloudflare proxy headers were not observed, so Cloudflare/production
  configuration still needs to be completed.

### `mdajournal-public-launch-roadmap.md`

The roadmap is broadly correct, but should be updated with:

- The confirmed contact-page audit: only `Editorial Manager` and `MDA Support`
  emails are shown. Mailing address, principal-contact title, affiliation,
  principal phone, and support phone are missing.
- The fact that both CLOCKSS and LOCKSS license strings are still present in
  `journal_settings` and must be removed unless membership is confirmed.
- The current primary navigation and static-page inventory.
- The known internal-link cleanup work.
- The site-level contact defaults still using `Open Journal Systems` and
  `admin@mdajournal.com`.

### `PROJECT.md`

`PROJECT.md` is the consolidated guide but is now stale in these areas:

- It lists only ten deliberate template overrides. The actual theme contains
  16 `.tpl` files, including contact, login, lost-password, announcement,
  information, and submissions pages.
- Its theme-structure section omits `pages/contact.less` and
  `pages/login.less`.
- Its production-hardening section repeats the stale claims about
  `force_ssl = On`, `user_validation_period = 2`, and ALTCHA work factor
  `100000`.
- Its current-verified-state section should be refreshed after the required
  changes are applied.

### `plugins/themes/mdaDetox/templates/README.md`

- It states eleven deliberate overrides.
- It should either be updated to match the actual override set or be replaced
  with a pointer to `PROJECT.md` once `PROJECT.md` is corrected.

## Reconciliation with the publication-readiness audit

The 2026-09-03 report `OJS_Publication_Readiness_Audit.md` was compared with
this action list and the live server. Accepted findings are reflected in the
required actions below. The following report claims are superseded by
verification:

- The listed custom navigation pages are live and return HTTP 200; they are
  not 404 errors. Keep the earlier navigation inventory in this file.
- The homepage `<title>` currently renders "Multi-Disciplinary Aviation
  Journal"; the report's "empty title" finding is stale on this server.
- CLOCKSS/LOCKSS wording is present but should not be treated as an asset;
  remove it unless membership is confirmed.
- reCAPTCHA is disabled (`recaptcha = Off`) with placeholder keys left in
  `config.inc.php`, rather than merely "enabled but inactive".

## Required actions

### Root access required

The following actions must be performed with root/sudo privileges on the server:

- [x] Set `config.inc.php` to `0640` with the correct owner and web-server group.
- [x] Review and correct file ownership on writable runtime directories.
- [x] Configure HTTP to HTTPS redirects.
- [x] Configure `www.mdajournal.com` to redirect to `https://mdajournal.com/`.
- [x] Install a valid certificate for both root and `www`.
- [ ] Add the security headers listed in the production-hardening document after
  testing OJS workflows.
  - [x] Installed and verified `X-Content-Type-Options`, `Referrer-Policy`, and
    `Permissions-Policy`.
  - [ ] Complete OJS workflow testing before treating this action as complete.
- [ ] Enable HSTS only after HTTPS is confirmed for all required hostnames.
- [ ] Configure `mod_remoteip` and then set `trust_x_forwarded_for = On`.
- [ ] Restrict direct origin access to Cloudflare and administrator networks.

### 1. Secure the current web root

- [x] Remove `check.php`, `check_pw.php`, and `delete_spam.sh` from
  `/home/mdaj/public_html`.
- Confirm no `.sql`, `.tar.gz`, `.zip`, backup, or log files are publicly
  accessible.
- Keep private backups and scripts outside the web root.
- [x] Set `config.inc.php` to `0640` with the correct owner and web-server group.
- [x] Review file ownership on writable runtime directories.

### 2. Correct OJS security configuration

- [x] Set `force_ssl = On`.
- [x] Set `force_login_ssl = On`.
- [x] Set `user_validation_period = 2`.
- [x] Set `altcha_encrypt_number = 100000`.
- [x] Generate a new production ALTCHA HMAC secret.
- [x] Replace the default OJS `salt` and populate `api_key_secret`.
- [x] Upgrade password hashing from `encryption = sha1` to `encryption = bcrypt`
  (OJS migrates existing users on their next login).
- Remove or replace the placeholder reCAPTCHA keys; keep `recaptcha = Off`.
- Rotate the SMTP password with the email provider and update only the
  production configuration with the new value.
- Reset privileged account passwords and store them in a password manager.
- Do not copy secrets from the testing/local environment.

### 3. Finish production and Cloudflare configuration

- [x] Configure HTTP to HTTPS redirects.
- [x] Configure `www.mdajournal.com` to redirect to `https://mdajournal.com/`.
- [x] Install a valid certificate for both root and `www`.
- [ ] Add the security headers listed in the production-hardening document after
  testing OJS workflows.
  - [x] Installed and verified `X-Content-Type-Options`, `Referrer-Policy`, and
    `Permissions-Policy`.
  - [ ] Complete OJS workflow testing before treating this action as complete.
- Enable HSTS only after HTTPS is confirmed for all required hostnames.
- Reconcile the `.htaccess` cPanel `ea-php82` handler with the detected PHP
  8.3.6 runtime (update to the correct handler or remove it if it is not
  needed).
- Determine whether the PHP `soap` extension is required by any enabled
  integration, and install it only if needed.
- Put the site behind Cloudflare, configure SSL/TLS **Full (strict)**, WAF,
  bot protection, and conservative rate limiting.
- Configure `mod_remoteip` and then set `trust_x_forwarded_for = On`.
- Restrict direct origin access to Cloudflare and administrator networks.

### 4. Complete journal identity and policies

- Add the legal publisher name, country, and physical address.
- Add the official journal email and a named primary editorial contact.
- Add publication frequency.
- Complete aims and scope.
- Apply for and add the online ISSN once issued.
- Select and publish a clear copyright and open-access license, preferably
  CC BY 4.0 if appropriate; set `licenseURL` and `copyrightHolderType`
  explicitly and update the page footer copyright year from 2025 to 2026.
- Publish clear author, peer-review, ethics, correction, complaint, data, and
  privacy policies.
- Clearly state APC or no-fee policy.
- Publish a complete editorial-board page with role, affiliation, country,
  and ORCID/profile links where available, assign members to the masthead
  editorial-board group, and only publish with member permission.
- Remove CLOCKSS and LOCKSS wording unless membership is confirmed.

### 5. Fix the contact page data

In OJS `Settings -> Contact`, add:

- Mailing address.
- Principal-contact title.
- Principal-contact affiliation.
- Principal-contact phone number.
- Support phone number, if appropriate.

Also update the site-level contact settings from the OJS defaults.

### 6. Normalize internal links

Review and update content so internal links use the canonical HTTPS/RESTful
form:

`https://mdajournal.com/mda/...`

Known items needing attention:

- `additionalHomeContent` links to
  `https://mdajournal.com/index.php/mda/about`.
- `authorInformation` contains a broken `/mda/author-guidelines` link and
  several `http://mdajournal.com/...` links.
- `readerInformation` contains `http://mdajournal.com/...` links.
- `submissionChecklist` links to
  `https://mdajournal.com/index.php/mda/about/submissions`.
- The Call for Papers static page links to
  `http://mdajournal.com/index.php/mda/about/submissions` and
  `http://mdajournal.com/index.php/mda`.
- The Open Access Policy static page links to
  `https://mdajournal.com/index.php/mda/issue/archive`.

### 7. Prepare the first publication

- Recruit and process credible peer-reviewed articles.
- Recruit and validate a sufficient peer-reviewer pool; audit inactive or
  never-logged-in editorial/author accounts.
- Create and publish the first complete issue.
- Verify article metadata, final PDFs, references, ORCIDs, funding,
  conflicts, and licensing.
- Obtain an ISSN.
- Configure Crossref and register DOIs only after stable article landing
  pages exist.
- Begin discovery/indexing work after publication.

### 8. Update the documentation files

Update these files to match the verified state and this action list:

- `/home/mdaj/resources/documentation/mdajournal-production-hardening.md`
- `/home/mdaj/resources/documentation/mdajournal-public-launch-roadmap.md`
- `/home/mdaj/public_html/PROJECT.md`
- `plugins/themes/mdaDetox/templates/README.md`

Specific documentation changes:

- Remove or qualify all already-completed claims that are not yet true.
- Record the correct `force_ssl`, validation-period, and ALTCHA values.
- Record the actual web-root cleanup required.
- Record the correct template-override list and theme structure.
- Add the contact-page audit findings.
- Add the current navigation structure and static-page inventory.
- Add the internal-link cleanup items.
- Keep all production secrets out of documentation.
- Reconcile `OJS_Publication_Readiness_Audit.md` with this action list after
  changes are applied.

### 9a. Discoverability, analytics, and delivery readiness

New actions from the 2026-09-03 publication-readiness audit. Complete these
before the final deployment verification in section 9.

- Configure a Google Analytics (GA4) measurement ID in the plugin settings or
  disable the plugin until analytics is ready.
- Create and verify a sitemap, and extend `robots.txt` to disallow internal
  system paths (`/lib/`, `/templates/`, `/dbscripts/`, etc.).
- Verify SPF, DKIM, and DMARC DNS records for PurelyMail so journal email is
  not marked as spam.

### 9. Run deployment verification

After changes, verify:

- [x] Root and `www` DNS and HTTPS behavior.
- [x] HTTP to HTTPS redirects.
- [x] No diagnostic scripts are publicly accessible.
- ALTCHA appears on registration, login, and password reset.
- Validation emails arrive.
- Registration, login, password reset, submission, reviewer assignment,
  editorial decisions, publication, and user removal work.
- Cloudflare/Apache real-visitor IP handling is correct.
- Backups complete and a restore test succeeds.
- Documentation matches the deployed state.

### 10. Author intake: contact-first submission flow (decision 2026-09-03)

Decision: MDA uses the contact-first model, not JAMCS-style email-attachment
submission and not public author self-registration. Self-registration stays
disabled (`disableUserReg = 1`). A prospective author emails the editorial
contact, editorial staff create the author account, and the author then logs
in and submits through the OJS submission wizard on this journal.

Why not JAMCS-style email intake:

- JAMCS effectively takes manuscripts as email attachments because its online
  system is under maintenance; editorial staff then load submissions off-site.
- MDA's review workflow (desk decisions, double-blind review, revision
  tracking) lives in OJS, so keeping the author inside OJS after a single
  contact step is the cleaner fit.

Task: change the logged-out branch of the submissions page so it explains the
contact-first flow instead of the stock "login or register" message, which is
misleading while registration is disabled.

Target file:
`plugins/themes/mdaDetox/templates/frontend/pages/submissions.tpl`

Logged-out branch today (approximately lines 42-47):

- Renders `about.onlineSubmissions.registrationRequired` with a "Log in"
  link and a "Register" link.
- The Register link points at `{url page="user" op="register"}`, which is
  useless while self-registration is disabled.

Planned behavior:

- Logged-in users keep the current "make a submission / view submissions"
  actions, exactly as today.
- Logged-out users see contact-first copy instead: submit a short proposal by
  email to the editorial manager; the account is created for them; then they
  log in and complete the online submission wizard.
- The contact address must be pulled from the journal's contact settings via
  `$currentContext->getData('contactEmail')` (same pattern already used in the
  mdaDetox footer) so it is not hard-coded in the template.
- The login link stays available for authors who already have an account.

Open items for the journal owner (user decision before implementation):

- Final wording of the logged-out message (exact copy to be approved).
- Whether the "Register" link should be removed entirely or kept out of view.
- Whether the contact-first notice should also appear on the "Call for
  Papers" and other submission-related static pages.
