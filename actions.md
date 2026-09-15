# MDA Journal — Action List

**Last updated:** 2026-09-14

This is the working task list for the MDA Journal site. Verified state,
settings, site map and theme documentation live in `project.md`; this file holds
only what still needs doing.

Conventions:

- Actions are numbered 1–37 in document order. The number is a permanent
  identifier: if an action is closed, mark it done and leave the gap — never
  renumber the remaining actions.
- Numbers are not a priority order. Sections group the work by area.
- "Location" gives the exact file, database setting, or screen where the change
  belongs.
- Never put passwords, API keys, salts, or SMTP credentials in this file.

If you want the shortlist that decides whether the journal can launch: **1, 3, 4,
18, 19** (action 2 is closed). Public-facing defects and decisions are **5–17**.

---

## A. Publishing content (1–3)

- [ ] **1. Publish the first issue.**
  The journal holds no manuscripts: submissions 2 and 3 were deleted on
  2026-09-14, so new submissions are needed before an issue can be assembled.
  Alternatively launch with a clearly labelled forthcoming issue.
  Context: `project.md` §6.
  Verify: `/mdaj/issue/current` shows the issue and every article has its own
  landing page.

- [x] **2. Dispose of submission 2. — CLOSED 2026-09-14**
  Resolved by deletion rather than review: the journal manager removed both
  submissions through OJS today (files deleted 10:21–10:22, then the submission,
  publication, author and file rows). No orphan records remain and the public
  site is unaffected. Follow-up for the un-notified author is action 33.

- [ ] **3. Run pre-publication checks on each accepted article.**
  Final PDF, title/abstract/keywords, references, author affiliations and
  countries, ORCIDs, funding and conflict statements, copyright/licence, and
  author approval of the final version. Applies once new manuscripts exist.

## B. Identifiers and indexing (4–7)

- [ ] **4. Join Crossref and configure DOI registration, or defer it.**
  DOIs are enabled (`enableDois = 1`, type `publication`) but there is no
  `doiPrefix`, no registration agency, and `crossrefplugin` has only
  `enabled = 1` in `plugin_settings` — no credentials. This is the first paid
  service to put in place: direct independent membership rather than buying DOIs
  from a reseller. Independent membership starts around US$200/year while
  publishing revenue is under US$1,000, then US$275; each current
  journal-article DOI costs about US$1.00, falling to US$0.95 on 2027-01-01.
  Membership also unlocks Crossref Similarity Check (action 35).
  Location: Settings → Distribution → DOIs, plus the Crossref plugin settings.
  Verify: a deposit from OJS registers a DOI and the `dois` table records it.

- [ ] **5. Decide on the print ISSN.**
  `journal_settings.printIssn` is `3122-3206`, but there is no print edition and
  the number is displayed nowhere. Show it beside the online ISSN in the theme
  header bar (or About page), or remove it.
  Location: Settings → Journal → Masthead; theme
  `templates/frontend/components/header.tpl`.

- [ ] **6. Submit the sitemap and prove Google Scholar readiness.**
  Done 2026-09-14: `sitemap.xml` is live (18 URLs) and is now regenerated daily
  by `/home/mdaj/scripts/generate-sitemap.php`, scheduled in the site owner's
  crontab, so published issues and articles are added automatically; `robots.txt`
  points at it. Remaining: register the site with Google Search Console and Bing
  Webmaster Tools — this needs the owner's account and a verification token or
  DNS record — and, once a real article is published, confirm Google Scholar can
  read it (landing page, PDF galley, authors, publication date). The Google
  Scholar plugin is already enabled, so the open question is whether the
  templates emit correct citation metadata.

- [ ] **7. Work toward DOAJ, then Scopus/Web of Science, then MEDLINE.**
  DOAJ is free to apply to but expects a real publishing record (roughly five
  research articles a year) and clear public policies: peer review, copyright,
  licensing, editorial board, publication ethics, APCs, conflicts of interest,
  plagiarism, corrections/retractions and archiving. The DOAJ export plugin is
  registered in `versions` and needs configuring before applying. Scopus and
  Web of Science come later, after MDAJ shows consistent, independent,
  peer-reviewed publication; MEDLINE needs at least 12 months and around 40
  articles. No application before the first issues exist.

## C. Site content and consistency (8–17)

- [x] **8. Fix the footer year. — CLOSED 2026-09-14**
  `footer.tpl` now collapses any year or year range found in `pageFooter` to the
  current year, so the stored "Copyright © MDA Journal 2026-2027" renders as
  "Copyright © MDA Journal 2026" and rolls forward on its own each January. The
  old pattern replaced each year separately, which produced "2026-2026".
  Pattern: `/20[0-9][0-9][ \t]*-[ \t]*20[0-9][0-9]|20[0-9][0-9]/`, replaced with
  the year from `$smarty.now`; the stored `pageFooter` now supplies the wording
  only. Caveat: if the stored footer contains no year at all, none is printed.
  Verified on the live homepage; the previous template is kept at
  `/home/mdaj/backups/theme-20260914/footer.tpl.before-year-fix`.

- [x] **9. State the copyright and licensing model consistently. — CLOSED 2026-09-14**
  The footer now says website content is © MDA Journal while article copyright
  remains with the authors under CC BY 4.0. `copyrightNotice` and
  `copyrightHolderType = author` were already correct, and both the About page
  and Author Guidelines now include the same Copyright and Licensing section.
  Verified in `journal_settings`.

- [x] **10. Fix head metadata. — CLOSED 2026-09-14**
  `customHeaders` was emptied, so the homepage now emits exactly one
  `<meta name="description">`, taken from the journal's `searchDescription`
  field. The theme plugin registers a self-referencing
  `<link rel="canonical">` built through the OJS router, so
  `/index.php/mdaj/about` canonicalises to `/mdaj/about`; login, registration
  and search pages carry `noindex, follow` instead of a canonical.
  Verified across the homepage, about, custom policy pages, announcements,
  announcement detail and issue archive. Idempotent on re-run (the hook skips
  pages that already have the tag).

- [x] **11. Harden `robots.txt`. — CLOSED 2026-09-14**
  `robots.txt` now allows crawling and blocks only OJS system paths that have no
  search value (`/cache/`, `/dbscripts/`, `/tools/`, `/registry/`, `/schemas/`,
  `/docs/`, `/cypress/`) plus the management backend (`/mdaj/management/`).
  Asset and article paths stay crawlable, utility pages rely on the `noindex`
  meta tag rather than a block (crawlers must be able to fetch a page to see
  `noindex`), and the file ends with
  `Sitemap: https://mdajournal.com/sitemap.xml`.

- [x] **12. Rewrite the "For Readers" information text. — CLOSED 2026-09-14**
  `readerInformation` now uses the contact-first intake wording: email a short
  proposal to `em@mdajournal.com`, then log in after the editorial office creates
  the author account. The old `/user/register` link is gone; the `mailto` and
  `/mdaj/login` links are present. Verified in `journal_settings`.

- [x] **13. Fix the "For Authors" information text. — CLOSED 2026-09-14**
  `authorInformation` now links to the About page and Author Guidelines over
  HTTPS, uses `mailto:em@mdajournal.com` for the proposal, and links to
  `https://mdajournal.com/mdaj/login` after account creation. No `http://` or
  `/user/register` links remain.

- [x] **14. Fix the non-canonical internal links on custom pages. — CLOSED 2026-09-14**
  Both fixed in the stored page content: the Call for Papers page no longer
  links to `http://mdajournal.com/index.php/mdaj/about/submissions`, and the
  Open Access page no longer links to
  `https://mdajournal.com/index.php/mdaj/issue/archive`. Verified by re-reading
  `navigation_menu_item_settings` items 26 and 32 — no `index.php` or `http://`
  references remain.

- [x] **15. Correct the Author Guidelines menu URL. — CLOSED 2026-09-14**
  Navigation menu item 27 now stores
  `https://mdajournal.com/mdaj/about/submissions#authorGuidelines` — the
  "mdajj" typo is gone. Verified by reading
  `navigation_menu_item_settings` for item 27, `remoteUrl`.

- [ ] **16. Adopt a preservation route and fix the LOCKSS wording.**
  Serious indexes expect a preservation policy, and
  `journal_settings.lockssLicense` currently claims LOCKSS participation with no
  membership confirmed. Prefer the free PKP Preservation Network (PLN) plugin —
  it is not installed in this OJS yet — and treat LOCKSS/CLOCKSS (paid) as
  alternatives. Then publish the statement that matches the chosen service, or
  remove it, and document what happens to the archive if mdajournal.com
  disappears.

- [ ] **17. Decide the fee position.**
  The Charges page states an Article Processing Charge of USD 100 with a waiver
  policy, while OJS has no fee configuration, no payment plugin enabled, and no
  subscription types.
  Location: `journal_settings` / payment settings, plus navigation menu item 29
  (Article Processing Charges).

## D. Journal identity and accounts (18–22)

- [ ] **18. Complete publisher and contact identity.**
  `publisherInstitution` is set to "Hasan Ahmed Omar Bjaili Est.", but no
  publisher address or country exists, and `journal_settings` has no
  `mailingAddress`, `location`, `contactTitle`, `contactAffiliation`,
  `contactPhone` or `supportPhone`.
  Location: Settings → Journal → Masthead and Contact.

- [ ] **19. Replace the site-level contact name.**
  `site_settings.contactName` is still the installation default
  "Open Journal Systems".
  Location: Site Settings → Contact (administrator account).

- [ ] **20. Resolve the editorial board.**
  `mastheadUserGroupIds` is `[3, 5, 19]`, but group 19 (Editorial Board Member)
  has no members. Either add board members with their permission and complete
  profiles, or drop 19 from the masthead list and rely on the custom Editorial
  Team page (navigation menu item 25).

- [ ] **21. Build the reviewer pool.**
  Only ATTAR and batikh have ever logged in, and `user_interests` is empty.
  Invite and record reviewers (registration is closed, so accounts must be
  created for them) and capture their subject interests.

- [x] **22. Review the eight user accounts. — CLOSED 2026-09-14**
  `em@mdajournal.com` is the owner's editorial-manager mailbox and is kept; the
  public contact name stays "Editorial Manager" so the role can transfer to
  someone else later. The spam-merge sink was renamed from `Oozypal@gmail.com`
  to `deleted@mdajournal.com` and disabled on 2026-09-14; it remains the merge
  target for clearing spam users, since OJS does not support deleting users.

## E. Integrations and plugins (23–27)

- [x] **23. Google Analytics. — CLOSED 2026-09-14**
  GA4 measurement ID `G-Q267LBSLFB` saved to `googleAnalyticsSiteId` for the
  journal (account `283501844`, property `404723577`). The `gtag` snippet now
  renders on the live pages — the OJS data cache needed clearing before the
  newly added setting took effect. Allow up to 48 hours for Google Analytics to
  confirm data collection on its side.

- [x] **24. Enable ORCID. — CLOSED 2026-09-14**
  Enabled at the journal level: `orcidEnabled = 1`, API type
  `publicProduction`, and the free Public API Client ID and Secret are stored in
  `journal_settings`. Site-level settings remain empty. The Public API lets
  authors and reviewers connect and verify their iDs; it does not write
  publications back to ORCID — that requires the paid Member API later.
  Remaining check: confirm the ORCID Developer Tools client has the three OJS
  redirect URIs registered, then connect an ORCID iD from an OJS user profile.

- [x] **25. Subscription block. — CLOSED 2026-09-14**
  Disabled: `subscriptionblockplugin` is now `enabled = 0`. The bundled plugin
  files remain under `plugins/blocks/subscription` (normal for OJS — disabled
  plugins are simply not loaded), and the `versions` row stays for upgrade
  tracking. No deletion is needed or recommended for a core OJS plugin.

- [x] **26. Remove stale plugin records. — CLOSED 2026-09-14**
  Removed 11 `versions` rows and 45 `plugin_settings` rows for themes whose
  directories no longer exist (`katen`, `mdaScience`, `healthSciences` x2,
  `healthAtlas`, `ammoniteTheme`, `bootstrap3`, `material`, `classic`,
  `erticazPress`). Backup: `/home/mdaj/backups/plugin-cleanup-20260914.sql`.
  Only `default` and `mdaDetox` remain registered as themes, and the site still
  returns HTTP 200 on home, about and login.

- [x] **27. Check whether the `soap` extension is needed. — CLOSED 2026-09-14**
  Not needed. OJS 3.5 core does not list `soap` among its required PHP
  extensions, and a code search found no `SoapClient`/SOAP usage in OJS core or
  any installed plugin. Leave PHP as-is; do not install the extension.

## F. Server and operations (28–37)

- [ ] **28. Decide on HSTS.**
  No `Strict-Transport-Security` header is sent. Add it to the HTTPS vhost in
  `/etc/apache2/sites-enabled/mdajournal.com.conf` only after HTTPS is confirmed
  for every required hostname; use `includeSubDomains` only when all subdomains
  qualify.

- [ ] **29. Decide on Cloudflare.**
  The site is currently served directly by the origin (A record
  `192.236.161.63`), with no proxy headers. If Cloudflare is adopted:
  SSL/TLS Full (strict), Always Use HTTPS, WAF and bot protection, conservative
  rate limits on login/registration/lost-password paths, `mod_remoteip` with
  Cloudflare ranges, then `trust_x_forwarded_for = On` in `config.inc.php`, and
  finally restrict ports 80/443 to Cloudflare addresses while keeping SSH
  restricted.

- [ ] **30. Establish backups.**
  A one-off full dump now exists at
  `/home/mdaj/backups/mdaj_ojsdb-20260914-pre-workflow.sql` (28 MB, mode 600,
  outside the web root), but there is still no routine: `/var/backups` holds only
  system files. Back up the database, `public_html/public/`, `/home/mdaj/files/`
  and the configuration daily, store copies off-server encrypted, and test a
  restore.

- [ ] **31. Remove leftover development material.**
  Delete the placeholder `recaptcha_public_key` / `recaptcha_private_key`
  values from `config.inc.php` (keeping `recaptcha = off`; ALTCHA is the active
  protection), and remove publicly readable development files such as
  `phpdoc.dist.xml`, `cypress.config.js`, `vite.config.js`, `.eslintrc.cjs`,
  `jsconfig.json`, `schemaspy.properties` and `.husky/`.
  Keep markdown files under the web root free of sensitive detail — they are
  served as plain text.

- [ ] **32. Routine maintenance.**
  Prune the `sessions` table (roughly 10 900 rows) and old
  `/home/mdaj/files/scheduledTaskLogs` files (189 today); keep OJS, PHP, Apache,
  MariaDB and the OS patched; confirm the current OJS 3.5.x patch release before
  each upgrade.

- [x] **33. Close the loop with the deleted manuscript's author. — CLOSED 2026-09-14**
  "The Low-Cost Carrier Ascendancy in India: An Empirical Evaluation" by Krishna
  Lok Singh (`fatiguefracturemech@gmail.com`) was submitted on 2026-06-12 and
  deleted on 2026-09-14. The author had received the automatic submission
  acknowledgement on 2026-06-12 (email log rows 9–12), but nothing after it, and
  those log rows were removed with the submission.
  A closure notice was sent on 2026-09-14 from
  `MDA Journal Editorial Office <em@mdajournal.com>` (envelope `eic@mdajournal.com`,
  copy to the editorial mailbox), stating that the manuscript was not reviewed,
  that the submission has been withdrawn from the editorial system, and
  apologising for the delay; it invites the author to reply if they want to
  discuss it or submit the work again. Sent copy:
  `/home/mdaj/backups/author-notice-20260914/author-notice-krishna-lok-singh.eml`.
  This email bypasses the OJS log (the submission no longer exists), so the
  .eml copy is the journal's record.

- [x] **34. Add or restore the journal thumbnail. — CLOSED 2026-09-14**
  Added through OJS: `journalThumbnail` points at the red SVG mark
  (`journalThumbnail_en`, byte-identical to `favicon_en.svg`, alt text "MDAJ").
  The public file was serving without a Content-Type, so
  `public/journals/1/.htaccess` now forces `image/svg+xml` for the extensionless
  thumbnail as it already does for the logo.
  Verified: the setting is present and the file serves 200 with
  `Content-Type: image/svg+xml`.

- [ ] **35. Set up similarity/plagiarism screening.**
  The Plagiarism Policy page exists, but nothing in the workflow actually
  performs a check. Crossref Similarity Check (iThenticate) is the standard
  route for a Crossref member: about US$40/year at the lowest membership tier
  plus per-document charges. No similarity plugin is installed in this OJS, so
  screening runs through the iThenticate web interface or a third-party plugin
  during editorial screening, before peer review.
  Verify: every manuscript sent to reviewers has a recorded similarity result.

- [ ] **36. Set the Year-1 service budget and track renewals.**
  Paid: Crossref membership and DOI deposits, plus Crossref Similarity Check.
  Free: the online ISSN (already issued), ORCID, Creative Commons CC BY 4.0,
  the PKP Preservation Network, Google Scholar metadata and the ethics and
  policy pages. Record ownership, credentials and renewal dates for the
  infrastructure the journal already depends on — the domain, the VPS/Apache
  host and the PurelyMail SMTP account — so continuity does not depend on one
  person's memory or access. Managed OJS hosting (US$500–2,000+ per year) is the
  fallback if maintaining this server becomes a burden.
  Location: a budget and renewal note kept with the journal records (never
  secrets in this file).

- [ ] **37. Set up the daily sitemap regeneration cron job.**
  Command to install (runs as the site owner `mdaj`, daily at 03:15):

  ```cron
  15 3 * * * /usr/bin/php /home/mdaj/scripts/generate-sitemap.php
  ```

  Why: it rebuilds `public_html/sitemap.xml` from the database, so published
  issues and articles appear in the sitemap without manual edits (action 6).
  Status: installed in the `mdaj` user crontab on 2026-09-14 and verified with
  `crontab -l` and a cron-like run; re-add it after any server migration, or if
  the crontab is lost or recreated.
  Alternative: Debian root can drop the same line into
  `/etc/cron.d/mdaj-sitemap` (with the `mdaj` user field) — the site account
  cannot write to `/etc/cron.d`.
  Verify: `crontab -l | grep generate-sitemap` returns the line, and the
  `lastmod` dates inside `sitemap.xml` advance each day.
