#!/usr/bin/env php
<?php

/**
 * @file scripts/generate-sitemap.php
 *
 * Regenerates /home/mdaj/public_html/sitemap.xml for the MDA Journal OJS site.
 *
 * Run manually:  php /home/mdaj/scripts/generate-sitemap.php
 * Scheduled by:  /etc/cron.d/mdaj-sitemap (daily)
 *
 * The script reads the database directly rather than bootstrapping OJS, so it
 * stays cheap and cannot be affected by a broken plugin. It does not contain
 * credentials: they come from public_html/config.inc.php at runtime.
 *
 * Included: the journal home page, the core public pages, every custom
 * navigation page, internal navigation URLs, and published issues and articles.
 * Excluded: login, registration, password reset, search, the management backend
 * and OJS system paths — robots.txt or a noindex meta tag handles those.
 */

$root = '/home/mdaj/public_html';
$outputFile = $root . '/sitemap.xml';

$config = parse_ini_file($root . '/config.inc.php', true);
if ($config === false) {
    fwrite(STDERR, "Cannot read {$root}/config.inc.php\n");
    exit(1);
}

$dbConfig = $config['database'];
$baseUrl = rtrim($config['general']['base_url'] ?? 'https://mdajournal.com', '/');

mysqli_report(MYSQLI_REPORT_OFF);
$db = new mysqli($dbConfig['host'], $dbConfig['username'], $dbConfig['password'], $dbConfig['name']);
if ($db->connect_errno) {
    fwrite(STDERR, "Database connection failed: {$db->connect_error}\n");
    exit(1);
}
$db->set_charset('utf8mb4');

/** Fetch rows as an array of associative arrays. */
function query(mysqli $db, string $sql): array
{
    $result = $db->query($sql);
    if ($result === false) {
        fwrite(STDERR, "Query failed: {$db->error}\n");
        return [];
    }

    return $result->fetch_all(MYSQLI_ASSOC);
}

$journalPath = query($db, 'SELECT path FROM journals WHERE journal_id = 1')[0]['path'] ?? 'mdaj';
$prefix = $baseUrl . '/' . $journalPath;

/** @var array<string, array{0: string, 1: string}> $urls url => [priority, changefreq] */
$urls = [];

// Core public pages that always exist.
foreach ([
    ['', '1.0', 'weekly'],
    ['/about', '0.8', 'monthly'],
    ['/about/contact', '0.5', 'yearly'],
    ['/about/submissions', '0.9', 'monthly'],
    ['/about/privacy', '0.4', 'yearly'],
    ['/announcement', '0.7', 'weekly'],
    ['/issue/archive', '0.9', 'weekly'],
    ['/information/readers', '0.4', 'yearly'],
    ['/information/authors', '0.5', 'yearly'],
    ['/information/librarians', '0.4', 'yearly'],
] as [$path, $priority, $changefreq]) {
    $urls[$prefix . $path] = [$priority, $changefreq];
}

// Custom navigation pages (editorial team, policies, call for papers, ...).
$customPages = query(
    $db,
    "SELECT DISTINCT path FROM navigation_menu_items
     WHERE context_id = 1 AND type = 'NMI_TYPE_CUSTOM' AND path IS NOT NULL AND path <> ''"
);
foreach ($customPages as $row) {
    $path = '/' . trim($row['path'], '/');
    if ($path !== '/') {
        $urls[$prefix . $path] = ['0.7', 'monthly'];
    }
}

// Internal navigation URLs pointing back into this journal (fragments dropped).
$remoteUrls = query(
    $db,
    "SELECT s.setting_value AS url FROM navigation_menu_item_settings s
     JOIN navigation_menu_items i ON i.navigation_menu_item_id = s.navigation_menu_item_id
     WHERE i.context_id = 1 AND i.type = 'NMI_TYPE_REMOTE_URL'
       AND s.setting_name = 'remoteUrl' AND s.setting_value LIKE " . "'" . $db->real_escape_string($baseUrl) . "%'"
);
foreach ($remoteUrls as $row) {
    $url = strtok($row['url'], '#');
    if ($url !== false && str_starts_with($url, $prefix . '/') && !isset($urls[$url])) {
        $urls[$url] = ['0.6', 'monthly'];
    }
}

// Published issues.
$issues = query(
    $db,
    "SELECT i.issue_id, COALESCE(s.setting_value, '') AS url_path
     FROM issues i
     LEFT JOIN issue_settings s ON s.issue_id = i.issue_id AND s.setting_name = 'urlPath'
     WHERE i.journal_id = 1 AND i.published = 1"
);
foreach ($issues as $issue) {
    $id = $issue['url_path'] !== '' ? $issue['url_path'] : $issue['issue_id'];
    $urls[$prefix . '/issue/view/' . $id] = ['0.9', 'monthly'];
}

// Published articles, using the same "best id" rule as the templates.
$articles = query(
    $db,
    "SELECT s.submission_id, COALESCE(ps.setting_value, '') AS url_path
     FROM submissions s
     LEFT JOIN publications p ON p.publication_id = s.current_publication_id
     LEFT JOIN publication_settings ps ON ps.publication_id = p.publication_id AND ps.setting_name = 'urlPath'
     WHERE s.context_id = 1 AND s.status = 3"
);
foreach ($articles as $article) {
    $id = $article['url_path'] !== '' ? $article['url_path'] : $article['submission_id'];
    $urls[$prefix . '/article/view/' . $id] = ['0.8', 'monthly'];
}

ksort($urls);

$today = date('Y-m-d');
$xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    . "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
foreach ($urls as $url => [$priority, $changefreq]) {
    $xml .= "\t<url>\n"
        . "\t\t<loc>" . htmlspecialchars($url, ENT_XML1) . "</loc>\n"
        . "\t\t<lastmod>{$today}</lastmod>\n"
        . "\t\t<changefreq>{$changefreq}</changefreq>\n"
        . "\t\t<priority>{$priority}</priority>\n"
        . "\t</url>\n";
}
$xml .= "</urlset>\n";

if (file_put_contents($outputFile, $xml) === false) {
    fwrite(STDERR, "Cannot write {$outputFile}\n");
    exit(1);
}

echo count($urls) . " URLs written to {$outputFile}\n";
