# MITRE ATT&CK — Mapping Guide

> Using MITRE ATT&CK to map adversary behavior and improve detection.

## What is MITRE ATT&CK?

A knowledge base of adversary tactics and techniques based on real-world observations. Used for:
- Mapping attack paths during penetration tests
- Building detection rules in SIEM platforms
- Analyzing APT group behavior
- Identifying coverage gaps in security monitoring

## Tactic Overview

| ID | Tactic | Description |
|----|--------|-------------|
| TA0001 | Initial Access | How attackers get in (phishing, exploits, supply chain) |
| TA0002 | Execution | Running malicious code (PowerShell, scripts, user execution) |
| TA0003 | Persistence | Maintaining access (scheduled tasks, registry keys, implants) |
| TA0004 | Privilege Escalation | Gaining higher permissions (kernel exploits, token manipulation) |
| TA0005 | Defense Evasion | Avoiding detection (obfuscation, disabling AV, log clearing) |
| TA0006 | Credential Access | Stealing credentials (dumping, keylogging, brute force) |
| TA0007 | Discovery | Learning the environment (network scanning, account enumeration) |
| TA0008 | Lateral Movement | Moving through the network (RDP, SMB, pass-the-hash) |
| TA0009 | Collection | Gathering target data (screenshots, email collection) |
| TA0010 | Exfiltration | Stealing data out (encrypted channels, cloud storage) |
| TA0011 | Command and Control | Communicating with implants (DNS tunneling, HTTPS beacons) |

## Mapping Example: Web Application Attack

```
Initial Access (TA0001)
└── Exploit Public-Facing Application (T1190)
    └── SQL Injection on login form

Execution (TA0002)
└── Command and Scripting Interpreter (T1059)
    └── OS command execution via SQL injection (xp_cmdshell)

Credential Access (TA0006)
└── OS Credential Dumping (T1003)
    └── Extracted password hashes from database

Privilege Escalation (TA0004)
└── Valid Accounts (T1078)
    └── Cracked admin hash, SSH login as privileged user

Lateral Movement (TA0008)
└── Remote Services (T1021)
    └── SSH to internal hosts using recovered credentials
```

## Mapping Example: Phishing Campaign

```
Initial Access (TA0001)
└── Phishing: Spearphishing Attachment (T1566.001)
    └── Malicious macro document via email

Execution (TA0002)
└── User Execution: Malicious File (T1204.002)
    └── User opens document, enables macros

Defense Evasion (TA0005)
└── Obfuscated Files or Information (T1027)
    └── Base64-encoded PowerShell payload

Command and Control (TA0011)
└── Application Layer Protocol: Web Protocols (T1071.001)
    └── HTTPS beacon to C2 server

Exfiltration (TA0010)
└── Exfiltration Over C2 Channel (T1041)
    └── Data sent via encrypted C2 connection
```

## Detection with SIEM

Map ATT&CK techniques to detection rules:

```yaml
# Example: Detect credential dumping (T1003)
rule: credential_dump_detection
  source: windows_security_log
  event_id: [4648, 4672, 4624]
  condition: >
    multiple failed logins followed by
    successful login with elevated privileges
    within 5 minute window
  action: alert_high
  mitre: T1003
```

## Useful Resources

- [MITRE ATT&CK Navigator](https://mitre-attack.github.io/attack-navigator/) — Visual layer tool
- [ATT&CK Matrix](https://attack.mitre.org/) — Full technique database
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) — Test technique execution
