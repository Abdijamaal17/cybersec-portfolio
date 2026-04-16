# Nmap Cheatsheet

## Quick Reference

### Host Discovery
```bash
nmap -sn 192.168.1.0/24              # Ping sweep (no port scan)
nmap -Pn <target>                     # Skip host discovery
nmap -sn -PE 10.0.0.0/24             # ICMP echo ping sweep
```

### Basic Scans
```bash
nmap <target>                         # Top 1000 ports
nmap -p- <target>                     # All 65535 ports
nmap -p 80,443,8080 <target>          # Specific ports
nmap -p 1-1024 <target>               # Port range
nmap -F <target>                      # Fast scan (top 100)
```

### Service & Version Detection
```bash
nmap -sV <target>                     # Service version detection
nmap -sV --version-intensity 5 <target>  # Aggressive version scan
nmap -sC <target>                     # Default scripts
nmap -sC -sV <target>                 # Scripts + versions (standard)
nmap -A <target>                      # Aggressive (OS + version + scripts + traceroute)
```

### Scan Types
```bash
nmap -sT <target>                     # TCP connect scan
nmap -sS <target>                     # SYN stealth scan (requires root)
nmap -sU <target>                     # UDP scan
nmap -sN <target>                     # TCP NULL scan
nmap -sF <target>                     # FIN scan
nmap -sX <target>                     # Xmas scan
```

### OS Detection
```bash
nmap -O <target>                      # OS detection
nmap -O --osscan-guess <target>       # Aggressive OS guess
```

### NSE Scripts
```bash
nmap --script=<script> <target>       # Run specific script
nmap --script=vuln <target>           # Vulnerability scripts
nmap --script=safe <target>           # Safe scripts only
nmap --script=http-enum <target>      # HTTP enumeration
nmap --script=smb-enum-shares <target>  # SMB shares
nmap --script=http-headers <target>
nmap --script=ssl-enum-ciphers -p 443 <target>
nmap --script=ftp-anon -p 21 <target>
nmap --script=ssh-auth-methods -p 22 <target>
nmap --script=smb-vuln-* <target>
```

### Output Formats
```bash
nmap -oN scan.txt <target>            # Normal output
nmap -oX scan.xml <target>            # XML output
nmap -oG scan.gnmap <target>          # Grepable output
nmap -oA scan <target>                # All formats
```

### Timing & Performance
```bash
nmap -T0 <target>                     # Paranoid (IDS evasion)
nmap -T3 <target>                     # Normal (default)
nmap -T4 <target>                     # Aggressive
nmap -T5 <target>                     # Insane
nmap --min-rate 1000 <target>         # Min packets/sec
```

## Common Workflows

### Initial Recon
```bash
nmap -sC -sV -oN initial.txt <target>
nmap -p- --min-rate 1000 -oN allports.txt <target>
nmap -sC -sV -p <ports> -oN detailed.txt <target>
```

### Web Server
```bash
nmap -p 80,443,8080,8443 -sV --script=http-enum,http-headers,http-methods <target>
```

### SMB Enumeration
```bash
nmap -p 139,445 --script=smb-enum-shares,smb-enum-users,smb-vuln-* <target>
```
