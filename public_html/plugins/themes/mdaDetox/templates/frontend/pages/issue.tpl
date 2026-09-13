{**
 * plugins/themes/mdaDetox/templates/frontend/pages/issue.tpl
 *
 * MDA Detox issue page using the same banner and content-section layout as
 * the Announcements page.
 *}
{capture assign="pageTitle"}
	{if !$issue}
		{translate key="current.noCurrentIssue"}
	{else}
		{$issueIdentification|escape}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

{capture assign="issueTitle"}{$pageTitle}{/capture}

<div class="page page_issue mda_detox_issue_page">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxIssueTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxIssueTitle">{$issueTitle}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{$issueTitle}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_issue_section">
		<div class="mda_detox_issue_container">
			{if !$issue}
				<p>{translate key="current.noCurrentIssueDesc"}</p>
			{else}
				{include file="frontend/objects/issue_toc.tpl"}
			{/if}
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
