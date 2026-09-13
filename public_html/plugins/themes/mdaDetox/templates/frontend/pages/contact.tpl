{**
 * plugins/themes/mdaDetox/templates/frontend/pages/contact.tpl
 *
 * MDA Detox Contact page using the same page banner,
 * breadcrumb, and content-section pattern as the About and
 * Submissions pages.
 *
 * @uses $currentContext Journal|Press The current journal or press
 * @uses $mailingAddress string Mailing address for the journal/press
 * @uses $contactName string Primary contact name
 * @uses $contactTitle string Primary contact title
 * @uses $contactAffiliation string Primary contact affiliation
 * @uses $contactPhone string Primary contact phone number
 * @uses $contactEmail string Primary contact email address
 * @uses $supportName string Support contact name
 * @uses $supportPhone string Support contact phone number
 * @uses $supportEmail string Support contact email address
 *}
{include file="frontend/components/header.tpl" pageTitle="about.contact"}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_contact mda_detox_page_contact">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxContactTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxContactTitle">{translate key="about.contact"}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="about.contact"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_contact_page_section">
		<div class="mda_detox_contact_page_container">
			<div class="mda_detox_contact_page_content">
				<div class="mda_detox_contact_grid">
					{if $mailingAddress}
						<section class="mda_detox_contact_card mda_detox_contact_card_address">
							<h2>{translate key="common.mailingAddress"}</h2>
							<div class="mda_detox_contact_card_body mda_detox_contact_address">
								{$mailingAddress|nl2br|strip_unsafe_html}
							</div>
						</section>
					{/if}

					{if $contactName || $contactTitle || $contactAffiliation || $contactPhone || $contactEmail}
						<section class="mda_detox_contact_card">
							<h2>{translate key="about.contact.principalContact"}</h2>
							<div class="mda_detox_contact_card_body">
								{if $contactName}
									<div class="mda_detox_contact_name">{$contactName|escape}</div>
								{/if}

								{if $contactTitle}
									<div class="mda_detox_contact_title">{$contactTitle|escape}</div>
								{/if}

								{if $contactAffiliation}
									<div class="mda_detox_contact_affiliation">{$contactAffiliation|strip_unsafe_html}</div>
								{/if}

								{if $contactPhone}
									<div class="mda_detox_contact_detail">
										<span class="mda_detox_contact_label">{translate key="about.contact.phone"}</span>
										<span class="mda_detox_contact_value">
											<a href="tel:{$contactPhone|escape}">{$contactPhone|escape}</a>
										</span>
									</div>
								{/if}

								{if $contactEmail}
									<div class="mda_detox_contact_detail">
										<span class="mda_detox_contact_label">{translate key="about.contact.email"}</span>
										<span class="mda_detox_contact_value">
											<a href="mailto:{$contactEmail|escape}">{$contactEmail|escape}</a>
										</span>
									</div>
								{/if}
							</div>
						</section>
					{/if}

					{if $supportName || $supportPhone || $supportEmail}
						<section class="mda_detox_contact_card">
							<h2>{translate key="about.contact.supportContact"}</h2>
							<div class="mda_detox_contact_card_body">
								{if $supportName}
									<div class="mda_detox_contact_name">{$supportName|escape}</div>
								{/if}

								{if $supportPhone}
									<div class="mda_detox_contact_detail">
										<span class="mda_detox_contact_label">{translate key="about.contact.phone"}</span>
										<span class="mda_detox_contact_value">
											<a href="tel:{$supportPhone|escape}">{$supportPhone|escape}</a>
										</span>
									</div>
								{/if}

								{if $supportEmail}
									<div class="mda_detox_contact_detail">
										<span class="mda_detox_contact_label">{translate key="about.contact.email"}</span>
										<span class="mda_detox_contact_value">
											<a href="mailto:{$supportEmail|escape}">{$supportEmail|escape}</a>
										</span>
									</div>
								{/if}
							</div>
						</section>
					{/if}
				</div>

				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
