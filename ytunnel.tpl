[Unit]
Description=Ytunnel
After=$DEPENDS_ON

[Service]
ExecStart=/opt/ytunnel/ytunnel.sh
RemainAfterExit=true
Type=oneshot

[Install]
WantedBy=multi-user.target