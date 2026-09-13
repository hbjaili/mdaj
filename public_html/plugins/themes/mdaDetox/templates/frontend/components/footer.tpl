{**
 * plugins/themes/mdaDetox/templates/frontend/components/footer.tpl
 *
 * MDA Detox footer override based on the Detox reference footer structure.
 *}

	</div><!-- pkp_structure_main -->

	{* Sidebars *}
	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary">
				{$sidebarCode}
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

<section class="mda_detox_cta" aria-labelledby="mdaDetoxCtaTitle">
	<div class="mda_detox_cta_container">
		{capture assign="ctaInfoDefault"}{translate key="plugins.themes.mdaDetox.cta.title"}{/capture}
		{if $activeTheme && $activeTheme->getOption('mdaDetoxCtaInfo')}
			{assign var="ctaInfo" value=$activeTheme->getOption('mdaDetoxCtaInfo')}
		{else}
			{assign var="ctaInfo" value=$ctaInfoDefault}
		{/if}
		<h2 class="mda_detox_cta_title" id="mdaDetoxCtaTitle">{$ctaInfo|escape}</h2>
		<a class="mda_detox_cta_submit_link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">
			Make a Submission
		</a>
	</div>
</section>

<div class="pkp_structure_footer_wrapper mda_detox_footer_wrapper" role="contentinfo">
	<a id="pkp_content_footer"></a>

	{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

	<footer class="mda_detox_footer">
		<div class="mda_detox_footer_container">
			{if $currentContext}
				<div class="mda_detox_footer_top">
					<div class="mda_detox_footer_widgets">
						<div class="mda_detox_footer_column mda_detox_footer_brand">
							<a class="mda_detox_footer_logo" href="{$homeUrl}">
								{if $displayPageHeaderLogo}
									<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if}>
								{else}
									<span class="mda_detox_footer_logo_text">{$displayPageHeaderTitle|escape}</span>
								{/if}
							</a>
							{if $currentContext->getLocalizedData('description')}
								<div class="mda_detox_footer_text">
									{$currentContext->getLocalizedData('description')|strip_unsafe_html}
								</div>
							{/if}
						</div>

						<div class="mda_detox_footer_column">
							<h3 class="mda_detox_footer_title">{translate key="plugins.themes.mdaDetox.footer.quickLinks"}</h3>
							<ul>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="navigation.about"}</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}">{translate key="about.contact"}</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="about.submissions"}</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="navigation.archives"}</a></li>
								{if $enableAnnouncements}
									<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">{translate key="announcement.announcements"}</a></li>
								{/if}
							</ul>
						</div>

						<div class="mda_detox_footer_column">
							<h3 class="mda_detox_footer_title">Policies &amp; Team</h3>
							<ul>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">Author Guidelines</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="review-process"}">Peer Review Process</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="charges"}">Article Processing Charges</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="plagiarism-policy"}">Plagiarism Policy</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="open-access"}">Open Access Policy</a></li>
								<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="editorial-team"}">Editorial Team</a></li>
							</ul>
						</div>

						<div class="mda_detox_footer_column mda_detox_footer_contact">
							<h3 class="mda_detox_footer_title">{translate key="plugins.themes.mdaDetox.footer.contact"}</h3>
							<ul>
								{if $currentContext->getData('mailingAddress')}
									<li>{$currentContext->getData('mailingAddress')|nl2br|strip_unsafe_html}</li>
								{/if}
								{if $currentContext->getData('contactPhone')}
									<li><a href="tel:{$currentContext->getData('contactPhone')|escape}">{$currentContext->getData('contactPhone')|escape}</a></li>
								{/if}
								{if $currentContext->getData('contactEmail')}
									<li><a href="mailto:{$currentContext->getData('contactEmail')|escape}">{$currentContext->getData('contactEmail')|escape}</a></li>
								{/if}
							</ul>
						</div>
					</div>
				</div>
			{/if}

			<div class="mda_detox_footer_bottom">
				<div class="mda_detox_footer_bottom_start">
					{if $pageFooter}
						{capture assign="footerYear"}{$smarty.now|date_format:"Y"}{/capture}
						<div class="mda_detox_footer_copyright">
							{$pageFooter|regex_replace:"/20[0-9][0-9]/":$footerYear}
						</div>
					{/if}
					{if $currentContext}
						<div class="mda_detox_footer_badges">
							<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="open-access"}" title="Open Access">
								<img src="{$baseUrl}/plugins/themes/mdaDetox/images/open-access.svg" alt="Open Access">
							</a>
							<a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" rel="license noopener" title="Creative Commons Attribution 4.0 International">
								<img src="{$baseUrl}/plugins/themes/mdaDetox/images/ccby.svg" alt="Creative Commons Attribution 4.0 International">
							</a>
						</div>
					{/if}
				</div>
				{if $currentContext}
					<ul class="mda_detox_footer_nav">
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="navigation.about"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}">{translate key="about.contact"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}">{translate key="about.privacyStatement"}</a></li>
					</ul>
				{/if}
			</div>
		</div>
	</footer>
</div><!-- pkp_structure_footer_wrapper -->

<button class="mda_detox_scroll_top" type="button" aria-label="{translate key="plugins.themes.mdaDetox.scrollTop"}">
	<span class="fa fa-arrow-up" aria-hidden="true"></span>
</button>

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
