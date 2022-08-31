.PHONY: install

branch := main

install:
		wget https://github.com/hakuno/ytunnel/archive/refs/heads/$(branch).zip -O ytunnel.zip; \
		sudo unzip -o -qq ytunnel.zip -d /opt; \
		sudo ln -sf /opt/ytunnel-$(branch) /opt/ytunnel; \
		sudo cp /opt/ytunnel/ytunnel.service /etc/systemd/system/; \
		sudo chmod 664 /etc/systemd/system/ytunnel.service; \
		sudo systemctl daemon-reload