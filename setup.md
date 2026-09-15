# MDA Journal — New Server Setup

**Target URI:** `https://mdaj.softrivahost.com`

**Purpose:** a dedicated, single-journal server running the MDA Journal OJS
installation. No other sites or services should live on this box.

**Stack:** Ubuntu 24.04 LTS, Apache 2.4, PHP 8.3, MariaDB 10.11. This mirrors
the current production stack so the migrated journal keeps working the same way.

**Conventions:**

- Run everything as a non-root `mdaj` user; use `sudo` for privileged commands.
- Placeholders such as `<DB_PASSWORD>` mean "fill in from the current
  `config.inc.php` or from a freshly generated secret". Do not write real
  passwords, salts, keys, or SMTP credentials into this file.
- The journal keeps its existing `/mdaj` path, so it is served at
  `https://mdaj.softrivahost.com/mdaj/`. This matches the current production
  URL layout and avoids changing stored URLs, redirects, or the sitemap
  generator.

---

## 0. Server plan

Order the **4 GB KVM VPS** from RackNerd:

| Resource | Spec |
| --- | --- |
| vCPU | 3 cores |
| RAM | 4 GB |
| SSD | 60 GB |
| Transfer | 7 TB/month |
| Network | 1 Gbps |
| IPv4 | 1 address |
| OS | Ubuntu 24.04 LTS |

This matches the current journal server's capacity and leaves headroom for
MariaDB, PHP workers, backups, and future growth. Choose the datacenter closest
to the journal's primary readers.

---

## 1. DNS prerequisite

Before configuring Apache or Let's Encrypt, create these records in the
softrivahost DNS panel:

| Type | Name | Value |
| --- | --- | --- |
| A | `mdaj` | `<SERVER_IP>` |
| AAAA | `mdaj` | `<SERVER_IPV6>` (only if IPv6 is available) |

Wait for the record to resolve:

```bash
dig +short mdaj.softrivahost.com A
```

Do not point `mdajournal.com` at this server yet. Finish this runbook and verify
the journal on `mdaj.softrivahost.com` first, then schedule the public-domain
cutover separately.

---

## 2. Base operating system

Log in as root, then:

```bash
apt update && apt full-upgrade -y
```

Set the machine hostname:

```bash
hostnamectl set-hostname mdaj.softrivahost.com
```

RackNerd VPSes usually ship without swap. Add a small swap file so MariaDB and
Apache have headroom under brief memory spikes:

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

Create the service account and grant it passwordless `sudo`:

```bash
adduser --disabled-password --gecos "MDA Journal" mdaj
usermod -aG sudo mdaj
```

Change SSH from port 22 to 5716 before enabling the firewall, so the UFW rule
and the daemon match. Keep your current SSH session open while doing this:

```bash
sudo sed -i 's/^#\?Port 22/Port 5716/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

If the file uses a different or duplicate `Port` line, edit
`/etc/ssh/sshd_config` manually and set exactly one `Port 5716` line. Open a
second SSH session with the new port and confirm it works before closing the
original connection:

```bash
ssh -p 5716 mdaj@mdaj.softrivahost.com
```

Configure the firewall to allow only SSH, HTTP, and HTTPS:

```bash
ufw allow 5716/tcp comment 'SSH'
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

Enable automatic security updates:

```bash
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

Log in as `mdaj` for the rest of the steps.

---

## 3. Install the LAMP stack

```bash
sudo apt update
sudo apt install -y \
  apache2 \
  mariadb-server \
  php8.3 \
  php8.3-cli \
  php8.3-mysql \
  php8.3-gd \
  php8.3-xml \
  php8.3-mbstring \
  php8.3-intl \
  php8.3-curl \
  php8.3-zip \
  php8.3-bcmath \
  libapache2-mod-php8.3 \
  certbot \
  python3-certbot-apache \
  curl \
  unzip
```

Install `composer` and Node.js only if you need to rebuild theme/plugin assets.
They are not required to run the already-built OJS distribution:

```bash
sudo apt install -y composer nodejs npm
```

Enable the Apache modules OJS needs:

```bash
sudo a2enmod rewrite ssl headers
sudo systemctl restart apache2
```

Raise the PHP upload limits to a sensible journal size and add headroom for
large editorial forms:

```bash
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 20M/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 20M/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/^max_input_vars = .*/max_input_vars = 5000/' /etc/php/8.3/apache2/php.ini
sudo systemctl restart apache2
```

Adjust `20M` to the largest manuscript PDF you expect to accept; the two limits
should stay equal or `post_max_size` should be slightly larger.

Secure MariaDB:

```bash
sudo mysql_secure_installation
```

Use socket authentication for root and set a strong root password.

---

## 4. Create the database and user

Open a MariaDB root shell:

```bash
sudo mysql
```

Create the database and application user. Match the current install's names
(`mdaj_ojsdb` and `mdaj_usr`) to keep the migration simple:

```sql
CREATE DATABASE mdaj_ojsdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mdaj_usr'@'localhost' IDENTIFIED BY '<DB_PASSWORD>';
GRANT ALL PRIVILEGES ON mdaj_ojsdb.* TO 'mdaj_usr'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Never reuse the current production database password here verbatim in the
runbook; store the actual password in the server's config file and a password
manager.

---

## 5. Transfer the journal code and files

There are two acceptable paths. Use the migration path (A) when the current
server is still available; use the fresh-install path (B) only when it is not.

### A. Migrate from the current server

On the **old** server, create a database dump:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  -u mdaj_usr -p mdaj_ojsdb > /home/mdaj/mdaj_ojsdb.sql
```

On the **new** server, pull the files and the dump. Adjust the source host and
key path to match your old server:

```bash
sudo mkdir -p /home/mdaj
sudo chown mdaj:mdaj /home/mdaj

rsync -av --delete \
  -e "ssh" \
  mdaj@<OLD_SERVER_IP>:/home/mdaj/public_html/ \
  /home/mdaj/public_html/

rsync -av --delete \
  -e "ssh" \
  mdaj@<OLD_SERVER_IP>:/home/mdaj/files/ \
  /home/mdaj/files/

rsync -av \
  -e "ssh" \
  mdaj@<OLD_SERVER_IP>:/home/mdaj/scripts/ \
  /home/mdaj/scripts/

rsync -av \
  -e "ssh" \
  mdaj@<OLD_SERVER_IP>:/home/mdaj/mdaj_ojsdb.sql \
  /home/mdaj/mdaj_ojsdb.sql
```

Restore the database on the new server:

```bash
sudo mysql mdaj_ojsdb < /home/mdaj/mdaj_ojsdb.sql
```

### B. Fresh OJS install with a restored database

Download OJS **3.5.0.5** from the official release, then restore the database
dump as above:

```bash
cd /home/mdaj
wget https://pkp.sfu.ca/ojs/download/ojs-3.5.0-5.tar.gz
tar -xzf ojs-3.5.0-5.tar.gz
sudo mv ojs-3.5.0-5 public_html
```

After restoring the database, copy the migrated `config.inc.php` into
`public_html/` and adjust it as described in the next section. If you are doing
a truly fresh install instead, remove `installed = On` from `config.inc.php`
and complete the browser installer.

In both cases, ensure OJS's shipped `.htaccess` is present:

```bash
ls -la /home/mdaj/public_html/.htaccess
```

---

## 6. Configure `config.inc.php`

Open `/home/mdaj/public_html/config.inc.php` and set or verify these values.
Keep the existing `salt`, `app_key`, `api_key_secret`, and `altcha_hmackey`
from the migrated install so sessions, invitations, and ALTCHA keep working.

```ini
[general]
base_url = "https://mdaj.softrivahost.com"
allowed_hosts = '["mdaj.softrivahost.com", "mdajournal.com"]'
restful_urls = On
installed = On
time_zone = America/New_York

[database]
driver = mysqli
host = localhost
username = mdaj_usr
password = "<DB_PASSWORD>"
name = mdaj_ojsdb

[files]
files_dir = /home/mdaj/files
public_files_dir = public

[security]
force_ssl = On
force_login_ssl = On
encryption = bcrypt

[email]
default = smtp
smtp_server = smtp.purelymail.com
smtp_port = 587
smtp_auth = tls
smtp_username = noreply@mdajournal.com
smtp_password = "<SMTP_PASSWORD>"
default_envelope_sender = eic@mdajournal.com
force_default_envelope_sender = On
force_dmarc_compliant_from = On
dmarc_compliant_from_displayname = '%n via MDA Journal'
smtp_suppress_cert_check = Off

[queues]
default_connection = "database"
job_runner = On

[schedule]
task_runner = On
task_runner_interval = 60
```

Because the journal path stays `mdaj`, OJS will generate and accept URLs at
`https://mdaj.softrivahost.com/mdaj/`. Do not add a `base_url[mdaj]` override
for this migration: it would change the public URL layout and also break the
sitemap generator, which reads `config.inc.php` with PHP's `parse_ini_file`.

If you later want the journal at the hostname root instead of `/mdaj`, that is
a separate URL-layout change. It requires the `base_url[mdaj]` override, a
redirect rule for old `/mdaj/*` links, and a rewrite of
`scripts/generate-sitemap.php` to read the override correctly. Do not mix it
into the initial server migration.

Keep `allowed_hosts` updated whenever a hostname is added or removed. It must
always contain every hostname that serves this installation.

---

## 7. Apache virtual host

Create `/etc/apache2/sites-available/mdaj.softrivahost.com.conf`:

```apache
<VirtualHost *:80>
    ServerName mdaj.softrivahost.com
    DocumentRoot /home/mdaj/public_html

    Redirect permanent / https://mdaj.softrivahost.com/
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName mdaj.softrivahost.com
    DocumentRoot /home/mdaj/public_html

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/mdaj.softrivahost.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/mdaj.softrivahost.com/privkey.pem

    <Directory /home/mdaj/public_html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always set Permissions-Policy "camera=(), microphone=(), geolocation=()"

    ErrorLog ${APACHE_LOG_DIR}/mdaj.softrivahost.com-ssl-error.log
    CustomLog ${APACHE_LOG_DIR}/mdaj.softrivahost.com-ssl-access.log combined
</VirtualHost>
</IfModule>
```

Do not add `Strict-Transport-Security` yet; that is a separate public-domain
decision (action 15). If it is enabled later, use `includeSubDomains` only after
every relevant subdomain is confirmed to be HTTPS-only.

Enable the site:

```bash
sudo a2ensite mdaj.softrivahost.com
sudo a2dissite 000-default
sudo apache2ctl configtest
sudo systemctl reload apache2
```

---

## 8. TLS certificate

```bash
sudo certbot --apache -d mdaj.softrivahost.com --agree-tos \
  -m <ADMIN_EMAIL>
```

The HTTP-to-HTTPS redirect is already in the Apache vhost from section 7, so
`--redirect` is not needed. Certbot installs a renewal timer automatically.
Confirm it:

```bash
systemctl list-timers | grep certbot
sudo certbot renew --dry-run
```

If Certbot cannot complete the HTTP challenge because the port-80 redirect
catches `.well-known/acme-challenge/`, temporarily comment out the `Redirect`
line, reload Apache, run Certbot again, then restore the redirect and reload.

---

## 9. Ownership and permissions

Apache runs as `www-data` on a standard Ubuntu server. Make the site user own
the files and give Apache group access only where OJS needs to write.

```bash
sudo chown -R mdaj:www-data /home/mdaj/public_html /home/mdaj/files /home/mdaj/scripts

# Normal web files: readable by Apache, not world-writable.
sudo find /home/mdaj/public_html -type d -exec chmod 2755 {} \;
sudo find /home/mdaj/public_html -type f -exec chmod 0644 {} \;

# Writable runtime areas.
sudo find /home/mdaj/files -type d -exec chmod 2770 {} \;
sudo find /home/mdaj/files -type f -exec chmod 0660 {} \;
sudo find /home/mdaj/public_html/cache -type d -exec chmod 2770 {} \;
sudo find /home/mdaj/public_html/cache -type f -exec chmod 0660 {} \;
sudo find /home/mdaj/public_html/public -type d -exec chmod 2775 {} \;
sudo find /home/mdaj/public_html/public -type f -exec chmod 0664 {} \;

# Secrets stay readable only by the site user and the Apache group.
sudo chmod 0640 /home/mdaj/public_html/config.inc.php
```

If your hosting provider runs Apache as a different user/group (for example
`nobody:nogroup`), replace `www-data` with that group throughout these commands.
Never use mode `777`, and never give the runtime directory ownership to the web
user; group-write with `setgid` is sufficient.

---

## 10. Sitemap and scheduled jobs

The sitemap generator already exists at `/home/mdaj/scripts/generate-sitemap.php`
on the migrated install and reads `config.inc.php`, so it follows the new
`base_url` automatically.

Add the daily cron:

```bash
crontab -e
```

```cron
15 3 * * * /usr/bin/php /home/mdaj/scripts/generate-sitemap.php >/dev/null 2>&1
```

Regenerate and inspect the sitemap once:

```bash
php /home/mdaj/scripts/generate-sitemap.php
curl -sS https://mdaj.softrivahost.com/sitemap.xml | head
```

OJS's own task runner and queue worker do **not** need a cron entry. They run on
web-request shutdown when `[schedule] task_runner = On` and
`[queues] job_runner = On`. If the journal later has very little traffic, add a
lightweight heartbeat cron that fetches the homepage to trigger the runner:

```cron
*/5 * * * * /usr/bin/curl -sS https://mdaj.softrivahost.com/mdaj/ >/dev/null 2>&1
```

This is optional and is not present on the current server.

---

## 11. Verification checklist

Run these checks before declaring the server ready:

```bash
curl -I https://mdaj.softrivahost.com/mdaj/
curl -sS https://mdaj.softrivahost.com/robots.txt
curl -sS https://mdaj.softrivahost.com/sitemap.xml | head
php -m | grep -E 'gd|intl|mbstring|mysqli|pdo_mysql|xml|zip'
sudo mysql mdaj_ojsdb -e 'SELECT journal_id, path, enabled FROM journals;'
```

Expected results:

- The journal homepage returns `200` over HTTPS at
  `https://mdaj.softrivahost.com/mdaj/`.
- `robots.txt` points to `https://mdaj.softrivahost.com/sitemap.xml`.
- The sitemap lists journal URLs at `https://mdaj.softrivahost.com/mdaj/...`.
- The required PHP extensions are present.
- The `journals` table shows journal 1 with path `mdaj` and `enabled = 1`.

Log in to OJS and confirm:

- The journal homepage and a sample article/issue page render correctly.
- The journal management backend opens at
  `https://mdaj.softrivahost.com/mdaj/management/...`.
- Site administration remains available at
  `https://mdaj.softrivahost.com/index/index/admin`.
- Sending a test email from OJS succeeds and arrives via PurelyMail.

---

## 12. After the new server is verified

- Complete action 4 (Google Search Console and Bing) against the final public
  domain after `mdajournal.com` is cut over to this server.
- Establish the local backup routine (action 17) and off-server copies with a
  restore test (action 18).
- Add the monthly patching and maintenance routine (action 22) to a calendar.
- Keep `config.inc.php` secrets out of any markdown or version-controlled file.
