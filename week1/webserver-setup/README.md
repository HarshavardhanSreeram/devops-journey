# Automated Nginx Web Server Setup

A Bash script that sets up a web server on a fresh Ubuntu machine with one command.

## What it does
- Updates packages and installs Nginx and curl
- Creates a dedicated `deploy` user (only if it doesn't exist)
- Copies `index.html` to `/var/www/mysite` with correct ownership and permissions
- Configures Nginx to serve the site
- Tests the config, restarts Nginx, and checks the site returns HTTP 200

## How to run
git clone git@github.com:HarshavardhanSreeram/devops-journey.git
cd devops-journey/week1/webserver-setup
chmod +x setup.sh
./setup.sh

Then open http://localhost in a browser.

## Key idea
The script is idempotent: running it multiple times gives the same result and does not break anything.

## What I learned
What set -euo pipefail does in a script
What idempotent means
How to check a service with systemctl status and journalctl
What nginx -t does and why you run it before restarting
