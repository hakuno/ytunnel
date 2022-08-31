#!/usr/bin/env bash
touch endpoints.dat

OLDADDR=
NEWADDR=
VPNI=gpd0
GATEWAY=$(netstat -r | grep default | grep $VPNI | awk '{print $2}')
ENDPOINTS=($(cat endpoints.dat))

if [ "$GATEWAY" == "" ]; then
    echo "It seems OK. No ${VPNI}'s default route found."
    exit 0
fi

OLDADDR=$"(dig +short myip.opendns.com @resolver1.opendns.com)"

# Removing the catchall
sudo ip route del default via $GATEWAY

# Subnet
sudo route add -net 10.32.0.0 netmask 255.255.0.0 gw $GATEWAY

# metabase.meliuz.com.br
# sudo route add -net 35.168.103.192 netmask 255.255.255.255 gw $GATEWAY

# Iterate private endpoint list
for endpoint in ${ENDPOINTS[@]}
do
    sudo route add -net $(dig +short $endpoint) netmask 255.255.255.255 gw $GATEWAY
done

# Debug
# netstat -r

NEWADDR="$(dig +short myip.opendns.com @resolver1.opendns.com)"

echo "Your IP address is ${OLDADDR} through VPN tunnel. And it is ${NEWADDR} bypassing."