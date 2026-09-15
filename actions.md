# MDA Journal — Open Action List

**Last updated:** 2026-09-15

This is the working task list for the MDA Journal site. Verified state,
settings, site map and theme documentation live in `project.md`; this file holds
only what still needs doing. Completed actions are removed after the work has
been committed.

Conventions:

- Actions are numbered in document order. Renumber when splitting or merging
  tasks, and update every cross-reference in this file at the same time.
- Numbers are not a priority order. Sections group the work by area.
- "Location" gives the exact file, database setting, or screen where the change
  belongs.
- Never put passwords, API keys, salts, or SMTP credentials in this file.

If you want the shortlist that decides whether the journal can launch: **1, 2, 3,
11**. Public-facing decisions are **9–11**.

---

## A. Publishing content (1–2)

- [ ] **1. Publish the first issue.**
  The journal holds no manuscripts: submissions 2 and 3 were deleted on
  2026-09-14, so new submissions are needed before an issue can be assembled.
  Alternatively launch with a clearly labelled forthcoming issue.
  Context: `project.md` §6.
  Verify: `/mdaj/issue/current` shows the issue and every article has its own
  landing page.

- [ ] **2. Run pre-publication checks on each accepted article.**
  Final PDF, title/abstract/keywords, references, author affiliations and
  countries, ORCIDs, funding and conflict statements, copyright/licence, and
  author approval of the final version. Applies once new manuscripts exist.

## B. Identifiers and indexing (3–8)

- [ ] **3. Join Crossref and configure DOI registration, or defer it.**
  DOIs are enabled (`enableDois = 1`, type `publication`) but there is no
  `doiPrefix`, no registration agency, and `crossrefplugin` has only
  `enabled = 1` in `plugin_settings` — no credentials. This is the first paid
  service to put in place: direct independent membership rather than buying DOIs
  from a reseller. Independent membership starts around US$200/year while
  publishing revenue is under US$1,000, then US$275; each current
  journal-article DOI costs about US$1.00, falling to US$0.95 on 2027-01-01.
  Membership also unlocks Crossref Similarity Check (action 23).
  Location: Settings → Distribution → DOIs, plus the Crossref plugin settings.
  Verify: a deposit from OJS registers a DOI and the `dois` table records it.

- [ ] **4. Register the journal with Google Search Console and Bing Webmaster
  Tools.**
  The sitemap is live and `robots.txt` already points at it; the daily
  regeneration job is installed. This action is the owner-only step: sign in to
  each service, add `mdajournal.com` as a domain property, and complete
  verification. Prefer a DNS TXT record over an HTML file or meta tag because it
  also covers subpaths and is not tied to the current theme. Bing can import the
  verified property from Google Search Console.
  Location: Google/Bing account, DNS control panel.
  Verify: both dashboards show the property as verified and the sitemap is
  submitted.

- [ ] **5. Confirm Google Scholar can read the first published article.**
  The Google Scholar plugin is enabled, and the theme header loads
  `frontend/components/headerHead.tpl`, which renders plugin-generated head
  tags. There is still no article to test. After the first publication, verify
  the landing page returns 200, is not `noindex`, and emits:
  `citation_journal_title`, `citation_issn`, `citation_author`,
  `citation_title`, `citation_date`, `citation_abstract_html_url`, and
  `citation_pdf_url`. The PDF galley must return 200 as `application/pdf`.
  Also confirm authors have affiliations, the publication has a locale, the
  issue has a publication date, page numbers are set, references are present in
  the article metadata, and the article appears in `sitemap.xml`.
  Location: Google Scholar plugin, article landing page, PDF galley, issue
  metadata.
  Verify: a published article page contains the expected `citation_*` tags and
  its PDF is crawlable.

- [ ] **6. Apply to DOAJ.**
  DOAJ is free to apply to but expects a real publishing record (roughly five
  research articles a year) and clear public policies: peer review, copyright,
  licensing, editorial board, publication ethics, APCs, conflicts of interest,
  plagiarism, corrections/retractions and archiving. The DOAJ export plugin is
  registered in `versions` and needs configuring before applying.
  Verify: the journal meets every DOAJ requirement and the application is
  submitted after the first issues exist.

- [ ] **7. Work toward Scopus and Web of Science.**
  These come later, after MDAJ shows consistent, independent, peer-reviewed
  publication. Reassess only after the journal has a demonstrable multi-issue
  record and has resolved editorial-board and reviewer-pool gaps.
  Verify: the journal meets each database's title-selection criteria before
  applying.

- [ ] **8. Work toward MEDLINE.**
  MEDLINE needs at least 12 months and around 40 articles, so it is the last
  indexing goal. Reassess after the journal has a substantive biomedical or
  aviation-medicine publication record, if applicable.
  Verify: the journal has the required publication history and scope before
  applying.

## C. Site content and consistency (9–11)

- [ ] **9. Install and configure the PLN plugin after issue 1.**
  Decision 2026-09-15: use the free PKP Preservation Network (PLN), deferred
  until after the first issue is published. The old misleading LOCKSS and
  CLOCKSS license texts have already been removed from `journal_settings`.
  Remaining: install the PLN plugin, accept its agreement, and configure it for
  journal ID 1.
  Location: Settings → Distribution → Archiving / PLN plugin settings.
  Verify: the PLN plugin reports the journal as enrolled and successfully
  deposits after the first issue.

- [ ] **10. Publish the PLN preservation statement and document archive
  continuity.**
  After the PLN plugin is installed, publish a preservation statement that
  matches what PLN actually provides, and document what happens to the archive
  if mdajournal.com disappears.
  Location: About or archiving policy page, journal records.
  Verify: the public statement names PLN accurately and the continuity plan is
  recorded outside the web root.

- [ ] **11. Decide the fee position.**
  The Charges page states an Article Processing Charge of USD 100 with a waiver
  policy, while OJS has no fee configuration, no payment plugin enabled, and no
  subscription types.
  Location: `journal_settings` / payment settings, plus navigation menu item 29
  (Article Processing Charges).

## D. Journal identity and accounts (12–13)

- [ ] **12. Resolve the editorial board.**
  `mastheadUserGroupIds` is `[3, 5, 19]`, but group 19 (Editorial Board Member)
  has no members. Either add board members with their permission and complete
  profiles, or drop 19 from the masthead list and rely on the custom Editorial
  Team page (navigation menu item 25).

- [ ] **13. Build the reviewer pool.**
  Only ATTAR and batikh have ever logged in, and `user_interests` is empty.
  Invite and record reviewers (registration is closed, so accounts must be
  created for them) and capture their subject interests.

## E. Integrations and plugins (14)

- [ ] **14. Complete the ORCID redirect check and connect a test iD.**
  ORCID is enabled at the journal level with the free Public API. Confirm the
  ORCID Developer Tools client has the three OJS redirect URIs registered, then
  connect an ORCID iD from an OJS user profile to prove the journal-level Public
  API is usable end to end.
  Location: ORCID Developer Tools, OJS user profile.
  Verify: a user can connect and store an ORCID iD without error.

## F. Server and operations (15–24)

- [ ] **15. Decide on HSTS.**
  No `Strict-Transport-Security` header is sent. Add it to the HTTPS vhost in
  `/etc/apache2/sites-enabled/mdajournal.com.conf` only after HTTPS is confirmed
  for every required hostname; use `includeSubDomains` only when all subdomains
  qualify.

- [ ] **16. Decide on Cloudflare.**
  The site is currently served directly by the origin (A record
  `192.236.161.63`), with no proxy headers. If Cloudflare is adopted:
  SSL/TLS Full (strict), Always Use HTTPS, WAF and bot protection, conservative
  rate limits on login/registration/lost-password paths, `mod_remoteip` with
  Cloudflare ranges, then `trust_x_forwarded_for = On` in `config.inc.php`, and
  finally restrict ports 80/443 to Cloudflare addresses while keeping SSH
  restricted.

- [ ] **17. Establish routine local backups.**
  A one-off full dump exists, but `/var/backups` holds only system files. Back
  up the database, `public_html/public/`, `/home/mdaj/files/` and the
  configuration daily, and verify the job is monitored.
  Location: backup script and cron entry.
  Verify: a daily backup is created and a restore is possible from it.

- [ ] **18. Add encrypted off-server copies and test a restore.**
  After local backups are routine, copy the encrypted archive off-server, keep
  enough retention, and run a test restore in a clean location.
  Location: off-site storage and restore procedure.
  Verify: a backup copy exists outside the server and a documented restore test
  succeeds.

- [ ] **19. Remove the placeholder reCAPTCHA keys from `config.inc.php`.**
  Delete the placeholder `recaptcha_public_key` / `recaptcha_private_key`
  values, keeping `recaptcha = off`; ALTCHA is the active protection.
  Location: `/home/mdaj/public_html/config.inc.php`.
  Verify: the keys are absent and login still uses ALTCHA.

- [ ] **20. Remove publicly readable development files.**
  Delete files such as `phpdoc.dist.xml`, `cypress.config.js`, `vite.config.js`,
  `.eslintrc.cjs`, `jsconfig.json`, `schemaspy.properties` and `.husky/`.
  Keep markdown files under the web root free of sensitive detail — they are
  served as plain text.
  Location: `/home/mdaj/public_html/`.
  Verify: the listed paths return 404 or are absent, and no other development
  files remain publicly reachable.

- [ ] **21. Clean up OJS runtime data.**
  Prune the `sessions` table (roughly 10 900 rows) and old
  `/home/mdaj/files/scheduledTaskLogs` files (189 today). This is a one-time
  cleanup; the recurring version is action 22.

- [ ] **22. Establish the ongoing maintenance and patch routine.**
  Keep OJS, PHP, Apache, MariaDB and the OS patched; confirm the current OJS
  3.5.x patch release before each upgrade; and schedule routine checks of logs,
  disk use and database health.
  Location: maintenance calendar, server package manager.
  Verify: the journal has a documented monthly maintenance and upgrade cycle.

- [ ] **23. Set up similarity/plagiarism screening.**
  The Plagiarism Policy page exists, but nothing in the workflow actually
  performs a check. Crossref Similarity Check (iThenticate) is the standard
  route for a Crossref member: about US$40/year at the lowest membership tier
  plus per-document charges. No similarity plugin is installed in this OJS, so
  screening runs through the iThenticate web interface or a third-party plugin
  during editorial screening, before peer review.
  Verify: every manuscript sent to reviewers has a recorded similarity result.

- [ ] **24. Set the Year-1 service budget and track renewals.**
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
