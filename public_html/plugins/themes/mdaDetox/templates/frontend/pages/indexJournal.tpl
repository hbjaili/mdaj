{**
 * MDA Detox journal homepage.
 * Uses OJS journal content with a Detox-inspired presentation.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal mda_detox_home">

	{call_hook name="Templates::Index::journal"}

	<section class="mda_detox_hero" aria-labelledby="mdaDetoxHeroTitle">
		<span class="mda_detox_pattern mda_detox_pattern_right" aria-hidden="true"></span>
		<span class="mda_detox_pattern mda_detox_pattern_left" aria-hidden="true"></span>
		<div class="mda_detox_hero_content">
			<p class="mda_detox_eyebrow">{translate key="plugins.themes.mdaDetox.home.eyebrow"}</p>
			<div class="mda_detox_hero_title" id="mdaDetoxHeroTitle">
				<span class="pkp_screen_reader">{$currentJournal->getLocalizedName()|escape}</span>
				<span class="mda_detox_hero_title_visual" aria-hidden="true">
					<span>{translate key="plugins.themes.mdaDetox.home.headingPrefix"}</span>
					<span class="mda_detox_typed_word" data-word="{translate|escape key="plugins.themes.mdaDetox.home.animatedWord"}">{translate key="plugins.themes.mdaDetox.home.animatedWord"}</span>
					<span>{translate key="plugins.themes.mdaDetox.home.staticWord"}</span>
				</span>
			</div>
			{* Use the CMS-managed Additional Content as the hero introduction.
			   Fall back to the journal description when it has not been configured. *}
			{if $additionalHomeContent}
				<div class="mda_detox_hero_text">
					{$additionalHomeContent}
				</div>
			{elseif $currentContext->getLocalizedData('description')}
				<div class="mda_detox_hero_text">
					{$currentContext->getLocalizedData('description')|strip_unsafe_html}
				</div>
			{/if}
			<div class="mda_detox_hero_actions">
				{if $issue}
					<a class="mda_detox_button mda_detox_button_primary" href="#homepageIssue">
						{translate key="journal.currentIssue"}
					</a>
				{/if}
				<a class="mda_detox_button mda_detox_button_secondary" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">
					{translate key="submission.wizard.title"}
				</a>
			</div>
		</div>
		<div class="mda_detox_hero_visual" aria-hidden="true">
			<div class="mda_detox_hero_art">
				<img class="mda_detox_hero_base" src="{$baseUrl}/plugins/themes/mdaDetox/images/home-hero.png" alt="" width="687" height="612" fetchpriority="high">
				<img class="mda_detox_hero_detail mda_detox_hero_detail_one" src="{$baseUrl}/plugins/themes/mdaDetox/images/home-hero-detail-1.png" alt="" width="162" height="227">
				<img class="mda_detox_hero_detail mda_detox_hero_detail_two" src="{$baseUrl}/plugins/themes/mdaDetox/images/home-hero-detail-2.png" alt="" width="159" height="122">
				<img class="mda_detox_hero_detail mda_detox_hero_detail_three" src="{$baseUrl}/plugins/themes/mdaDetox/images/home-hero-detail-3.png" alt="" width="75" height="91">
				<img class="mda_detox_hero_detail mda_detox_hero_detail_four" src="{$baseUrl}/plugins/themes/mdaDetox/images/home-hero-detail-4.png" alt="" width="54" height="157">
			</div>
		</div>
	</section>

	<nav class="mda_detox_feature_grid" aria-label="{translate|escape key="plugins.themes.mdaDetox.home.explore"}">
		<a class="mda_detox_feature_card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="readers"}">
			<span class="mda_detox_feature_number" aria-hidden="true">01</span>
			<span class="mda_detox_feature_content">
				<strong>{translate key="navigation.infoForReaders"}</strong>
				<span>{translate key="plugins.themes.mdaDetox.home.readersDescription"}</span>
				<em>{translate key="common.view"} <span aria-hidden="true">→</span></em>
			</span>
		</a>
		<a class="mda_detox_feature_card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="authors"}">
			<span class="mda_detox_feature_number" aria-hidden="true">02</span>
			<span class="mda_detox_feature_content">
				<strong>{translate key="navigation.infoForAuthors"}</strong>
				<span>{translate key="plugins.themes.mdaDetox.home.authorsDescription"}</span>
				<em>{translate key="common.view"} <span aria-hidden="true">→</span></em>
			</span>
		</a>
		<a class="mda_detox_feature_card" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="librarians"}">
			<span class="mda_detox_feature_number" aria-hidden="true">03</span>
			<span class="mda_detox_feature_content">
				<strong>{translate key="navigation.infoForLibrarians"}</strong>
				<span>{translate key="plugins.themes.mdaDetox.home.librariansDescription"}</span>
				<em>{translate key="common.view"} <span aria-hidden="true">→</span></em>
			</span>
		</a>
	</nav>

	<div class="mda_detox_home_body">
		{if $highlights->count()}
			{include file="frontend/components/highlights.tpl" highlights=$highlights}
		{/if}

		{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
			<div class="homepage_image">
				<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
			</div>
		{/if}

		{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex')}
			<section class="homepage_about">
				<a id="homepageAbout"></a>
				<div class="mda_detox_about_visual" aria-hidden="true">
					<img src="{$baseUrl}/plugins/themes/mdaDetox/images/about-journal.png" alt="" width="759" height="541" loading="lazy">
				</div>
				<div class="mda_detox_about_content">
					<div class="mda_detox_section_heading">
						<p>{translate key="plugins.themes.mdaDetox.home.aboutEyebrow"}</p>
						<h2>{translate key="about.aboutContext"}</h2>
					</div>
					<div class="mda_detox_about_text">
						{$currentContext->getLocalizedData('description')}
					</div>
					<a class="mda_detox_button mda_detox_button_primary" href="{url page="about"}">
						{translate key="common.readMore"}
					</a>
				</div>
			</section>
		{/if}

		{if $numAnnouncementsHomepage && $announcements|@count}
			<section class="cmp_announcements mda_detox_home_announcements">
				<a id="homepageAnnouncements"></a>

				<div class="mda_detox_home_announcements_layout">
					<div class="mda_detox_home_announcements_featured">
						<div class="mda_detox_section_heading">
							<p>{translate key="plugins.themes.mdaDetox.home.announcementsEyebrow"}</p>
							<h2>{translate key="announcement.announcements"}</h2>
						</div>
						{foreach from=$announcements item=announcement name=homeAnnouncements}
							{if $smarty.foreach.homeAnnouncements.iteration == 1}
								{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
							{/if}
						{/foreach}
					</div>

					{if $announcements|@count > 1}
						<div class="mda_detox_home_announcements_remaining">
							{foreach from=$announcements item=announcement name=homeAnnouncementsRemaining}
								{if $smarty.foreach.homeAnnouncementsRemaining.iteration > 1 && $smarty.foreach.homeAnnouncementsRemaining.iteration <= $numAnnouncementsHomepage}
									{include file="frontend/objects/announcement_summary.tpl" heading="h4"}
								{/if}
							{/foreach}
						</div>
					{/if}
				</div>
			</section>
		{/if}

		{if $issue}
			<section class="current_issue">
				<a id="homepageIssue"></a>
				<div class="mda_detox_section_heading">
					<p>{translate key="plugins.themes.mdaDetox.home.issueEyebrow"}</p>
					<h2>{translate key="journal.currentIssue"}</h2>
				</div>
				<div class="current_issue_title">
					{$issue->getIssueIdentification()|escape}
				</div>
				{include file="frontend/objects/issue_toc.tpl" heading="h3"}
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="mda_detox_button mda_detox_button_secondary read_more">
					{translate key="journal.viewAllIssues"}
				</a>
			</section>
		{/if}

	</div>
</div>

{include file="frontend/components/footer.tpl"}
