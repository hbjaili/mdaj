{**
 * plugins/themes/mdaDetox/templates/frontend/pages/information.tpl
 *
 * MDA Detox information page using the same page banner,
 * breadcrumb, and content-section pattern as the About page.
 *}
{if !$contentOnly}
	{include file="frontend/components/header.tpl" pageTitle=$pageTitle}
{/if}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_information mda_detox_page_information">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxInformationTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxInformationTitle">{translate key=$pageTitle}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key=$pageTitle}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_information_page_section">
		<div class="mda_detox_information_page_container">
			<div class="mda_detox_information_page_content">
				<div class="mda_detox_information_page_text">
					{$content}
				</div>

				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}
			</div>
		</div>
	</section>
</div>

{if !$contentOnly}
	{include file="frontend/components/footer.tpl"}
{/if}
