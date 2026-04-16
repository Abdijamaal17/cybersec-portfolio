# Burp Suite Cheatsheet

## Setup

### Proxy Configuration
1. Set browser proxy to `127.0.0.1:8080`
2. Install Burp CA certificate: `http://burp` → CA Certificate
3. Import cert into browser's certificate store
4. Use FoxyProxy extension for easy switching

### Scope
- Target → Scope → Add target URL
- Enable "Use advanced scope control" for regex patterns
- Filter proxy history: check "Show only in-scope items"

---

## Proxy

### Intercept
| Action | Shortcut |
|--------|----------|
| Forward request | Click Forward |
| Drop request | Click Drop |
| Toggle intercept | Intercept is on/off |
| Send to Repeater | Ctrl+R |
| Send to Intruder | Ctrl+I |

### Match & Replace
- Proxy → Options → Match and Replace
- Auto-replace headers (e.g., User-Agent)
- Remove security headers for testing

---

## Repeater

Used for manual request manipulation and testing.

### Workflow
1. Capture request in Proxy
2. Send to Repeater (Ctrl+R)
3. Modify parameters, headers, or body
4. Click Send and analyze response
5. Compare responses side-by-side

### Common Tests
```
# SQL Injection
parameter=value' OR '1'='1

# XSS
parameter=<script>alert(1)</script>

# Path Traversal
parameter=../../../etc/passwd

# IDOR
/api/user/1001 → /api/user/1002

# Header Injection
X-Forwarded-For: 127.0.0.1
```

---

## Intruder

### Attack Types

| Type | Use Case |
|------|----------|
| **Sniper** | Single payload position, one at a time |
| **Battering Ram** | Same payload in all positions |
| **Pitchfork** | Different payload per position (parallel) |
| **Cluster Bomb** | All combinations of payloads |

### Common Uses
- Brute force login credentials
- Parameter fuzzing
- Directory/file enumeration
- ID enumeration (IDOR testing)

### Payload Types
- Simple list — custom wordlist
- Numbers — sequential range
- Runtime file — load from file
- Recursive grep — extract from responses

---

## Scanner (Pro)

### Active Scan
1. Right-click target → "Actively scan this host"
2. Or send specific requests to Scanner
3. Review findings in Target → Issues

### Scan Configuration
- Crawl and Audit — full scan
- Crawl only — discovery
- Audit only — test known endpoints

---

## Decoder

### Encoding/Decoding
- URL encoding/decoding
- Base64 encode/decode
- HTML entities
- Hex encoding
- Hash generation (MD5, SHA-1, SHA-256)

---

## Comparer

- Compare two responses to find differences
- Useful for:
  - Comparing valid vs invalid login responses
  - Finding blind injection indicators
  - Detecting WAF behavior differences

---

## Extensions (BApp Store)

| Extension | Purpose |
|-----------|---------|
| **Autorize** | Automated authorization testing |
| **Logger++** | Enhanced logging with filters |
| **Param Miner** | Hidden parameter discovery |
| **Active Scan++** | Enhanced scanning checks |
| **JSON Beautifier** | Format JSON responses |
| **Retire.js** | Detect vulnerable JS libraries |
| **Turbo Intruder** | High-speed brute forcing |

---

## Tips

- Always check **response length** differences — they often indicate successful injection
- Use **Comparer** to diff responses from valid vs injected requests
- Set **scope** early to avoid scanning out-of-scope targets
- **Disable intercept** when not actively testing to avoid blocking traffic
- Export findings via **Report** → generate HTML/XML report
