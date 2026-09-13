<?php

/**
 * @file plugins/themes/mdaDetox/MdaDetoxThemePlugin.php
 *
 * MDA Detox Theme for OJS 3.5.
 */

namespace APP\plugins\themes\mdaDetox;

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
