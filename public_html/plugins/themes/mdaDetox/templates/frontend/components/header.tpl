{**
 * MDA Detox frontend header.
 * Preserves OJS menus and accessibility hooks in a Detox-style structure.
 *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}{if $mdaDetoxCustomPage} mda_detox_custom_page_body{/if} mda_detox_body" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page mda_detox_page">
		<header class="pkp_structure_head mda_detox_header" id="headerNavigationContainer" role="banner">
			{include file="frontend/components/skipLinks.tpl"}

			{if $currentContext && ($currentContext->getData('onlineIssn') || $currentContext->getData('printIssn'))}
				<div class="mda_detox_header_topbar" aria-label="{translate|escape key="manager.setup.onlineIssn"} / {translate|escape key="manager.setup.printIssn"}">
					<div class="mda_detox_header_topbar_inner">
						{if $currentContext->getData('onlineIssn')}
							<span class="mda_detox_header_topbar_item">
								<span class="mda_detox_header_topbar_label">{translate key="manager.setup.onlineIssn"}</span>
								<span class="mda_detox_header_topbar_value">{$currentContext->getData('onlineIssn')|escape}</span>
							</span>
						{/if}
						{if $currentContext->getData('printIssn')}
							<span class="mda_detox_header_topbar_item">
								<span class="mda_detox_header_topbar_label">{translate key="manager.setup.printIssn"}</span>
								<span class="mda_detox_header_topbar_value">{$currentContext->getData('printIssn')|escape}</span>
							</span>
						{/if}
					</div>
				</div>
			{/if}

			<div class="mda_detox_header_inner">
				<div class="pkp_site_name_wrapper mda_detox_brand">
					<button class="pkp_site_nav_toggle mda_detox_nav_toggle" type="button" aria-controls="siteNav" aria-label="{translate|escape key="common.navigation.site"}">
						<span>{translate key="common.navigation.site"}</span>
					</button>

					{if !$requestedPage || $requestedPage === 'index'}
						<h1 class="pkp_screen_reader">
							{if $currentContext}{$displayPageHeaderTitle|escape}{else}{$siteTitle|escape}{/if}
						</h1>
					{/if}

					<div class="pkp_site_name mda_detox_site_name">
						{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
						{if $displayPageHeaderLogo}
							<a href="{$homeUrl}" class="is_img">
								<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}"{if $displayPageHeaderLogo.altText != ''} alt="{$displayPageHeaderLogo.altText|escape}"{/if}>
							</a>
						{elseif $displayPageHeaderTitle}
							<a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle|escape}</a>
						{else}
							<a href="{$homeUrl}" class="is_text">{$applicationName|escape}</a>
						{/if}
					</div>
				</div>

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu mda_detox_navigation" id="siteNav" aria-label="{translate|escape key="common.navigation.site"}">
					<div class="pkp_navigation_primary_row mda_detox_primary_row">
						<div class="pkp_navigation_primary_wrapper mda_detox_primary_wrapper">
							{$primaryMenu}
						</div>
					</div>

					<div class="mda_detox_header_actions">
						{if $currentContext && $requestedPage !== 'search'}
							<div class="pkp_navigation_search_wrapper mda_detox_search">
								<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
									<span class="fa fa-search" aria-hidden="true"></span>
									<span class="pkp_screen_reader">{translate key="common.search"}</span>
								</a>
							</div>
						{/if}
						<div class="pkp_navigation_user_wrapper mda_detox_user" id="navigationUserWrapper">
							{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
						</div>
					</div>
				</nav>
			</div>
		</header>

		{if $isFullWidth}{assign var=hasSidebar value=0}{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if} mda_detox_content">
			<div class="pkp_structure_main mda_detox_main" role="main">
				<a id="pkp_content_main"></a>
