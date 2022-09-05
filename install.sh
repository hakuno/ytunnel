#!/usr/bin/env bash
BRANCH="${BRANCH:-main}"
DEPENDS_ON="${DEPENDS_ON:-network-online.target}"
TUNNEL_NAME="${TUNNEL_NAME:-gpd0}"
TIMER="${TIMER:-20}"
TIMESTAMP=$(date +%s)

test -f /tmp/ytunnel.zip || wget https://github.com/hakuno/ytunnel/archive/refs/heads/${BRANCH}.zip -O /tmp/ytunnel.zip
test -f /opt/ytunnel/endpoints.dat && cp /opt/ytunnel/endpoints.dat /tmp/endpoints.${TIMESTAMP}.dat
sudo unzip -o -qq /tmp/ytunnel.zip -d /opt
sudo ln -sfn /opt/ytunnel-${BRANCH} /opt/ytunnel
TUNNEL_NAME=${TUNNEL_NAME} \
  TIMER=${TIMER} \
  DEPENDS_ON="${DEPENDS_ON}" envsubst < /opt/ytunnel/ytunnel.tpl > /tmp/ytunnel.service
test -f /tmp/endpoints.${TIMESTAMP}.dat && sudo cp /tmp/endpoints.${TIMESTAMP}.dat /opt/ytunnel/endpoints.dat
sudo cp /tmp/ytunnel.service /etc/systemd/system/
sudo chmod 664 /etc/systemd/system/ytunnel.service
sudo systemctl daemon-reload