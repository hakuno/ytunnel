#!/usr/bin/env bash
OLDADDR=
NEWADDR=
TIMER=${TIMER:-20}
TUNNEL_NAME="${TUNNEL_NAME:-gpd0}"

touch endpoints.dat
sleep $TIMER

GATEWAY=$(ip route | grep default | grep $TUNNEL_NAME | awk '{print $3}')
ENDPOINTS=($(cat endpoints.dat))

[ -e /proc/$(pidof PanGPA) ] || echo "PanGPA is not running."

[ -e /proc/$(pidof PanGPS) ] || echo "PanGPS is not running."

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
    if echo "$endpoint" | egrep '^([0-9]{1,3}\.[0-9]{1,3}\.)'; then
        echo "Found endpoint $endpoint"
        sudo ip route add $endpoint via $GATEWAY dev $TUNNEL_NAME
    else
        RESOLVING="$(dig +short $endpoint)"
        if [ "$RESOLVING" != "" ]; then
            echo "Found endpoint $RESOLVING for $endpoint"
            sudo ip route add $RESOLVING via $GATEWAY dev $TUNNEL_NAME
        fi
    fi
done

NEWADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

echo "Your IP address is ${OLDADDR} through VPN tunnel. And it is ${NEWADDR} bypassing."