{**
 * plugins/themes/mdaDetox/templates/frontend/pages/navigationMenuItemViewContent.tpl
 *
 * Detox treatment for custom navigation-menu pages. The Editorial Team page
 * uses a dedicated layout; other custom pages share the generic Detox banner
 * and content-section layout.
 *}
{if $title !== 'Editorial Team'}
	{assign var="mdaDetoxCustomPage" value=true}
{/if}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

{if $title === 'Editorial Team'}
	<div class="page page_editorial_team mda_detox_editorial_team_page">
		<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxEditorialTeamTitle">
			<div class="mda_detox_page_banner_container">
				<h1 class="mda_detox_page_banner_title" id="mdaDetoxEditorialTeamTitle">{$title|escape}</h1>
				<nav class="mda_detox_breadcrumbs" role="navigation">
					<ol>
						<li>
							<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
						</li>
						<li aria-current="page">
							<span>{$title|escape}</span>
						</li>
					</ol>
				</nav>
			</div>
		</section>

		<section class="mda_detox_editorial_team_section">
			<div class="mda_detox_editorial_team_container">
				<div class="mda_detox_editorial_team_content">
					{$content}
				</div>
			</div>
		</section>
	</div>
{else}
	<div class="page mda_detox_custom_page">
		<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxCustomPageTitle">
			<div class="mda_detox_page_banner_container">
				<h1 class="mda_detox_page_banner_title" id="mdaDetoxCustomPageTitle">{$title|escape}</h1>
				<nav class="mda_detox_breadcrumbs" role="navigation">
					<ol>
						<li>
							<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
						</li>
						<li aria-current="page">
							<span>{$title|escape}</span>
						</li>
					</ol>
				</nav>
			</div>
		</section>

		<section class="mda_detox_custom_page_section">
			<div class="mda_detox_custom_page_container">
				<div class="mda_detox_custom_page_content">
					{$content}
				</div>
			</div>
		</section>
	</div>
{/if}

{include file="frontend/components/footer.tpl"}
