# AWS Self-Signed Certificate Generator

> **Disclaimer:** This project is a personal utility and is **not an official CrowdStrike tool**. It is not supported or endorsed by CrowdStrike in any capacity. Use at your own discretion.

This script automates the creation of self-signed X.509 certificates for use with [AWS IAM Roles Anywhere](https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html).

It generates:
- A Trust Anchor certificate and private key
- An End Entity certificate and key
- A CSR for the End Entity
- Validates the chain with OpenSSL

## Use Case

AWS IAM Roles Anywhere allows you to assume IAM roles using X.509 certificates. This script helps bootstrap your certificate infrastructure without requiring a full CA.

## Usage

### Direct Install (One-Liner)

```bash
curl -sSL https://raw.githubusercontent.com/CsCurt/aws-cert-generator/main/generate_self_signed_cert.sh | bash
```

### Or Run Locally
#### Option 1:
```bash
git clone https://github.com/CsCurt/aws-cert-generator.git
cd aws-cert-generator
chmod +x generate_self_signed_cert.sh
./generate_self_signed_cert.sh
```
#### Option 2:

```bash
curl -o generate_self_signed_cert.sh https://raw.githubusercontent.com/CsCurt/aws-cert-generator/main/generate_self_signed_cert.sh
chmod +x generate_self_signed_cert.sh
./generate_self_signed_cert.sh
```
#### Option 3: Download ZIP

1. Go to [https://github.com/CsCurt/aws-cert-generator](https://github.com/CsCurt/aws-cert-generator)
2. Click the green "Code" button, then choose "Download ZIP"
3. Extract the ZIP, open the folder, and run the script


## Output Files

After running, you'll get:

- `trust-anchor.crt` — Trust Anchor certificate
- `trust-anchor.key` — Trust Anchor private key
- `end-entity.crt` — End Entity certificate
- `end-entity.key` — End Entity private key
- `end-entity.csr` — Certificate Signing Request
- `trust-anchor.cnf` and `end-entity.cnf` — Config files used for OpenSSL

## Certificate Validity

Certificates are valid for **365 days** by default. You can update the `VALIDITY_DAYS` variable in the script to adjust.

## References

- [AWS IAM Roles Anywhere Trust Model](https://docs.aws.amazon.com/rolesanywhere/latest/userguide/trust-model.html)
- [OpenSSL Manual](https://www.openssl.org/docs/)

---

© CsCurt — MIT License
