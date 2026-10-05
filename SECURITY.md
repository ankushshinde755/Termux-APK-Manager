# Security Policy

## Supported versions

| Version | Supported |
|---|---|
| 1.1.x | ✅ |
| 1.0.x | ⚠️ Best effort |
| < 1.0 | ❌ |

## Reporting a vulnerability

Please do not publish credentials, exploit details, or sensitive information in a public issue.

If the repository owner has enabled GitHub's private vulnerability reporting, use that channel. Otherwise, contact the repository owner privately through GitHub before public disclosure.

Include:

- affected version
- affected command/function
- reproduction steps
- expected behavior
- actual behavior
- security impact
- suggested mitigation, if known

Please redact:

- passwords
- API tokens
- pairing codes
- private IP addresses
- personal backup files
- company information

## Scope

Security reports are especially relevant to:

- unintended command execution
- unsafe argument handling
- accidental data destruction
- credential/secret exposure
- unsafe package-management behavior

The project intentionally does not attempt to bypass Android/OEM security boundaries.
