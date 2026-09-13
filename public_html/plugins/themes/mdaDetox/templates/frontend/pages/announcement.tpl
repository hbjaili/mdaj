{**
 * plugins/themes/mdaDetox/templates/frontend/pages/announcement.tpl
 *
 * MDA Detox single announcement page using the same page banner,
 * breadcrumb, and content-section pattern as the About page.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedData('title')|escape}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
{capture assign="announcementsUrl"}{url page="announcement" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_announcement mda_detox_page_announcement">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxAnnouncementTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxAnnouncementTitle">{$announcement->getLocalizedData('title')|escape}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li>
						<a href="{$announcementsUrl}">{translate key="announcement.announcements"}</a>
					</li>
					<li aria-current="page">
						<span>{$announcement->getLocalizedData('title')|escape}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_announcement_page_section">
		<div class="mda_detox_announcement_page_container">
			<article class="mda_detox_announcement_full">
				<div class="mda_detox_announcement_date">
					{$announcement->datePosted|date_format:$dateFormatLong}
				</div>

				{if $announcement->image}
					<img
						class="mda_detox_announcement_image"
						src="{$announcement->imageUrl}"
						alt="{$announcement->imageAltText}"
					/>
				{/if}

				<div class="mda_detox_announcement_description">
					{if $announcement->getLocalizedData('description')}
						{$announcement->getLocalizedData('description')|strip_unsafe_html}
					{else}
						{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
					{/if}
				</div>
			</article>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
