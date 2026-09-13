{**
 * plugins/themes/mdaDetox/templates/frontend/pages/userLostPassword.tpl
 *
 * MDA Detox lost-password page using the same page banner,
 * breadcrumb, and content-section pattern as the login page.
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_lost_password mda_detox_page_login">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxLostPasswordTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxLostPasswordTitle">{translate key="user.login.resetPassword"}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="user.login.resetPassword"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_login_page_section">
		<div class="mda_detox_login_page_container">
			<div class="mda_detox_login_page_content">
				<p class="mda_detox_login_required">
					{translate key="user.login.resetPasswordInstructions"}
				</p>

				<form class="cmp_form lost_password mda_detox_login_form" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post" role="form">
					{csrf}

					{if $error}
						<div class="pkp_form_error">
							{translate key=$error reason=$reason}
						</div>
					{/if}

					<fieldset class="fields">
						<div class="email">
							<label>
								<span class="label">
									{translate key="user.login.registeredEmail"}
									<span class="required" aria-hidden="true">*</span>
									<span class="pkp_screen_reader">
										{translate key="common.required"}
									</span>
								</span>
								<input type="email" name="email" id="email" value="{$email|escape}" required aria-required="true" autocomplete="email">
							</label>
						</div>

						{if $altchaEnabled}
							<fieldset class="altcha_wrapper">
								<div class="fields">
									<altcha-widget challengejson='{$altchaChallenge|@json_encode}'></altcha-widget>
								</div>
							</fieldset>
						{/if}

						<div class="buttons">
							<button class="submit" type="submit">
								{translate key="user.login.resetPassword"}
							</button>

							{if !$disableUserReg}
								{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
								<a href="{$registerUrl}" class="register">
									{translate key="user.login.registerNewAccount"}
								</a>
							{/if}
						</div>
					</fieldset>
				</form>
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
