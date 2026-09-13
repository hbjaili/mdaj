{**
 * plugins/themes/mdaDetox/templates/frontend/pages/about.tpl
 *
 * MDA Detox About page based on the Detox About Us layout:
 * a blue page-title banner with breadcrumbs followed by an
 * image-and-content section.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}

<div class="page page_about mda_detox_page_about">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxAboutTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxAboutTitle">{translate key="about.aboutContext"}</h1>

			{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="about.aboutContext"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_about_page_section">
		<div class="mda_detox_about_page_container">
			<div class="mda_detox_about_page_content">
				{if $currentContext->getLocalizedData('about')}
					<div class="mda_detox_about_page_text">
						{$currentContext->getLocalizedData('about')}
					</div>
				{/if}

				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
