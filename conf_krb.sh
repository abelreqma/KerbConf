#!/bin/bash

#colors
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
BLUE='\033[0;34m'


#purpose
echo -e "${GREEN}${BOLD}Dynamically Generate a krb5.conf file${RESET}"

echo -ne "${BLUE}${BOLD}Enter the Domain Name:${RESET} "
read DOMAIN

echo -ne "${BLUE}${BOLD}Enter the Host Name:${RESET} " 
read HOSTNAME

CAPITALIZED=$(echo "$DOMAIN" | tr '[:lower:]' '[:upper:]')

cat << EOF > ${DOMAIN}_krb5.conf
[libdefaults]
    default_realm = $CAPITALIZED
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    rdns = false
    dns_canonicalize_hostname = false
    fcc-mit-ticketflags = true

[realms]
    $CAPITALIZED = {
        kdc = ${HOSTNAME}.${DOMAIN}
    }

[domain_realm]
    .${DOMAIN} = $CAPITALIZED
    ${DOMAIN} = $CAPITALIZED
EOF

echo -e "${GREEN}${BOLD}\nCreated krb5.conf for ${DOMAIN}: ${DOMAIN}_krb5.conf${RESET}"
echo -e "${RED}${BOLD}sudo cp ${DOMAIN}_krb5.conf /etc/krb5.conf${RESET}"
