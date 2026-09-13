{**
 * plugins/themes/mdaDetox/templates/frontend/pages/privacy.tpl
 *
 * Detox Privacy page using the same banner and simple-content layout
 * as the Editorial Team page.
 *}
{include file="frontend/components/header.tpl" pageTitle="manager.setup.privacyStatement"}

<div class="page page_privacy mda_detox_privacy_page">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxPrivacyTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxPrivacyTitle">{translate key="manager.setup.privacyStatement"}</h1>

			{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="manager.setup.privacyStatement"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_privacy_section">
		<div class="mda_detox_privacy_container">
			<div class="mda_detox_privacy_text">
				{$privacyStatement}
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
