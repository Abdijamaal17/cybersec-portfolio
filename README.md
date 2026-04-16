# 🛡️ Cybersecurity Portfolio

> Penetration testing, bug bounty research, and security assessments by Abdijamaal Mohamuud.

![Security](https://img.shields.io/badge/Focus-Offensive_Security-red?style=flat-square)
![OWASP](https://img.shields.io/badge/OWASP-Top_10-blue?style=flat-square)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-orange?style=flat-square)
![HackerOne](https://img.shields.io/badge/HackerOne-milhox17-black?style=flat-square&logo=hackerone)

---

## 🚀 Real-World Projects

### Bug Bounty — Bitstamp (HackerOne)
Active bug bounty research on Bitstamp cryptocurrency exchange.
- Enumerated **64 subdomains** and mapped **100+ API endpoints**
- Discovered **AWS credentials exposed** in archived URLs (Critical)
- Identified **IDOR vulnerability** in account data API (High)
- [Full writeup →](writeups/bitstamp-bug-bounty.md)

### Penetration Test — FS-Security
Black-box web application penetration test, 34-page report.
- **SQL Injection → Root** (CVSS 9.8 Critical) — full DB and OS compromise
- Stored XSS, missing security headers, verbose error messages
- Delivered executive summary and technical findings to client
- [Full writeup →](writeups/fs-security-pentest.md)

---

## 📁 Structure

```
├── methodology/              # Security frameworks and testing guides
│   ├── owasp-top-10.md       # OWASP Top 10 testing methodology
│   └── mitre-attack.md       # MITRE ATT&CK mapping guide
├── writeups/                 # Real-world pentests and bug bounty reports
│   ├── bitstamp-bug-bounty.md
│   ├── fs-security-pentest.md
│   └── htb-machine-template.md
├── cheatsheets/              # Quick-reference guides
│   ├── nmap-cheatsheet.md
│   └── burpsuite-cheatsheet.md
├── bug-bounty/               # Automation scripts and report templates
│   ├── scripts/recon.sh
│   ├── scripts/install-tools.sh
│   └── templates/hackerone-report.md
└── README.md
```

---

## 🎯 Methodology

| Framework | Purpose | Status |
|-----------|---------|--------|
| OWASP Top 10 | Web application testing | Active |
| MITRE ATT&CK | Threat mapping and analysis | Active |
| PTES | Penetration testing workflow | Active |
| NIST CSF | Risk management | In Progress |

---

## 🔧 Core Skills

- **Web App Pentesting** — SQL injection, XSS, IDOR, authentication bypass, privilege escalation
- **Bug Bounty** — Subdomain enumeration, API analysis, secret discovery, HackerOne reporting
- **Network Security** — Port scanning (Nmap), service enumeration, SMB/SSH exploitation
- **Scripting** — Bash automation, Python tooling, Burp Suite extensions
- **SIEM and Monitoring** — Splunk, Wazuh, log analysis, alert correlation
- **Compliance** — NIS2 directive, CVSS scoring, risk assessment frameworks

---

## 📊 Testing Workflow

Reconnaissance → Enumeration → Vulnerability Analysis → Exploitation → Post-Exploitation → Reporting

1. **Reconnaissance** — OSINT, DNS enumeration, subdomain discovery, Wayback crawl
2. **Enumeration** — Port scanning, service fingerprinting, directory brute-forcing, JS analysis
3. **Vulnerability Analysis** — Manual testing and automated scanning, CVSS scoring
4. **Exploitation** — Proof-of-concept development, controlled exploitation
5. **Post-Exploitation** — Privilege escalation, lateral movement, persistence
6. **Reporting** — Executive summary, technical findings, remediation guidance

---

## 📜 License

Educational purposes only. All testing performed in authorized environments with explicit permission.
