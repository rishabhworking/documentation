This setup is correct. Below is the markdown file exactly as requested.

````markdown
# Static Website on Nginx with Cloudflare (Full Strict) and Secondary-Domain Redirect

This guide sets up:

1. A **static site** served by Nginx.
2. **Cloudflare proxy (orange cloud)** in **Full (strict)** mode.
3. Nginx **trusting Cloudflare IPs** (so you see real client IPs).
4. A **primary domain** (e.g. `example.com`) serving the site.
5. A **secondary domain** (e.g. `example2.com`) permanently redirecting to the primary.
6. A **single Let’s Encrypt certificate** covering both domains.

> Replace **`your_domain`** and **`your_domain2`** everywhere with your actual domains.

---

## 1. Create the web root

```bash
sudo mkdir -p /var/www/your_domain/html
sudo chown -R $USER:$USER /var/www/your_domain/html
sudo chmod -R 755 /var/www/your_domain
````

Create a test page:

```bash
sudo nano /var/www/your_domain/html/index.html
```

Paste:

```html
<html>
  <head>
    <title>Welcome to your_domain!</title>
  </head>
  <body>
    <h1>Success! The your_domain server block is working!</h1>
  </body>
</html>
```

---

## 2. Trust Cloudflare IPs in Nginx

Create `/etc/nginx/conf.d/cloudflare-realip.conf`:

```bash
sudo nano /etc/nginx/conf.d/cloudflare-realip.conf
```

Paste:

```nginx
# Cloudflare IPv4
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 131.0.72.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;

# Cloudflare IPv6
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2a06:98c0::/29;
set_real_ip_from 2c0f:f248::/32;

real_ip_header CF-Connecting-IP;
real_ip_recursive on;
```

This makes Nginx use the real visitor IP, not the Cloudflare edge IP.

---

## 3. Primary domain Nginx config

Create the site file:

```bash
sudo nano /etc/nginx/sites-available/your_domain.conf
```

Paste:

```nginx
# HTTP → HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name your_domain www.your_domain;
    return 301 https://your_domain$request_uri;
}

# Main HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your_domain www.your_domain;

    # SSL - managed by Certbot
    ssl_certificate /etc/letsencrypt/live/your_domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Document root
    root /var/www/your_domain/html;
    index index.html;

    # SPA-friendly
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Block hidden files
    location ~ /\. {
        deny all;
    }

    # Cache static assets
    location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|ttf|svg|eot|mp4|webm|ogg|ogv|json)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
        access_log off;
        try_files $uri =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/your_domain.conf /etc/nginx/sites-enabled/your_domain.conf
```

---

## 4. Secondary domain → permanent redirect to primary

Create:

```bash
sudo nano /etc/nginx/sites-available/your_domain2.conf
```

Paste:

```nginx
# HTTP → HTTPS redirect to primary
server {
    listen 80;
    listen [::]:80;
    server_name your_domain2 www.your_domain2;
    return 301 https://your_domain$request_uri;
}

# HTTPS → redirect to primary
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your_domain2 www.your_domain2;

    # Reuse the main cert (must include both domains)
    ssl_certificate /etc/letsencrypt/live/your_domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain/privkey.pem;

    return 301 https://your_domain$request_uri;
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/your_domain2.conf /etc/nginx/sites-enabled/your_domain2.conf
```

---

## 5. Obtain / extend the Let’s Encrypt certificate

First, see what you have:

```bash
sudo certbot certificates
```

Then issue (or re-issue) **one** certificate that includes both domains:

```bash
sudo certbot certonly --nginx \
  -d your_domain -d www.your_domain \
  -d your_domain2 -d www.your_domain2
```

Certbot will update `/etc/letsencrypt/live/your_domain/…` with all names.

---

## 6. Test and reload Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 7. Cloudflare settings

* In Cloudflare → **SSL/TLS**: set **Full (strict)**
* In Cloudflare → **DNS**: both `your_domain` and `your_domain2` A/AAAA records should point to your server and be **proxied** (orange cloud)

---

## 8. Verify

From your local machine:

```bash
curl -I http://your_domain
curl -I https://your_domain
curl -I https://your_domain2
```

You should see `301` for the secondary, and `200` for the primary.

---

## Notes

* Keep the Cloudflare IP list updated periodically.
* Certbot usually installs a cron/systemd timer, but you can test renewals manually:

  ```bash
  sudo certbot renew --dry-run
  ```
* This layout works for **static** and **SPA** sites alike.

```
```
