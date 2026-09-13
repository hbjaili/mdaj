{**
 * plugins/themes/mdaDetox/templates/frontend/pages/message.tpl
 *
 * Generic MDA Detox message page using the same page banner,
 * breadcrumb, and content-section pattern as the other Detox pages.
 *}
{assign var="mdaDetoxCustomPage" value=true}
{if $pageTitle}
	{include file="frontend/components/header.tpl" pageTitle=$pageTitle}
{else}
	{include file="frontend/components/header.tpl"}
{/if}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_message mda_detox_custom_page">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxMessageTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxMessageTitle">
				{if $pageTitle}
					{translate key=$pageTitle}
				{else}
					{translate key="common.notice"}
				{/if}
			</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>
							{if $pageTitle}
								{translate key=$pageTitle}
							{else}
								{translate key="common.notice"}
							{/if}
						</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_custom_page_section">
		<div class="mda_detox_custom_page_container">
			<div class="mda_detox_custom_page_content mda_detox_message_page_content">
				<div class="mda_detox_message_text">
					{if $messageTranslated}
						{$messageTranslated}
					{else}
						{translate key=$message}
					{/if}
				</div>

				{if $backLink}
					<div class="mda_detox_message_back_link">
						<a href="{$backLink|escape}" class="mda_detox_message_button">
							{translate key=$backLinkLabel}
						</a>
					</div>
				{/if}
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
