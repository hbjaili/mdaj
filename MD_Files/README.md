# MDA Journal OJS and MDA Detox Theme

Last verified: 2026-08-30

## Purpose

This is the authoritative project guide for the MDA Journal OJS installation
and its custom `mdaDetox` theme. It consolidates the former project README,
theme build notes, plugin handoff notes, and template-override notes.

The active design is **MDA Detox**. Earlier references to Katen describe an
abandoned or superseded direction and are not the current implementation.

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

The public journal homepage returned HTTP 200 during verification and included
the MDA Detox body, header, hero, navigation, homepage, JavaScript, and image
asset references.

## Project locations

- OJS web root: `/home/mdaj/public_html`
- Project resource root: `/home/mdaj/resources`
- Authoritative project guide: `/home/mdaj/resources/README.md`
- Theme plugin: `/home/mdaj/public_html/plugins/themes/mdaDetox`
- Authoritative Detox reference template: `/home/mdaj/resources/Detox`
- Detox homepage reference: `/home/mdaj/resources/Detox/index.php`
- Detox header markup: `/home/mdaj/resources/Detox/parts/header/main-header.php`
- Detox header styles: `/home/mdaj/resources/Detox/assets/css/style.css`
- Detox animation definitions: `/home/mdaj/resources/Detox/assets/css/animate.css`
- Detox scroll behavior: `/home/mdaj/resources/Detox/assets/js/script.js`
- Shared project assets: `/home/mdaj/resources/assets`
- Operational documentation: `/home/mdaj/resources/documentation`
- Production hardening checklist:
  `/home/mdaj/resources/documentation/mdajournal-production-hardening.md`
- Public launch roadmap:
  `/home/mdaj/resources/documentation/mdajournal-public-launch-roadmap.md`

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
|   |   `-- footer.less
|   `-- pages/
|       `-- home.less
`-- templates/
    |-- frontend/
    |   |-- components/header.tpl
    |   |-- components/footer.tpl
    |   `-- pages/indexJournal.tpl
    `-- plugins/
        `-- blocks/information/templates/block.tpl
```

Key responsibilities:

- `MdaDetoxThemePlugin.php` registers the Default Theme parent, colour option,
  fonts, LESS, and JavaScript.
- `styles/variables.less` contains shared design tokens.
- `styles/components/header.less` controls desktop and mobile navigation.
- `styles/components/footer.less` controls the footer layout and links.
- `styles/pages/home.less` controls the hero and homepage sections.
- `templates/frontend/components/header.tpl` preserves OJS identity, menus,
  search, user actions, and accessibility hooks in a Detox-style header.
- `templates/frontend/components/footer.tpl` renders the Detox-style footer from
  OJS journal metadata and navigation.
- `templates/frontend/pages/indexJournal.tpl` maps live OJS content into the
  Detox homepage.
- `templates/plugins/blocks/information/templates/block.tpl` keeps the sidebar
  Information links (For Readers, For Authors, For Librarians) consistent with
  the footer.
- `js/main.js` progressively enhances the sticky header and animated heading,
  and respects the user's reduced-motion preference.

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
- Keyboard focus and reduced-motion support

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
passed. The compiled compressed theme CSS was 21,174 bytes.

After a meaningful change, also test public and authenticated OJS workflows:

- Homepage
- About pages
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
- Confirm final brand colours, logo use, and licensed imagery
- Design article and issue summaries
- Design article detail and galley-download pages
- Design issue archive and search pages
- Design the sidebar blocks and supporting navigation
- Test responsive behavior across target viewport sizes
- Perform a complete accessibility review
- Test with realistic journal content and authenticated roles
- Complete the production hardening and public launch checklists
- Package and version the first production-ready theme release

## Documentation policy

This file is the single authoritative project and theme guide. Component-level
README files may contain only a pointer here plus a short statement needed at
that location. OJS's root `README.md` is upstream OJS documentation and must
remain unchanged.
