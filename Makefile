.PHONY: install enable

DEPENDS_ON ?= "network-online.target"
TUNNEL_NAME ?= "gpd0"
TIMER ?= "20"
BRANCH := main

resample:
		sudo DEPENDS_ON="$(DEPENDS_ON)" envsubst < ytunnel.tpl > ytunnel.service

install:
		test -f /tmp/ytunnel.zip || wget https://github.com/hakuno/ytunnel/archive/refs/heads/$(BRANCH).zip -O /tmp/ytunnel.zip; \
		sudo unzip -o -qq /tmp/ytunnel.zip -d /opt; \
		sudo ln -sfn /opt/ytunnel-$(BRANCH) /opt/ytunnel; \
		TUNNEL_NAME=$(TUNNEL_NAME) \
		TIMER=$(TIMER) \
		DEPENDS_ON="$(DEPENDS_ON)" envsubst < /opt/ytunnel/ytunnel.tpl > /tmp/ytunnel.service; \
		sudo cp /tmp/ytunnel.service /etc/systemd/system/; \
		sudo chmod 664 /etc/systemd/system/ytunnel.service; \
		sudo systemctl daemon-reload

enable:
		sudo systemctl enable ytunnel.service; \
		sudo systemctl start ytunnel.service