{**
 * plugins/themes/mdaDetox/templates/frontend/pages/announcements.tpl
 *
 * MDA Detox Announcements page based on the Editorial Team page layout:
 * a blue page-title banner with breadcrumbs followed by a white
 * content section containing the announcements introduction and list.
 *}
{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_announcements mda_detox_announcements_page">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxAnnouncementsTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxAnnouncementsTitle">{translate key="announcement.announcements"}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="announcement.announcements"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_announcements_section">
		<div class="mda_detox_announcements_container">
			{if $announcementsIntroduction}
				<div class="mda_detox_announcements_intro">
					{$announcementsIntroduction}
				</div>
			{/if}

			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}

			{include file="frontend/components/announcements.tpl"}
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
