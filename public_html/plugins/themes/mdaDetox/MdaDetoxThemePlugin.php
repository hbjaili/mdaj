<?php

/**
 * @file plugins/themes/mdaDetox/MdaDetoxThemePlugin.php
 *
 * MDA Detox Theme for OJS 3.5.
 */

namespace APP\plugins\themes\mdaDetox;

use APP\core\Application;
use PKP\core\PKPPageRouter;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;

class MdaDetoxThemePlugin extends ThemePlugin
{
    private const DEFAULT_PRIMARY_COLOUR = '#6377EE';

    /**
     * Register the parent theme, options, and assets.
     */
    public function init(): void
    {
        $this->setParent('defaultthemeplugin');

        $this->addOption('mdaDetoxPrimaryColour', 'FieldColor', [
            'label' => __('plugins.themes.mdaDetox.option.primaryColour.label'),
            'description' => __('plugins.themes.mdaDetox.option.primaryColour.description'),
            'default' => self::DEFAULT_PRIMARY_COLOUR,
        ]);

        $this->addOption('mdaDetoxCtaInfo', 'FieldText', [
            'label' => __('plugins.themes.mdaDetox.option.ctaInfo.label'),
            'description' => __('plugins.themes.mdaDetox.option.ctaInfo.description'),
            'size' => 'large',
            'default' => __('plugins.themes.mdaDetox.cta.title'),
        ]);

        $primaryColour = $this->getOption('mdaDetoxPrimaryColour') ?: self::DEFAULT_PRIMARY_COLOUR;
        if (!preg_match('/^#[0-9a-fA-F]{6}$/', $primaryColour)) {
            $primaryColour = self::DEFAULT_PRIMARY_COLOUR;
        }

        $this->addStyle(
            'mda-detox-fonts',
            'https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Roboto:wght@300;400;500;700&display=swap',
            ['baseUrl' => '']
        );

        $this->modifyStyle('stylesheet', [
            'addLess' => ['styles/index.less'],
            'addLessVariables' => '@mda-detox-primary: ' . $primaryColour . ';',
        ]);

        $this->addScript('mda-detox-theme', 'js/main.js');

        Hook::add('TemplateManager::display', $this->addSeoHeaders(...));
    }

    /**
     * Register search-engine head tags that OJS 3.5 does not emit itself.
     *
     * - A self-referencing canonical link on journal pages, built through the
     *   router so it always resolves to the clean RESTful URL even when the page
     *   was requested as /index.php/....
     * - noindex on utility pages (login, registration, password reset, search),
     *   which should never compete with the journal's content in search results.
     */
    public function addSeoHeaders(string $hookName, array $args): bool
    {
        $templateMgr = $args[0] ?? null;
        $request = Application::get()->getRequest();

        if (!$templateMgr || !$request || !$request->getContext()) {
            return false;
        }

        $router = $request->getRouter();
        if (!$router instanceof PKPPageRouter) {
            return false;
        }

        $page = $router->getRequestedPage($request);

        if (in_array($page, ['login', 'user', 'search'], true)) {
            $templateMgr->addHeader(
                'mdaDetoxRobots',
                '<meta name="robots" content="noindex, follow" />'
            );

            return false;
        }

        $op = $router->getRequestedOp($request);
        $path = $router->getRequestedArgs($request);

        // The index operation is implicit: dropping it keeps the canonical on the
        // short form (/mdaj/about) instead of /mdaj/about/index.
        if ($op === 'index') {
            $op = null;
        }

        // The journal home page is the context root, not /mdaj/index.
        $url = ($page === '' || $page === null) && empty($path)
            ? $router->url($request, null, null, null)
            : $router->url($request, null, $page, $op, $path);

        if ($url) {
            $templateMgr->addHeader(
                'mdaDetoxCanonical',
                '<link rel="canonical" href="' . htmlspecialchars($url, ENT_QUOTES) . '" />'
            );
        }

        return false;
    }

    public function getDisplayName(): string
    {
        return __('plugins.themes.mdaDetox.name');
    }

    public function getDescription(): string
    {
        return __('plugins.themes.mdaDetox.description');
    }

    /**
     * Reject malformed colour values before storing the option.
     */
    public function saveOption($name, $value, $contextId = null): void
    {
        if ($name === 'mdaDetoxPrimaryColour' && !preg_match('/^#[0-9a-fA-F]{6}$/', (string) $value)) {
            $value = self::DEFAULT_PRIMARY_COLOUR;
        }

        parent::saveOption($name, $value, $contextId);
    }
}
