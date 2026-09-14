# MDA Journal Public Launch Roadmap

## Current readiness

The OJS website is enabled and publicly accessible, but the journal is not yet ready for formal indexing.

Current database findings:

- Journal is enabled.
- One active submission exists.
- Zero articles are published.
- Zero issues are published.
- No ISSN is configured.
- No publisher institution is configured.
- No clear publication license is configured.
- CLOCKSS wording is displayed, but it must be removed unless the journal actually participates in CLOCKSS.

The immediate priority is credible journal content and complete publishing policies—not XML export plugins.

## Phase 1: Complete the journal identity

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

### Editorial board

Publish a complete editorial-board page containing:

- Full name of every member.
- Editorial role.
- Institutional affiliation.
- Country.
- ORCID or institutional profile when available.

Do not list anyone without their permission.

## Phase 2: Complete publication policies

Publish clear, separate policies covering the following topics.

### Editorial and review

- Editorial process.
- Peer-review model.
- Expected review stages and timelines.
- Reviewer confidentiality.
- Editorial independence.
- Handling of submissions from editors or board members.

### Publication ethics

- Research and publication ethics.
- Plagiarism and duplicate publication.
- Authorship and contributorship criteria.
- Conflicts of interest.
- Research involving people or animals.
- Informed consent.
- Data fabrication and image manipulation.
- Handling allegations of misconduct.

### Corrections and complaints

- Corrections and errata.
- Retractions.
- Expressions of concern.
- Complaints and appeals.
- Post-publication discussion.

### Copyright and access

- Copyright owner.
- Open-access policy.
- Reuse license, preferably Creative Commons Attribution 4.0 (CC BY 4.0), if appropriate.
- Author self-archiving policy.
- Article processing charges, or a clear statement that the journal charges no fees.
- Fee-waiver policy if charges exist.
- Privacy policy.
- Essential-cookie notice.

### Data and preservation

- Research-data availability policy.
- Data citation expectations.
- Repository recommendations.
- Long-term digital-preservation policy.

Do not claim participation in CLOCKSS, LOCKSS, Portico, Crossref, DataCite, DOAJ, PubMed, MEDLINE, or another service until participation is confirmed.

## Phase 3: Prepare the first issue

The journal should have credible peer-reviewed content before it is promoted widely.

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

Create and publish the first issue only after all article metadata and final files have been checked.

Every published article must have its own permanent public landing page.

## Phase 4: Obtain an ISSN

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

## Phase 5: Register DOIs through Crossref

Crossref is normally the appropriate DOI registration agency for journal articles.

Options:

- Join Crossref directly.
- Join through an approved sponsoring organization.
- Check eligibility for the Crossref Global Equitable Membership program.

Before registration:

- Confirm that each article has a stable landing page.
- Define a consistent DOI suffix pattern.
- Configure the OJS DOI and Crossref plugins.
- Validate exported Crossref XML.

Do not display DOI strings as active links until the records have been successfully registered.

Crossref guidance: <https://www.crossref.org/membership/>

## Phase 6: Deploy to production

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

Use the separate production checklist:

- `/home/mdaj/resources/documentation/mdajournal-production-hardening.md`

## Phase 7: Public launch verification

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

## Phase 8: Discovery and indexing

### Immediately after publishing

- Ensure search engines are allowed to crawl public article pages.
- Verify article metadata in page headers.
- Register the site with Google Search Console and Bing Webmaster Tools.
- Confirm Google Scholar can access article landing pages and PDFs.
- Submit an XML sitemap if available.

### After ISSN and DOI setup

- Register article DOIs through Crossref.
- Verify every DOI resolves to the correct article landing page.
- Correct metadata errors promptly.

### DOAJ

Apply when the journal has an established and consistent open-access publishing record and meets all DOAJ transparency requirements.

DOAJ expects, among other requirements:

- Active scholarly publishing.
- At least five research articles per year.
- Immediate reader access without registration.
- Transparent ownership and editorial information.
- Clear peer-review, copyright, licensing, and fee policies.

DOAJ application guide: <https://doaj.org/apply/guide/>

### MEDLINE and PubMed

Treat MEDLINE/PubMed as a later objective. The PubMed XML Export Plugin does not automatically index a journal.

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

MEDLINE requirements: <https://www.nlm.nih.gov/medline/medline_how_to_include.html>

## Plugin priorities

### Enable now

- Users XML Plugin for controlled user migration and backup.
- Native XML Plugin for OJS-native article and issue migration.
- DOAJ Export Plugin for preparation and validation.
- Crossref XML Export Plugin if Crossref DOI registration is planned.

### Use only when eligible

- DataCite registration requires DataCite credentials and is generally more appropriate for datasets, software, and repository objects than journal articles.
- PubMed XML submission requires acceptance and deposit credentials from NLM.

Exporting XML does not itself register, publish, or index content.

## Immediate next actions

Complete these in order:

1. Add the legal publisher identity and address.
2. Complete the editorial-board page.
3. Select and publish the copyright and open-access license.
4. Clearly state publication fees or that there are no fees.
5. Complete ethics, peer-review, correction, complaint, and data policies.
6. Remove unsupported CLOCKSS wording unless participation is confirmed.
7. Recruit and process credible articles for the first issue.
8. Apply for an ISSN.
9. Publish the first complete issue.
10. Join Crossref directly or through a sponsor and register article DOIs.
11. Deploy and test the hardened production website.
12. Begin discovery and indexing work after publication.

