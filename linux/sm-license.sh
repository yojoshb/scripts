#!/bin/bash
GRN='\033[1;32m'
read -p "Enter your SuperMicro BMC MAC Address: " MAC
key=$(echo -n $MAC | xxd -r -p | openssl dgst -sha1 -mac HMAC -macopt hexkey:8544E3B47ECA58F9583043F8 | awk '{print $2}' | cut -c 1-24)
echo -e "Activation Key is: ${GRN}$key"
