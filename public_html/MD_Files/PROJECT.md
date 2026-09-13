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
