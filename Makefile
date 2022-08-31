.PHONY: install enable

branch := main

install:
		test -f /tmp/ytunnel.zip || wget https://github.com/hakuno/ytunnel/archive/refs/heads/$(branch).zip -O /tmp/ytunnel.zip; \
		sudo unzip -o -qq /tmp/ytunnel.zip -d /opt; \
		sudo ln -sf /opt/ytunnel-$(branch) /opt/ytunnel; \
		sudo cp /opt/ytunnel/ytunnel.service /etc/systemd/system/; \
		sudo chmod 664 /etc/systemd/system/ytunnel.service; \
		sudo systemctl daemon-reload

enable:
		sudo systemctl enable ytunnel.service; \
		sudo systemctl start ytunnel.service