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
