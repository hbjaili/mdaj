# MDA Journal — Project Documentation

**Last full audit and documentation update:** 2026-09-14

This is the single authoritative guide for the Multi-Disciplinary Aviation
Journal (MDAJ) Open Journal Systems installation at
`https://mdajournal.com/mdaj/`, its custom `mdaDetox` theme, and its production
configuration.

Everything below was verified on 2026-09-14 by direct inspection of the live
HTTP responses, `config.inc.php`, the OJS database (`mdaj_ojsdb`), and the
filesystem. Items that could not be verified are listed as open work rather than
stated as fact.

> **Open work is tracked in `actions.md`.** This document records verified state
> and configuration only; keep the two files in step when something changes.

## 1. How this document is maintained

This file replaces the earlier set of overlapping, partly obsolete documents:
`OJS_Publication_Readiness_Audit.md`, `MD_Files/PROJECT.md`, `MD_Files/README.md`,
`MD_Files/SECURITY.md`, `MD_Files/actions.md`,
`mdajournal-production-hardening.md`, and `mdajournal-public-launch-roadmap.md`.
Those files were deleted in commit `95a53ed3`; their still-relevant content is
folded in here, and completed actions are not reproduced.

Rules for this file:

- Record verified state, not intentions. Date every state snapshot.
- Keep open work in `actions.md`, not here.
- Never record passwords, API keys, salts, or SMTP credentials here.
- Update this file whenever journal settings, policies, theme files, or server
  configuration change.

`project.md` is tracked in the repository. The root `.gitignore` excludes local
tooling and private data (`bin/`, `resources/`, `files/`, shell and tool
dotfiles, OJS secrets, runtime caches and generated output) while leaving
`project.md`, `public_html/`, `www`, `.github/` and `.gitignore` committable.

Small related files point here:

- `/home/mdaj/actions.md` (working task list; not part of the state record)
- `/home/mdaj/resources/theme_info.md`
- `/home/mdaj/public_html/plugins/themes/mdaDetox/README.md`
- `/home/mdaj/public_html/plugins/themes/mdaDetox/templates/README.md`

OJS's own `README.md` and other upstream files are not project documentation.

## 2. Current verified state

| Area | State |
| --- | --- |
| OJS version | 3.5.0.5 (installed 2026-08-23; current in `versions`) |
| PHP | 8.3.6 (NTS); `soap` extension missing, all other OJS requirements present |
| Web server | Apache 2.4.58 (Ubuntu), runs as `nobody:nogroup` |
| Database | MySQL/MariaDB `mdaj_ojsdb`, user `mdaj_usr`, local socket |
| Journals | 1 (`journal_id=1`), enabled, primary locale `en` |
| Journal path | `mdaj` — public URL `https://mdajournal.com/mdaj/` |
| Root domain | `https://mdajournal.com/` returns 302 to `/mdaj` |
| Active theme | `mdaDetox` 1.0.0.0 (parent `default`), enabled for journal 1 |
| Security config | `force_ssl`, `force_login_ssl`, `encryption = bcrypt`, rotated `salt`/`api_key_secret`, ALTCHA all set |
| Email | SMTP via PurelyMail; SPF, DKIM and DMARC verified in DNS |
| Users | 8 accounts, none disabled |
| Submissions | 0 — both manuscripts were deleted on 2026-09-14 (see §6) |
| Published content | 0 issues, 0 published articles, 0 DOI records |
| ISSN | Online 3152-8961 (displayed), print 3122-3206 (configured, not displayed) |
| Licence | CC BY 4.0 (`licenseUrl`), copyright holder type `author` |
| Queue | Job/task runners active; `jobs` and `failed_jobs` both 0 |
| Backups | One-off full dump taken 2026-09-14; no routine and no restore test yet |

## 3. Locations and access

| Purpose | Path |
| --- | --- |
| OJS web root | `/home/mdaj/public_html` |
| Convenience symlink | `/home/mdaj/www` → `/home/mdaj/public_html` |
| Private upload files | `/home/mdaj/files` (outside the web root) |
| Public journal assets | `/home/mdaj/public_html/public` |
| Runtime cache | `/home/mdaj/public_html/cache` |
| Queue and task logs | `/home/mdaj/files/scheduledTaskLogs` |
| Active theme | `/home/mdaj/public_html/plugins/themes/mdaDetox` |
| Detox design reference | `/home/mdaj/resources/Detox` |
| Project resource root | `/home/mdaj/resources` |

Database access (values come from `config.inc.php`):

```bash
cd /home/mdaj/public_html
MYSQL_PWD="$(php -r '$c=parse_ini_file("config.inc.php",true); echo $c["database"]["password"];')" \
  mysql --protocol=socket -u mdaj_usr mdaj_ojsdb -e "SELECT journal_id, path, enabled FROM journals"
```

## 4. Public site map (verified 2026-09-14)

Primary navigation; every item below returns HTTP 200:

| Menu | URL |
| --- | --- |
| Home | `https://mdajournal.com` (redirects to `/mdaj`) |
| About | `/mdaj/about` |
| About → About the Journal | `/mdaj/about` |
| About → Editorial Team | `/mdaj/editorial-team` |
| About → Contact | `/mdaj/about/contact` |
| Current | `/mdaj/issue/current` (no published issue yet) |
| Archives | `/mdaj/issue/archive` (no published issues yet) |
| For Authors | `/mdaj/for-authors` |
| For Authors → Author Guidelines | `/mdaj/about/submissions#authorGuidelines` |
| For Authors → Submissions | `/mdaj/about/submissions` |
| For Authors → Call for Papers | `/mdaj/call-for-papers` |
| For Authors → Article Processing Charges | `/mdaj/charges` |
| Policies | `/mdaj/policies` |
| Policies → Peer Review Process | `/mdaj/review-process` |
| Policies → Plagiarism Policy | `/mdaj/plagiarism-policy` |
| Policies → Open Access Policy | `/mdaj/open-access` |

Other public destinations: `/mdaj/about/privacy`, `/mdaj/about/submissions`,
`/mdaj/announcement`, `/mdaj/announcement/view/{6,7,8,10,11}`, `/mdaj/search`,
`/mdaj/login`, `/mdaj/user/register` (renders "not accepting user
registrations"), `/mdaj/oai`, and the WebFeed RSS/Atom gateway.

Confirmed absent: `/mdaj/sitemap.xml`, `/mdaj/author-guidelines`,
`/mdaj/about/editorialTeam`, and `/mdaj/announcements` (the list lives at
`/mdaj/announcement`). `/mdaj/does-not-exist` returns a themed 404.

The custom team, policy and information pages are OJS navigation-menu items of
type `NMI_TYPE_CUSTOM`, created through the Static Pages plugin. In OJS 3.5 the
`static_pages` table is empty by design and page bodies live in
`navigation_menu_item_settings`.

## 5. Journal identity and settings

| Setting | Value |
| --- | --- |
| Journal name | Multi-Disciplinary Aviation Journal |
| Acronym / abbreviation | MDAJ / Multidiscip. Aviat. J. |
| Public path | `mdaj` |
| Online ISSN | 3152-8961 (shown in the theme header bar) |
| Print ISSN | 3122-3206 (configured, displayed nowhere) |
| Publisher institution | Hasan Ahmed Omar Bjaili Est. |
| Publisher address / country | not configured |
| Contact name / email | Editorial Manager / em@mdajournal.com |
| Support name / email | MDAJ Support / support@mdajournal.com |
| Site-level contact | "Open Journal Systems" / admin@mdajournal.com (installation default name) |
| Journal logo | restored 2026-09-14 (`mdaj.svg`, rendered in the header) |
| Journal thumbnail | added 2026-09-14 (the red SVG mark, `journalThumbnail_en`) |
| Favicon | restored 2026-09-14 (`favicon_en.png`, the red firebrick mark) |
| Licence | CC BY 4.0 (`https://creativecommons.org/licenses/by/4.0`) |
| Copyright holder type | author |
| Copyright notice | Authors retain copyright; articles published under CC BY 4.0 |
| Page footer text | stored as "Copyright © MDA Journal 2026-2027. All rights reserved."; the theme replaces any year or year range with the current year, so it renders "Copyright © MDA Journal 2026. All rights reserved." |
| Sections | 1 Research Articles (ART), 2 Review Articles (REV), 3 Short Communication (COM), 4 Case Report (CSR), all with written section policies |
| Masthead user groups | `[3, 5, 19]` (journal editor, section editor, editorial board member) |
| Submissions | open |
| Self-registration | disabled (`disableUserReg = 1`); contact-first author intake is the agreed model |
| Review model | double-blind (`defaultReviewMode = 2`), 4 weeks to review, 4 weeks to respond |
| Author guidelines, submission checklist, privacy statement, open access policy | configured |
| LOCKSS statement | configured in settings but not rendered on any public page |
| CLOCKSS | not configured |
| OAI-PMH | enabled; repository identifier `ojs.mdajournal.com` |
| DOIs | enabled for publications, suffix type `default`, created at copyedit; no prefix and no registration agency |
| Fees | no OJS fee or payment configuration; the Charges page states an APC of USD 100 with a waiver policy |

The About page renders only the journal's `about` text, which matches OJS 3.5
core behaviour; publisher, ISSN and archiving details are not surfaced there.

Three journal image settings were cleared on 2026-09-14 at the journal manager's
request: `pageHeaderLogoImage`, `journalThumbnail` and `favicon`. The uploaded
files were moved out of the web root to
`/home/mdaj/backups/branding-20260914/` (a folder name, not a classification),
with the removed settings rows in `journal_settings-branding.sql`, and a stale
`styleSheet.css` — a leftover from the retired healthSciences theme that was no
longer served — went with them. Theme artwork (homepage hero, patterns, About
image, licence badges) and the design sources under
`/home/mdaj/resources/assets` were left untouched. No journal identity was
affected: the name, ISSN, policies, theme colour (`#6377EE`) and layout are
unchanged.

Removing the journal logo also removed the header's brand mark, leaving the
theme's text fallback ("Multi-Disciplinary Aviation Journal") in the top bar, so
the logo was restored the same day: `pageHeaderLogoImage` points at the
journal's `mdaj.svg`, the file is back in
`public/journals/1/pageHeaderLogoImage_en`, and the header renders
`has_site_logo` with the logo image. The stored filename metadata was corrected
on 2026-09-14 — it had recorded `mda.svg`, which is an older, different file
that is not the journal logo (the served image is byte-identical to
`resources/assets/mdaj.svg`) — and its alt text now reads
"Multi-Disciplinary Aviation Journal (MDAJ) logo". The favicon
(`favicon_en.png` and `favicon_en.svg`) was restored the same day, and the
thumbnail was added on 2026-09-14 from the same red SVG mark. The older
unreferenced `pageHeaderLogoImage_en.png` stays in the backup folder. All three
images are now in place.

Service and integration state, verified 2026-09-14: the online ISSN is issued
(3152-8961); the Crossref plugin is enabled but has no credentials and no DOI
prefix; the Google Scholar plugin is enabled; ORCID is enabled at the journal
level with Public API Production credentials (site-level settings remain
empty); the DOAJ export plugin is registered in
`versions` with no configuration; no preservation plugin (PKP Preservation
Network, LOCKSS or CLOCKSS) is installed; and this distribution ships no
similarity-check/iThenticate plugin. Costs, sequencing and the remaining setup
work for these services are tracked in `actions.md` (actions 4, 6, 7, 16, 35
and 36).

Search-engine state, verified 2026-09-14: the homepage meta description comes
from the journal's `searchDescription` field alone — `customHeaders` was emptied
to remove a duplicate — while keywords/author/robots tags were dropped with it
(robots defaults to index, follow). The theme plugin registers a
self-referencing `<link rel="canonical">` built through the OJS router, so
`/index.php/mdaj/...` requests canonicalise to the clean URLs, and login,
registration and search pages carry `noindex, follow` instead. `robots.txt`
allows crawling and blocks only OJS system paths and the management backend.
The bare domain root 301-redirects to `/mdaj/`, and `sitemap.xml` (18 URLs today,
extended automatically with published issues and articles) is regenerated daily
at 03:15 by `scripts/generate-sitemap.php`, scheduled in the site owner's
crontab. Registering with Google Search Console and Bing, and confirming Google
Scholar reads a published article, remain open in action 6 in `actions.md`.

## 6. Content, users and editorial state

Users (8, none disabled):

| Username | Role | Last login |
| --- | --- | --- |
| ojsadmin | Site administrator + journal manager | 2026-09-13 |
| em@mdajournal.com | Journal editor | 2025-10-10 |
| mbourchak | Section editor | 2025-12-13 |
| hbjaili | Section editor | 2026-09-06 |
| Hasan (hbjaili@gmail.com) | Author | 2026-09-06 |
| ATTAR | Reviewer | 2025-12-19 |
| batikh | Reviewer | 2025-12-18 |
| deleted@mdajournal.com ("Deleted User") | Reader; disabled spam-merge sink | never logged in |

No user belongs to the Editorial Board Member group (19), no reviewer interests
are recorded, and only two reviewers have ever logged in. The
`deleted@mdajournal.com` account is retained deliberately as the merge target
when clearing spam users, because OJS has no user-deletion feature; it was
renamed from `Oozypal@gmail.com` and disabled on 2026-09-14. Note: OJS cannot
open a disabled account in the admin user editor — `Repo::user()->get()`
excludes disabled users, so the edit screen returns "The requested resource was
not found". To edit this account through the UI later, temporarily re-enable it,
make the change, then disable it again.

Submissions: none. The journal currently holds no manuscripts. On 2026-09-14 the
journal manager (`ojsadmin`) deleted both submissions that were in the system:

| ID | Title | Author | Submitted | Deleted |
| --- | --- | --- | --- | --- |
| 2 | The Low-Cost Carrier Ascendancy in India: An Empirical Evaluation | Krishna Lok Singh | 2026-06-12 | 2026-09-14 |
| 3 | Boolean Reliability Models for Representative Aircraft Autoland Architectures | Hasan Ahmed | 2026-09-06 | 2026-09-14 |

The deletion is complete and clean: `submissions`, `publications`, `authors`,
`files`, `submission_files`, `review_rounds`, `edit_decisions` and the search
tables hold no leftover rows, the manuscript files are gone from
`/home/mdaj/files/journals`, and the public site is unaffected (home, current
issue and issue archive still return HTTP 200; OAI-PMH reports no records).
Neither submission had reached review, so no review or decision history was
lost.

The deleted submissions had produced four logged emails (log rows 9–12): the
editor-assignment notice and the submission acknowledgement for each one, sent
2026-06-12 and 2026-09-06. Those rows were removed with the submissions, which is
why `email_log` is now empty. The corresponding author of submission 2 therefore
did receive the automatic acknowledgement on 2026-06-12 but no outcome
afterwards.

That gap was closed on 2026-09-14: a notice was sent from
`MDA Journal Editorial Office <em@mdajournal.com>` explaining that the manuscript
was not reviewed, that the submission had been withdrawn from the editorial
system, and apologising for the delay. The sent copy is kept at
`/home/mdaj/backups/author-notice-20260914/author-notice-krishna-lok-singh.eml`
(OJS cannot log it because the submission no longer exists). Action 33 in
`actions.md` is closed.

A full database dump taken before the rows were removed is kept at
`/home/mdaj/backups/mdaj_ojsdb-20260914-pre-workflow.sql` (28 MB, mode 600,
outside the web root). It preserves the deleted submissions' metadata; the
manuscript files themselves are not recoverable.

Announcements — 5 active, none with an expiry date, all posted 2026-09-10/11:

- Call for Papers: Inaugural Issue (January 2027)
- Welcome to MDAJ
- Join Our Reviewer Network
- Exploring the Future of Aviation: Our Multi-Disciplinary Focus
- Commitment to Rapid and Rigorous Peer Review

Email: `email_log` is empty; 6 journal-specific email template overrides exist.

## 7. Theme: mdaDetox

- Plugin path: `plugins/themes/mdaDetox`
- Class `MdaDetoxThemePlugin`, release 1.0.0.0 (2026-08-28), parent Default Theme
- `themePluginPath = mdaDetox`; `mdadetoxthemeplugin` and `defaultthemeplugin`
  both enabled for journal 1
- Stored plugin options: primary colour `#6377EE` and a CTA text string
- Contents: 17 template overrides, 17 LESS files, 10 images, `js/main.js`,
  English locale strings

### Template overrides (17)

Each overrides an existing core template under `lib/pkp/templates` or the
bundled Information block:

- `frontend/components/header.tpl`, `frontend/components/footer.tpl`
- `frontend/pages/indexJournal.tpl`, `about.tpl`, `announcements.tpl`,
  `announcement.tpl`, `contact.tpl`, `privacy.tpl`, `information.tpl`,
  `issue.tpl`, `issueArchive.tpl`, `message.tpl`,
  `navigationMenuItemViewContent.tpl`, `submissions.tpl`, `userLogin.tpl`,
  `userLostPassword.tpl`
- `plugins/blocks/information/templates/block.tpl`

Core `article.tpl` and `search.tpl` are not overridden, so article detail and
search results still use core markup inside the themed header and footer.

### Style layout

`styles/index.less` imports `variables.less`, `base.less`,
`components/{header,cta,footer,scroll-top}.less`, and
`pages/{home,about,contact,editorial-team,privacy,login,announcements,custom-page,issue,message}.less`.

### Implemented features

- Native OJS 3.5 theme plugin with Default Theme inheritance and a colour option
- SEO head tags registered from the plugin's `TemplateManager::display` hook: a
  router-built canonical link, plus `noindex` on login, registration and search
- Detox-style white responsive header with OJS menus, search, user actions and a
  compact sticky state that matches the Detox reference behaviour
- Full-width illustrated homepage: animated heading, CMS-managed hero text from
  Additional Content, feature cards, announcements and current-issue output
- Themed About, Contact, Editorial Team, Privacy, Announcements (list and
  detail), Current Issue, Issue Archive, Information and custom policy pages
- Footer with brand, quick links, policy/team links including Privacy Statement,
  contact block, open-access and CC BY badges, and a copyright year that always
  shows the current year (any stored year or year range is collapsed to it).
  The duplicate bottom About/Contact links were removed; Privacy Statement now
  lives only in the Policies &amp; Team column.
- Contact-first copy on the logged-out submissions page
- Keyboard focus, skip links and reduced-motion support

### Detox header reference behaviour

The reference template uses a large `.main-header` plus a compact
`.sticky-header`. At 110px of scroll the OJS theme switches to a compact fixed
white bar with a shadow, gives the current top-level item the primary blue
background, and fades down over 500ms from 20px above. Apply the compact
geometry before revealing the bar; animating the large header's height at the
same time produces a visible jump, and a full `translateY(-100%)` entrance looks
abrupt. OJS does not emit a selected-item class, so `js/main.js` compares
normalised navigation URLs, adds `mda_detox_nav_item--current`, and sets
`aria-current="page"`.

### CMS content mapping

The homepage hero paragraph comes from **Settings → Website → Appearance →
Additional Content**, falling back to the journal description. Hero heading
words are locale strings in `locale/en/locale.po`. Journal titles, articles,
issues, navigation and user controls must always come from OJS.

### Development rules

1. Check Git status before editing anything in `public_html`.
2. Determine whether a target path is part of the tracked OJS distribution.
3. Preserve unrelated changes; treat ambiguous files as OJS files.
4. Extend the Default Theme instead of forking OJS core.
5. Prefer OJS data, hooks, inherited markup and CSS over copied templates.
6. Keep every override as small as practical and re-review all overrides on
   every OJS upgrade.
7. Put shared tokens in `variables.less`, reusable rules in `components/`, and
   route-specific rules in `pages/`; import new files from `index.less`.
8. Use progressive enhancement for JavaScript and keep focus and
   reduced-motion behaviour intact.
9. Copy only licensed assets and avoid new third-party frontend dependencies.

The Detox source's Bootstrap, jQuery plugins, icon fonts, animation libraries
and demo content are not runtime dependencies and must not be copied wholesale.

### Validation commands

```bash
cd /home/mdaj/public_html
php -l plugins/themes/mdaDetox/MdaDetoxThemePlugin.php
php -l plugins/themes/mdaDetox/index.php
php -r '$x = simplexml_load_file("plugins/themes/mdaDetox/version.xml"); exit($x === false ? 1 : 0);'
node --check plugins/themes/mdaDetox/js/main.js
php -r 'require "lib/pkp/lib/vendor/autoload.php"; $less = new Less_Parser(["compress" => true]); $less->parse("@mda-detox-primary:#6377EE;"); $less->parseFile("plugins/themes/mdaDetox/styles/index.less"); $less->parse("@baseUrl:\"https://example.test\";"); echo strlen($less->getCSS()), PHP_EOL;'
```

After a deployed change: clear the OJS template and data caches, re-check the
affected public URL over HTTPS, walk the public pages (home, About, Editorial
Team, Announcements list and detail, policy pages, Issue Archive, Search, Login,
Submissions), then re-test the authenticated flows (submission, review,
decision) with a test account at mobile, tablet and desktop widths.

### Activation, disabling and removal

Activate by selecting **MDA Detox Theme** under **Settings → Website →
Appearance → Theme**, then clear template and data caches. Disable by selecting
Default Theme, disabling the plugin, and clearing caches. Deleting
`plugins/themes/mdaDetox` is only appropriate for permanent removal with a
recoverable copy in hand; it never affects journal data.

## 8. Security and infrastructure

### Applied in `config.inc.php`

```ini
installed = On
base_url = "https://mdajournal.com"
restful_urls = On
allowed_hosts = ["mdajournal.com"]
force_ssl = On
force_login_ssl = On
encryption = bcrypt
session_check_ip = On
session_samesite = Lax
require_validation = On
user_validation_period = 2
altcha = on
altcha_on_register = on
altcha_on_login = on
altcha_on_lost_password = on
altcha_encrypt_number = 100000
trust_x_forwarded_for = Off   ; correct while Apache is not behind a proxy
```

The site `salt`, `api_key_secret`, `app_key` and ALTCHA HMAC key are unique
values. Debug output, stack traces and sandbox mode are off. All stored password
hashes are bcrypt. `web_cache` uses the OJS default (`Off`) and `job_runner` the
default (`On`).

### Server facts

- `/etc/apache2/sites-enabled/mdajournal.com.conf`: port 80 redirects to
  `https://mdajournal.com/`; port 443 serves `/home/mdaj/public_html` with
  `Options -Indexes`, `AllowOverride All`, a Let's Encrypt certificate, and the
  response headers `X-Content-Type-Options: nosniff`,
  `Referrer-Policy: strict-origin-when-cross-origin`, and
  `Permissions-Policy: camera=(), microphone=(), geolocation=()`.
- `.htaccess` contains only the OJS clean-URL rewrites; the old cPanel
  `ea-php82` handler reference is gone.
- The site is served directly by the origin (A record `192.236.161.63`); no
  proxy or CDN headers are present, so Cloudflare remains future work.
- `/cache/` and `/dbscripts/` return 403, `/files/` returns 404 (it lives
  outside the web root), and `/config.inc.php` executes rather than leaking
  source.

### Ownership and permissions

The web server runs as `nobody:nogroup`, not `www-data`. Current, correct
pattern:

```text
/home/mdaj/files                       2770  mdaj:nogroup
/home/mdaj/public_html/cache           2770  mdaj:nogroup
/home/mdaj/public_html/public          2775  mdaj:nogroup
/home/mdaj/public_html/config.inc.php  0640  mdaj:nogroup
```

Do not grant `777` or chown runtime directories to `www-data`; that account has
no access to this installation.

### Email

- SMTP `smtp.purelymail.com:587` with TLS, sender `noreply@mdajournal.com`,
  envelope sender `eic@mdajournal.com`, DMARC-compliant From enabled.
- DNS verified: SPF `include:_spf.purelymail.com`, DMARC `p=reject`, DKIM
  published under selector `purelymail2` (CNAME to
  `key2.dkimroot.purelymail.com`), MX `mailserver.purelymail.com`.

### Runtime and housekeeping

- Queue processing runs on schedule (many `ProcessQueueJobs` logs dated
  2026-09-14); no queued or failed jobs.
- The site owner's crontab runs the sitemap generator daily at 03:15. A separate
  system job, `/etc/cron.d/idrive-mysql-dump` (22:45 daily), dumps local MySQL
  databases before the IDrive file backup; its output location is not readable
  from the site account, so its coverage of `mdaj_ojsdb` is unverified.
- `cache/` is about 16 MB, `files/` about 1.1 MB, `public/` about 176 KB.
- `sessions` holds roughly 10 900 rows and `scheduledTaskLogs` holds 189 files;
  both are normal but worth pruning periodically.

## 9. Open work

Open work is tracked in `/home/mdaj/actions.md`. That file lists every
outstanding item with its location and verification step; this document only
changes when an item is completed and the verified state here needs updating.
Actions there are numbered 1–37 in order, and the numbers are permanent
identifiers — closed actions leave a gap rather than being renumbered.

As of 2026-09-14 the open work covers: rebuilding the submission pipeline and
publishing a first issue, Crossref/DOI configuration and the paid service
set-up (similarity checking, service budget), publisher and contact identity,
theme and content defects (LOCKSS, fees, print ISSN), editorial board and
reviewer capacity, sitemap and indexing, plugin clean-up (`soap`), and server
operations (HSTS, Cloudflare, backups, cleanup, patching).

## 10. Documentation policy

This file is the single source of truth for verified state and configuration;
`/home/mdaj/actions.md` is the working list of open actions. Component README
files under `plugins/themes/mdaDetox` and `resources/theme_info.md` must stay
short and point here instead of duplicating project state. Historic design notes
may stay under `/home/mdaj/resources` for reference only; they are not
authoritative.

The authoritative Detox reference remains `/home/mdaj/resources/Detox`
(`index.php`, `parts/header/main-header.php`, `assets/css/style.css`,
`assets/css/animate.css`, `assets/js/script.js`). The finished OJS theme must
never depend on that directory at runtime.
