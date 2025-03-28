#!/bin/bash

set -euo pipefail

# === Configuration ===
COUNTRY="US"
STATE="CA"
CITY="Irvine"
ORG="CrowdStrike, Inc."
ORG_UNIT="IT"
EMAIL="it@crowdstrike.com"

# Validity period for the cert (365 days)
VALIDITY_DAYS=365

echo "[*] Starting certificate generation..."

# === Trust Anchor ===
cat << EOF > trust-anchor.cnf
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = v3_ca
[ req_distinguished_name ]
C=$COUNTRY
ST=$STATE
L=$CITY
O=$ORG
OU=$ORG_UNIT
emailAddress=$EMAIL
CN=trust-anchor
[ v3_ca ]
basicConstraints = CA:TRUE
keyUsage = keyCertSign, cRLSign
subjectAltName = DNS:trust-anchor
EOF

openssl genrsa -out trust-anchor.key 4096
openssl req -new -x509 -days $VALIDITY_DAYS -key trust-anchor.key -out trust-anchor.crt -config trust-anchor.cnf

# === End Entity ===
cat << EOF > end-entity.cnf
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = v3_ca
[ req_distinguished_name ]
C=$COUNTRY
ST=$STATE
L=$CITY
O=$ORG
OU=$ORG_UNIT
emailAddress=$EMAIL
CN=end-entity
[ v3_ca ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
subjectAltName = DNS:end-entity
EOF

openssl req -newkey rsa:4096 -nodes -keyout end-entity.key -out end-entity.csr -config end-entity.cnf
openssl x509 -req -days $VALIDITY_DAYS -in end-entity.csr -out end-entity.crt -CA trust-anchor.crt -CAkey trust-anchor.key -CAcreateserial -extensions v3_ca -extfile end-entity.cnf

# === Verification ===
openssl verify -CAfile trust-anchor.crt end-entity.crt

echo "[*] Certificate creation complete."
echo "    Files created:"
echo "    - trust-anchor.crt (Trust Anchor Certificate)"
echo "    - trust-anchor.key (Trust Anchor Private Key)"
echo "    - end-entity.csr   (End Entity CSR)"
echo "    - end-entity.crt   (End Entity Certificate)"
echo "    - end-entity.key   (End Entity Private Key)"
