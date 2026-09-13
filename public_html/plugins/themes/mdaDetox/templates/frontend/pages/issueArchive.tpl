{**
 * plugins/themes/mdaDetox/templates/frontend/pages/issueArchive.tpl
 *
 * MDA Detox issue archive page using the same banner and content-section
 * layout as the Announcements page.
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_issue_archive mda_detox_issue_archive_page">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxIssueArchiveTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxIssueArchiveTitle">{$pageTitle|escape}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{$pageTitle|escape}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_issue_archive_section">
		<div class="mda_detox_issue_archive_container">
			{if empty($issues)}
				<p>{translate key="current.noCurrentIssueDesc"}</p>
			{else}
				<ul class="issues_archive">
					{foreach from=$issues item="issue"}
						<li>
							{include file="frontend/objects/issue_summary.tpl"}
						</li>
					{/foreach}
				</ul>

				{if $prevPage > 1}
					{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
				{elseif $prevPage === 1}
					{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}{/capture}
				{/if}
				{if $nextPage}
					{capture assign=nextUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
				{/if}
				{include
					file="frontend/components/pagination.tpl"
					prevUrl=$prevUrl
					nextUrl=$nextUrl
					showingStart=$showingStart
					showingEnd=$showingEnd
					total=$total
				}
			{/if}
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
