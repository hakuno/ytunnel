[Unit]
Description=Ytunnel
After=$DEPENDS_ON
StartLimitBurst=5
StartLimitIntervalSec=30

[Service]
ExecStart=/opt/ytunnel/ytunnel.sh
RemainAfterExit=true
Type=oneshot
WorkingDirectory=/opt/ytunnel
Restart=on-failure
RestartSec=1

[Install]
WantedBy=multi-user.target