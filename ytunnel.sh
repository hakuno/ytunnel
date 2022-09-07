#!/usr/bin/env bash
OLDADDR=
NEWADDR=
TIMER=${TIMER:-20}
TUNNEL_NAME="${TUNNEL_NAME:-gpd0}"
NGATEWAYS=$(ip route | grep default | wc -l)

if [ "$1" == "restart" ]; then
    SERVICES=($(sudo systemctl cat ytunnel.service | grep ^After= | cut -d "=" -f2))
    for SERVICE in ${SERVICES[@]}
    do
        if [[ "$SERVICE" =~ ".service" ]]; then
        echo "Restarting ${SERVICE}"
        sudo systemctl restart ${SERVICE} && echo "Restarted successfully." || echo "Failed to restart."
    done

    [ "$(pidof PanGPS)" != "" ] && sudo systemctl restart gpd.service
fi

touch endpoints.dat
sleep $TIMER

GATEWAY=$(ip route | grep default | grep $TUNNEL_NAME | awk '{print $3}')
ENDPOINTS=($(cat endpoints.dat))

if [ "$GATEWAY" == "" ]; then
    echo "No ${TUNNEL_NAME}'s default route found."
    exit 1
fi

echo "The timer is ${TIMER}. The device is ${TUNNEL_NAME}."

OLDADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

# Removing the catchall
sudo ip route del default dev $TUNNEL_NAME

# Iterate private endpoint list
for endpoint in ${ENDPOINTS[@]}
do
    if [[ "$endpoint" =~ '^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' ]]; then
        echo "Found endpoint $endpoint"
        sudo ip route add $endpoint via $GATEWAY dev $TUNNEL_NAME
    else
        ENTRIES=($(dig +short $endpoint))
        for ENTRY in ${ENTRIES[@]}
        do
            if [ "${ENTRY}" != "" ]; then
                echo "Found endpoint ${ENTRY} for $endpoint"
                sudo ip route add $ENTRY via $GATEWAY dev $TUNNEL_NAME
            fi
        done
    fi
done

NEWADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

echo "Your IP address is ${OLDADDR} through VPN tunnel. And it is ${NEWADDR} bypassing."