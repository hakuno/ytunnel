#!/usr/bin/env bash
touch endpoints.dat
sleep 25

OLDADDR=
NEWADDR=
VPNI="${VPNI:-gpd0}"
GATEWAY=$(ip route | grep default | grep $VPNI | awk '{print $3}')
ENDPOINTS=($(cat endpoints.dat))

[ -e /proc/$(pidof PanGPA) ] || echo "PanGPA is not running."

[ -e /proc/$(pidof PanGPS) ] || echo "PanGPS is not running."

if [ "$GATEWAY" == "" ]; then
    echo "No ${VPNI}'s default route found."
    exit 1
fi

OLDADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

# Removing the catchall
sudo ip route del default dev $VPNI

# Iterate private endpoint list
for endpoint in ${ENDPOINTS[@]}
do
    if echo "$endpoint" | egrep '^([0-9]{1,3}\.[0-9]{1,3}\.)'; then
        echo "Found endpoint $endpoint"
        sudo ip route add $endpoint dev $VPNI
    else
        RESOLVING="$(dig +short $endpoint)"
        if [ "$RESOLVING" != "" ]; then
            echo "Found endpoint $RESOLVING for $endpoint"
            sudo ip route add $RESOLVING dev $VPNI
        fi
    fi
done

NEWADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

echo "Your IP address is ${OLDADDR} through VPN tunnel. And it is ${NEWADDR} bypassing."