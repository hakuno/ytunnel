.PHONY: install

install:
		sudo mkdir -p /opt/ytunnel; \
		git clone https://github.com/hakuno/ytunnel.git /opt/ytunnel; \
		cd /opt/ytunnel && sudo cp ytunnel.service /etc/systemd/system/; \
		sudo chmod 664 /etc/systemd/system/ytunnel.service; \
		sudo systemctl daemon-reload