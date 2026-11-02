#!/bin/bash
set -euo pipefail

echo "==> Updating packages"
sudo apt-get update -y

echo "==> Installing nginx"
sudo apt-get install -y nginx curl

echo "==> Creating deploy user (if missing)"
id deploy &>/dev/null || sudo useradd -m -s /bin/bash deploy

echo "==> Deploying site"
sudo mkdir -p /var/www/mysite
sudo cp index.html /var/www/mysite/index.html
sudo chown -R deploy:deploy /var/www/mysite
sudo chmod -R 755 /var/www/mysite

echo "==> Configuring nginx"
sudo tee /etc/nginx/sites-available/mysite > /dev/null <<'EOF'
server {
    listen 80;
    root /var/www/mysite;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
sudo ln -sf /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/mysite
sudo rm -f /etc/nginx/sites-enabled/default

echo "==> Testing config and restarting"
sudo nginx -t
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "==> Verifying"
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$CODE" = "200" ]; then
    echo "SUCCESS: site is live (HTTP $CODE)"
else
    echo "FAILED: got HTTP $CODE"
    exit 1
fi
