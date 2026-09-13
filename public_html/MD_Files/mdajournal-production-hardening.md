# MDA Journal Production Hardening Checklist

This document separates OJS application hardening from infrastructure changes that must be applied directly on the production server or in Cloudflare. Do not copy secrets from the testing server. Generate new production secrets.

## OJS application changes already applied locally

- HTTPS enforcement is enabled with `force_ssl = On`.
- Email validation is required with `require_validation = On`.
- Unvalidated accounts expire after 2 days with `user_validation_period = 2`.
- OJS 3.5 ALTCHA is enabled for registration, login, and lost-password forms.
- ALTCHA work factor is set to `100000`.
- A unique ALTCHA HMAC secret was generated locally.
- Public diagnostic scripts `check.php` and `check_pw.php` were removed.
- 35,620 disabled bot accounts were deleted from the local database after backup.

When pushing application files, confirm that the production `config.inc.php` retains its production database and SMTP credentials. Do not overwrite them with testing credentials. Generate a new ALTCHA HMAC key for production:

```bash
openssl rand -hex 32
```

Use the generated value in the production configuration:

```ini
user_validation_period = 2
force_ssl = On
require_validation = On

[captcha]
recaptcha = off
captcha_on_register = on
captcha_on_login = on
altcha = on
altcha_hmackey = 'REPLACE_WITH_NEW_PRODUCTION_SECRET'
altcha_on_register = on
altcha_on_login = on
altcha_on_lost_password = on
altcha_encrypt_number = 100000
```

## Credentials requiring manual action

- Rotate the SMTP password through the email provider. The former diagnostic scripts exposed it.
- Update only the production `smtp_password` after rotation.
- Reset passwords for administrator, journal manager, editor, and section editor accounts.
- Use unique passwords stored in a password manager.

## Cloudflare configuration

Apply after the production domain is proxied through Cloudflare.

### SSL/TLS

- Set SSL/TLS encryption mode to **Full (strict)**.
- Enable **Always Use HTTPS**.
- Enable **Automatic HTTPS Rewrites**.
- Keep a valid Let's Encrypt or Cloudflare Origin certificate on production.
- Do not use Flexible SSL.

### WAF and bot protection

- Enable Cloudflare Managed Rules.
- Enable Bot Fight Mode if available on the account.
- Challenge requests with an abnormally high threat score.
- Do not challenge verified search-engine bots.

### Rate-limit rules

Start conservatively and review logs before tightening limits:

- Registration paths containing `/user/register`: challenge after 3 requests per IP in 10 minutes.
- Login paths containing `/login/signIn`: challenge after 10 requests per IP in 5 minutes.
- Lost-password paths containing `/lostPassword`: challenge after 5 requests per IP in 15 minutes.
- Protect `/index/admin` and management paths with a managed challenge for unfamiliar countries or networks, if appropriate.

Prefer a Cloudflare Managed Challenge before blocking. Exclude trusted office/VPN IP addresses where necessary.

### Preserve real visitor IP addresses

Install and configure `mod_remoteip` on Apache so logs and OJS receive the Cloudflare visitor IP rather than a Cloudflare proxy address. Trust only Cloudflare's published IP ranges. After testing real-IP handling, set:

```ini
trust_x_forwarded_for = On
```

Do not enable this OJS setting before Apache is restricted to trusted Cloudflare proxies; otherwise clients can spoof their IP address.

### Lock the origin to Cloudflare

After confirming Cloudflare works, restrict ports 80 and 443 at the firewall to Cloudflare's published IPv4 and IPv6 ranges. Keep SSH restricted to administrator IP addresses. This prevents attackers from bypassing Cloudflare and hitting the origin directly.

## Apache production configuration

- Redirect all HTTP traffic to `https://mdajournal.com/`.
- Use the correct certificate for both `mdajournal.com` and `www.mdajournal.com`.
- Redirect `www.mdajournal.com` to the canonical non-www hostname.
- Disable directory listing with `Options -Indexes`.
- Ensure Apache does not serve hidden files, backups, SQL dumps, logs, or configuration files.
- Add security headers after testing journal workflows:

```apache
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "camera=(), microphone=(), geolocation=()"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

Add HSTS only after HTTPS works correctly on every required subdomain. Build and test a Content Security Policy separately before enforcing it because OJS themes and plugins may require additional sources.

## File ownership and permissions

- Application code should be owned by the deployment account and not writable by Apache.
- Only OJS runtime directories should be writable by the web-server group.
- Keep `files_dir` outside the public web root.
- Keep `config.inc.php` readable only by the owner and web-server group.

Example pattern; adjust account names and paths for production:

```bash
chown -R mdaj:www-data /home/mdaj/public_html/cache \
  /home/mdaj/public_html/public \
  /home/mdaj/public_html/usageStats \
  /home/mdaj/public_html/scheduledTaskLogs \
  /home/mdaj/files

chmod 640 /home/mdaj/public_html/config.inc.php
chmod 2770 /home/mdaj/files
```

Do not recursively grant `777` permissions.

## Remove dangerous and unnecessary files

Confirm these are absent from the production web root:

```text
check.php
check_pw.php
*.sql
*.tar.gz
*.zip
config.inc.php.bak
delete_list.txt
delete_log.txt
```

Keep database dumps and private backups outside `public_html`.

## Database and account controls

- Take a fresh database backup before pushing the cleaned local database.
- Verify the production user count and privileged roles immediately after import.
- Confirm no disabled bot accounts remain.
- Review administrator/editor role membership monthly.
- Test registration, validation email, login, password reset, submission, reviewer assignment, and user removal after deployment.

## Updates and backups

- Track supported OJS releases and install security updates promptly.
- Keep PHP, Apache, MariaDB, Certbot, and OS security packages updated.
- Back up the database, `public/`, private `files_dir`, and production configuration daily.
- Encrypt off-server backups and test restoration regularly.
- Never restore a database dump without verifying its timestamp and origin.

## Monitoring

- Monitor registration counts, failed logins, HTTP 403/429 responses, PHP fatal errors, and unusual administrator activity.
- Configure Cloudflare security-event alerts.
- Review Apache access/error logs and OJS scheduled-task logs.
- Alert on unexpected PHP files created beneath writable directories.
- Recheck TLS expiry and automatic renewal after every DNS or server migration.

## Deployment verification

After pushing to production, verify:

1. DNS resolves to Cloudflare and Cloudflare resolves to the correct origin.
2. HTTPS is trusted for root and `www` hostnames.
3. HTTP redirects to HTTPS and `www` redirects to the canonical hostname.
4. ALTCHA appears on registration, login, and password reset.
5. Validation emails are delivered.
6. Legitimate registration succeeds and automated registration without ALTCHA fails.
7. The users API and management screens work normally.
8. Cloudflare shows the visitor's real IP in Apache logs.
9. Backups complete and a restore test succeeds.

