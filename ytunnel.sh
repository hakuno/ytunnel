#!/usr/bin/env bash
touch endpoints.dat
sleep 30

OLDADDR=
NEWADDR=
VPNI=gpd0
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
# sudo ip route del default via $GATEWAY
sudo ip route del default dev $VPNI

# Subnet
# sudo route add -net 10.32.0.0 netmask 255.255.0.0 gw $GATEWAY
sudo ip route add 10.32.0.0/16 dev $VPNI

# Iterate private endpoint list
for endpoint in ${ENDPOINTS[@]}
do
    RESOLVING="$(dig +short $endpoint)"
    if [ "$RESOLVING" == "" ]; then
        sudo route add -net $endpoint netmask 255.255.255.255 gw $GATEWAY
    else
        sudo route add -net $RESOLVING netmask 255.255.255.255 gw $GATEWAY
    fi
done

NEWADDR=$(dig +short myip.opendns.com @resolver1.opendns.com -4)

echo "Your IP address is ${OLDADDR} through VPN tunnel. And it is ${NEWADDR} bypassing."