# [Machine Name] — HackTheBox Writeup

> **Difficulty:** Easy/Medium/Hard
> **OS:** Linux/Windows
> **Skills:** [list relevant skills]

## Summary

Brief 2-3 sentence overview of the machine and attack path.

---

## Reconnaissance

### Nmap Scan
```bash
nmap -sC -sV -oN nmap/initial <IP>
```

**Results:**
```
PORT     STATE SERVICE  VERSION
22/tcp   open  ssh      OpenSSH 8.x
80/tcp   open  http     Apache 2.4.x
```

### Web Enumeration
```bash
gobuster dir -u http://<IP> -w /usr/share/wordlists/dirb/common.txt -o gobuster.txt
```

**Findings:**
- `/admin` — Admin panel (403)
- `/uploads` — File upload directory
- `/api` — REST API endpoint

---

## Enumeration

Detail specific service enumeration, interesting findings, and potential attack vectors.

### Service Analysis
- Web application: [technology stack]
- Authentication: [mechanism]
- Notable features: [file upload, search, user profiles, etc.]

---

## Exploitation

### Vulnerability
- **Type:** [SQLi / RCE / LFI / etc.]
- **Location:** [endpoint or parameter]
- **Impact:** [what access does it give]

### Steps
1. Identify the vulnerability
2. Craft the payload
3. Execute and gain initial access

```bash
# Example exploitation command
sqlmap -u "http://<IP>/page?id=1" --dbs
```

### Initial Shell
```bash
# Reverse shell or access method
nc -lvnp 4444
```

**user.txt:** `[flag location]`

---

## Privilege Escalation

### Enumeration
```bash
sudo -l
find / -perm -4000 2>/dev/null
cat /etc/crontab
```

### Escalation Path
Detail the privilege escalation method used.

**root.txt:** `[flag location]`

---

## Lessons Learned

- Key takeaway 1
- Key takeaway 2
- Detection/prevention recommendations

## MITRE ATT&CK Mapping

| Tactic | Technique | Details |
|--------|-----------|---------|
| Initial Access | T1190 | Exploit public-facing app |
| Execution | T1059 | Command injection |
| Privilege Escalation | T1068 | Exploitation for priv esc |
