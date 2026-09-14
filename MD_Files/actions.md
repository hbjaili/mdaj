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
- [x] Reconciled the `.htaccess` cPanel `ea-php82` handler with the detected PHP
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
  explicitly and [x] update the page footer copyright year from 2025 to 2026.
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

Task [x] Implemented: change the logged-out branch of the submissions page so it explains the
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
