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

## 1. How this document is maintained

This file replaces the earlier set of overlapping, partly obsolete documents:
`OJS_Publication_Readiness_Audit.md`, `MD_Files/PROJECT.md`, `MD_Files/README.md`,
`MD_Files/SECURITY.md`, `MD_Files/actions.md`,
`mdajournal-production-hardening.md`, and `mdajournal-public-launch-roadmap.md`.
Those files were deleted in commit `95a53ed3`; their still-relevant content is
folded in here, and completed actions are not reproduced.

Rules for this file:

- Record verified state, not intentions. Date every state snapshot.
- Keep open work in one place (section 9) and delete items as they close.
- Never record passwords, API keys, salts, or SMTP credentials here.
- Update this file whenever journal settings, policies, theme files, or server
  configuration change.

`project.md` itself is untracked (the repository `.gitignore` ignores everything
outside `public_html/`, `www`, and `.github/`), so it does not appear in
`git status`. Track it or copy it elsewhere deliberately if that matters.

Small related files point here:

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
| Submissions | 2, both still in the Submission stage; 0 review rounds, 0 decisions |
| Published content | 0 issues, 0 published articles, 0 DOI records |
| ISSN | Online 3152-8961 (displayed), print 3122-3206 (configured, not displayed) |
| Licence | CC BY 4.0 (`licenseUrl`), copyright holder type `author` |
| Queue | Job/task runners active; `jobs` and `failed_jobs` both 0 |
| Backups | No on-server backup directory found; off-server backup status unverified |

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
| Licence | CC BY 4.0 (`https://creativecommons.org/licenses/by/4.0`) |
| Copyright holder type | author |
| Copyright notice | Authors retain copyright; articles published under CC BY 4.0 |
| Page footer text | "Copyright © MDA Journal 2026-2027. All rights reserved." |
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
| Oozypal@gmail.com | Reader (author and reviewer role windows ended) | never logged in |

No user belongs to the Editorial Board Member group (19), no reviewer interests
are recorded, and only two reviewers have ever logged in.

Submissions:

| ID | Title | Author | Submitted | Stage |
| --- | --- | --- | --- | --- |
| 2 | The Low-Cost Carrier Ascendancy in India: An Empirical Evaluation | Krishna Lok Singh | 2026-06-12 | Submission (stage 1) |
| 3 | Boolean Reliability Models for Representative Aircraft Autoland Architectures | Hasan Ahmed | 2026-09-06 | Submission (stage 1) |

Both are unpublished, each has a submission file but no galley, no review round,
no review assignment and no editorial decision. Submission 2 has been idle since
June 2026.

Announcements — 5 active, none with an expiry date, all posted 2026-09-10/11:

- Call for Papers: Inaugural Issue (January 2027)
- Welcome to MDAJ
- Join Our Reviewer Network
- Exploring the Future of Aviation: Our Multi-Disciplinary Focus
- Commitment to Rapid and Rigorous Peer Review

Email: 4 entries in `email_log` and 6 journal-specific email template overrides.

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
- Detox-style white responsive header with OJS menus, search, user actions and a
  compact sticky state that matches the Detox reference behaviour
- Full-width illustrated homepage: animated heading, CMS-managed hero text from
  Additional Content, feature cards, announcements and current-issue output
- Themed About, Contact, Editorial Team, Privacy, Announcements (list and
  detail), Current Issue, Issue Archive, Information and custom policy pages
- Footer with brand, quick links, policy links, contact block, open-access and
  CC BY badges, and a dynamically resolved copyright year
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

After a meaningful change, walk the public pages (home, About, Editorial Team,
Announcements list and detail, policy pages, Issue Archive, Search, Login,
Submissions), then the authenticated flows (submission, review, decision) with a
test account, at mobile, tablet and desktop widths.

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
- `cache/` is about 16 MB, `files/` about 1.1 MB, `public/` about 176 KB.
- `sessions` holds roughly 10 900 rows and `scheduledTaskLogs` holds 189 files;
  both are normal but worth pruning periodically.

## 9. Open work

### 9.1 Publishing content

1. Take both submissions through review and publish the first issue, or decide
   to launch with a clearly labelled forthcoming issue.
2. Disposition submission 2 (idle since June 2026) — assign a section editor or
   decline it.
3. Before publishing, verify article metadata, final PDFs, references, ORCIDs,
   funding and conflict statements, and licensing. Every article needs its own
   stable public landing page.

### 9.2 Identifiers and indexing

4. Configure a Crossref DOI prefix and credentials, or disable the Crossref
   plugin until they exist; no DOI records exist yet.
5. Decide whether a print ISSN is appropriate — 3122-3206 is configured but no
   print edition exists and the number is not displayed.
6. Create a sitemap, submit it to Google Search Console and Bing, and confirm
   Google Scholar can read article landing pages and PDFs once articles exist.
7. Consider DOAJ and MEDLINE/PubMed only after a publication record exists
   (DOAJ expects around five research articles per year; MEDLINE needs at least
   12 months and around 40 articles).

### 9.3 Site content and consistency

8. Fix the footer copyright rendering: the template rewrites every four-digit
   year, so "2026-2027" renders as "2026-2026".
9. Reconcile the footer wording ("All rights reserved") with the CC BY 4.0
   licence, and decide whether the footer should carry a year range at all.
10. Remove the duplicated `<meta name="description">` (core plus
    `customHeaders`) and add a canonical link.
11. Harden `robots.txt` (currently only `Disallow: /cache/`) with the system
    paths it should exclude.
12. Update `readerInformation`: it still tells readers to use a "Register" link
    in the home-page header and sends them to `/mdaj/user/register`, which now
    only says registrations are closed.
13. Update `authorInformation`: it uses an `http://` link and points to
    `/mdaj/author-guidelines`, which returns 404; point it at
    `/mdaj/about/submissions#authorGuidelines`.
14. Fix the two remaining non-canonical `/index.php/mdaj/...` links inside the
    Call for Papers and Open Access custom pages.
15. Correct the stored remote URL for the Author Guidelines menu item, which
    contains a typo (`/mdajj/...`) even though the live menu renders the correct
    URL.
16. Surface or remove the configured LOCKSS statement; nothing on the public
    site displays it and there is no confirmed LOCKSS participation.
17. Decide the fee position: the Charges page states an APC of USD 100 with
    waivers while OJS has no fee or payment configuration.

### 9.4 Journal identity and accounts

18. Add the publisher's registered address and country, and complete contact
    details (mailing address, contact title, affiliation, phone).
19. Replace the site-level contact name "Open Journal Systems".
20. Populate the Editorial Board Member group and masthead, or drop group 19
    from `mastheadUserGroupIds` and rely on the custom Editorial Team page.
21. Recruit reviewers (only two have ever logged in) and record reviewer
    interests.
22. Review the eight accounts: confirm `em@mdajournal.com` (idle since October
    2025) and remove or document `Oozypal@gmail.com`, which never logged in.

### 9.5 Integrations and plugins

23. The Google Analytics plugin is enabled with no measurement ID — add a GA4
    ID or disable the plugin.
24. ORCID is disabled with empty credentials — enable and configure, or keep it
    disabled deliberately.
25. Decide whether the enabled `subscriptionBlock` is appropriate for a fully
    open access journal with no subscription types.
26. Remove stale plugin records for themes whose directories no longer exist
    (`katen`, `mdaScience`, `healthSciences`, `healthAtlas`, `ammoniteTheme`,
    `bootstrap3`, `material`, `classic`, `erticazPress`) so the plugin list
    matches disk.
27. Confirm whether any enabled integration needs the missing PHP `soap`
    extension; install it only if required.

### 9.6 Server and operations

28. Decide on HSTS (`Strict-Transport-Security`) once HTTPS is confirmed for
    every required hostname; it is not currently sent.
29. Decide whether to put the site behind Cloudflare. If so: Full (strict) SSL,
    WAF and bot rules, conservative rate limiting, `mod_remoteip`, then
    `trust_x_forwarded_for = On`, and finally restricted origin access. None of
    this is in place today.
30. Establish and test a documented backup routine (database, `public/`,
    `files/`, configuration); no on-server backup directory or restore test was
    found.
31. Remove the placeholder reCAPTCHA keys from `config.inc.php` (ALTCHA is the
    active protection) and remove upstream development files that are publicly
    readable, such as `phpdoc.dist.xml`, `cypress.config.js`, `vite.config.js`,
    `.eslintrc.cjs`, `jsconfig.json` and `schemaspy.properties`. Markdown files
    under the web root (for example
    `plugins/themes/mdaDetox/README.md`) are also served as plain text, so keep
    them free of sensitive detail.
32. Prune old session rows and `scheduledTaskLogs` files periodically, and keep
    OJS, PHP, Apache, MariaDB and OS packages patched; confirm the current OJS
    3.5.x patch release before each upgrade.
33. Decide how this project guide is version-controlled, since it is currently
    untracked.

## 10. Documentation policy

This file is the single source of truth. Component README files under
`plugins/themes/mdaDetox` and `resources/theme_info.md` must stay short and point
here instead of duplicating project state. Historic design notes may stay under
`/home/mdaj/resources` for reference only; they are not authoritative.

The authoritative Detox reference remains `/home/mdaj/resources/Detox`
(`index.php`, `parts/header/main-header.php`, `assets/css/style.css`,
`assets/css/animate.css`, `assets/js/script.js`). The finished OJS theme must
never depend on that directory at runtime.
