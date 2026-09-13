{**
 * plugins/themes/mdaDetox/templates/frontend/pages/submissions.tpl
 *
 * MDA Detox Submissions page using the same page banner,
 * breadcrumb, and content-section pattern as the About page.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_submissions mda_detox_page_submissions">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxSubmissionsTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxSubmissionsTitle">{translate key="about.submissions"}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="about.submissions"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_submissions_page_section">
		<div class="mda_detox_submissions_page_container">
			<div class="mda_detox_submissions_content">
				{if $sections|@count == 0 || $currentContext->getData('disableSubmissions')}
					<div class="cmp_notification mda_detox_submissions_notice">
						{translate key="author.submit.notAccepting"}
					</div>
				{elseif $isUserLoggedIn}
					{capture assign="newSubmission"}<a href="{url page="submission"}">{translate key="about.onlineSubmissions.newSubmission"}</a>{/capture}
					{capture assign="viewSubmissions"}<a href="{url page="submissions"}">{translate key="about.onlineSubmissions.viewSubmissions"}</a>{/capture}
					<div class="cmp_notification mda_detox_submissions_notice">
						{translate key="about.onlineSubmissions.submissionActions" newSubmission=$newSubmission viewSubmissions=$viewSubmissions}
					</div>
				{else}
					{capture assign="contactName"}{$currentContext->getData('contactName')|escape}{/capture}
					{capture assign="contactEmail"}{$currentContext->getData('contactEmail')|escape}{/capture}
					<div class="cmp_notification mda_detox_submissions_notice">
						<p>MDA Journal uses a contact-first submission process. Before submitting online, email a short proposal describing your manuscript to {if $contactName}{$contactName} at {/if}{if $contactEmail}<a href="mailto:{$contactEmail}">{$contactEmail}</a>{/if}.</p>
						<p>The editorial office will review your proposal and create an author account for you. Once your account is ready, <a href="{url page="login"}">{translate key="about.onlineSubmissions.login"}</a> and complete the online submission wizard.</p>
					</div>
				{/if}

				{if $currentContext->getLocalizedData('authorGuidelines')}
					<section class="mda_detox_submissions_block" id="authorGuidelines">
						<h2>
							{translate key="about.authorGuidelines"}
							{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.authorGuidelines"}
						</h2>
						<div class="mda_detox_submissions_block_content">
							{$currentContext->getLocalizedData('authorGuidelines')}
						</div>
					</section>
				{/if}

				{if $submissionChecklist}
					<section class="mda_detox_submissions_block">
						<h2>
							{translate key="about.submissionPreparationChecklist"}
							{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.submissionPreparationChecklist"}
						</h2>
						<div class="mda_detox_submissions_block_content">
							{$submissionChecklist}
						</div>
					</section>
				{/if}

				{if isset($submissionChecklistAfterContent)}
					{$submissionChecklistAfterContent}
				{/if}

				{foreach from=$sections item="section"}
					{if $section->getLocalizedPolicy()}
						<section class="mda_detox_submissions_block">
							<h2>{$section->getLocalizedTitle()|escape}</h2>
							<div class="mda_detox_submissions_block_content">
								{$section->getLocalizedPolicy()}
								{if $isUserLoggedIn}
									{capture assign="sectionSubmissionUrl"}{url page="submission" op="wizard" sectionId=$section->getId()}{/capture}
									<p>
										{translate key="about.onlineSubmissions.submitToSection" name=$section->getLocalizedTitle() url=$sectionSubmissionUrl}
									</p>
								{/if}
							</div>
						</section>
					{/if}
				{/foreach}

				{if $currentContext->getLocalizedData('copyrightNotice')}
					<section class="mda_detox_submissions_block">
						<h2>
							{translate key="about.copyrightNotice"}
							{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/authorGuidelines" sectionTitleKey="about.copyrightNotice"}
						</h2>
						<div class="mda_detox_submissions_block_content">
							{$currentContext->getLocalizedData('copyrightNotice')}
						</div>
					</section>
				{/if}

				{if $currentContext->getLocalizedData('privacyStatement')}
					<section class="mda_detox_submissions_block" id="privacyStatement">
						<h2>
							{translate key="about.privacyStatement"}
							{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/privacy" sectionTitleKey="about.privacyStatement"}
						</h2>
						<div class="mda_detox_submissions_block_content">
							{$currentContext->getLocalizedData('privacyStatement')}
						</div>
					</section>
				{/if}
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
