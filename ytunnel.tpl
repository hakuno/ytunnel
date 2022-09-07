[Unit]
Description=Ytunnel
After=$DEPENDS_ON

[Service]
ExecStart=/opt/ytunnel/ytunnel.sh
ExecStartPost=/opt/ytunnel/ytunnel.sh restart
RemainAfterExit=true
Type=oneshot
WorkingDirectory=/opt/ytunnel
Restart=on-failure
Environment=TUNNEL_NAME=$TUNNEL_NAME
Environment=TIMER=$TIMER

[Install]
WantedBy=multi-user.target