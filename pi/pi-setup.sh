#!/bin/sh
# Dead Brands Pi setup - run by David once, hands Rock the keys.
set -e
echo "== Installing Tailscale =="
curl -fsSL https://tailscale.com/install.sh | sh
echo "== Joining the tailnet - approve the login link on your phone =="
sudo tailscale up
echo "== Turning on SSH =="
sudo systemctl enable --now ssh || sudo raspi-config nonint do_ssh 0 || true
echo "== Installing Rock's key =="
mkdir -p ~/.ssh && chmod 700 ~/.ssh
grep -q "rock-pi-access" ~/.ssh/authorized_keys 2>/dev/null || echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI8Rdcpjix5D3FWKrL3UQAb2/d0jp9vp5DSiigcH3Gs rock-pi-access' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo ""
echo "================ READ THESE TO ROCK ================"
echo "USER: $(whoami)"
echo "TAILSCALE IP: $(tailscale ip -4 2>/dev/null || echo pending)"
echo "LAN IP: $(hostname -I)"
echo "====================================================="
