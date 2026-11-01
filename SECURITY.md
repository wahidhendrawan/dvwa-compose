# Security Policy

## Supported versions

Only the latest release of dvwa-compose gets security fixes. Please check that the problem still exists there before reporting.

## Reporting a vulnerability

Report privately through GitHub: **Security → Report a vulnerability** on this repository ([direct link](https://github.com/wahidhendrawan/dvwa-compose/security/advisories/new)). Do not open a public issue, discussion or pull request, and do not post exploit details or credentials anywhere public.

Please include:

- the version or commit you tested, and your host OS and architecture
- the smallest steps or input that reproduce the problem
- what an attacker gains (data exposure, code execution, privilege escalation, denial of service, …)

Remove real credentials, customer data and sensitive logs from any evidence you share.

You should get a first reply within 7 days. Fixed issues are credited in the release notes unless you ask otherwise.

## In scope

- Compose or nginx configuration that exposes the lab beyond localhost by default
- Secrets handling in `.env` and the scripts
- Privileges granted by the Wazuh overlay beyond what it documents

## Out of scope

- Vulnerabilities inside DVWA itself: it is intentionally vulnerable, that is the point of the lab
- Running the lab on an untrusted network against the README's warning

## Safe harbor

Good-faith research that follows this policy will not be treated as a violation of the license or of this policy. Only test against your own deployment, access no more data than needed to show the issue, and do not degrade services for other people.
