{**
 * plugins/themes/mdaDetox/templates/frontend/pages/userLogin.tpl
 *
 * MDA Detox login page using the same page banner, breadcrumb,
 * and content-section pattern as the About and Submissions pages.
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

<div class="page page_login mda_detox_page_login">
	<section class="mda_detox_page_banner" aria-labelledby="mdaDetoxLoginTitle">
		<div class="mda_detox_page_banner_container">
			<h1 class="mda_detox_page_banner_title" id="mdaDetoxLoginTitle">{translate key="user.login"}</h1>

			<nav class="mda_detox_breadcrumbs" role="navigation">
				<ol>
					<li>
						<a href="{$homeUrl}">{translate key="common.homepageNavigationLabel"}</a>
					</li>
					<li aria-current="page">
						<span>{translate key="user.login"}</span>
					</li>
				</ol>
			</nav>
		</div>
	</section>

	<section class="mda_detox_login_page_section">
		<div class="mda_detox_login_page_container">
			<div class="mda_detox_login_page_content">
				<p class="mda_detox_login_required">
					{translate key="common.requiredField"}
				</p>

				{if $loginMessage}
					<p class="mda_detox_login_message">
						{translate key=$loginMessage}
					</p>
				{/if}

				<form class="cmp_form cmp_form login mda_detox_login_form" id="login" method="post" action="{$loginUrl}" role="form">
					{csrf}

					{if $error}
						<div class="pkp_form_error">
							{translate key=$error reason=$reason}
						</div>
					{/if}

					<input type="hidden" name="source" value="{$source|default:""|escape}" />

					<fieldset class="fields">
						<legend class="pkp_screen_reader">{translate key="user.login"}</legend>

						<div class="username">
							<label>
								<span class="label">
									{translate key="user.usernameOrEmail"}
									<span class="required" aria-hidden="true">*</span>
									<span class="pkp_screen_reader">
										{translate key="common.required"}
									</span>
								</span>
								<input type="text" name="username" id="username" value="{$username|default:""|escape}" required aria-required="true" autocomplete="username">
							</label>
						</div>

						<div class="password">
							<label>
								<span class="label">
									{translate key="user.password"}
									<span class="required" aria-hidden="true">*</span>
									<span class="pkp_screen_reader">
										{translate key="common.required"}
									</span>
								</span>
								<input type="password" name="password" id="password" value="{$password|default:""|escape}" password="true" maxlength="32" required aria-required="true" autocomplete="current-password">
								<a href="{url page="login" op="lostPassword"}">
									{translate key="user.login.forgotPassword"}
								</a>
							</label>
						</div>

						<div class="remember checkbox">
							<label>
								<input type="checkbox" name="remember" id="remember" value="1" checked="$remember">
								<span class="label">
									{translate key="user.login.rememberUsernameAndPassword"}
								</span>
							</label>
						</div>

						{if $recaptchaPublicKey}
							<fieldset class="recaptcha_wrapper">
								<div class="fields">
									<div class="recaptcha">
										<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey|escape}">
										</div><label for="g-recaptcha-response" style="display:none;" hidden>Recaptcha response</label>
									</div>
								</div>
							</fieldset>
						{/if}

						{if $altchaEnabled}
							<fieldset class="altcha_wrapper">
								<div class="fields">
									<altcha-widget challengejson='{$altchaChallenge|@json_encode}'></altcha-widget>
								</div>
							</fieldset>
						{/if}

						<div class="buttons">
							<button class="submit" type="submit">
								{translate key="user.login"}
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
