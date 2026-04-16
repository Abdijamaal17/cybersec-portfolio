# OWASP Top 10 (2021) — Testing Methodology

## A01: Broken Access Control

**What to test:**
- Modify URL parameters, API requests, or object references to access other users' data (IDOR)
- Access admin panels or restricted endpoints without proper authorization
- Bypass access controls by tampering with JWT tokens or session cookies
- Test for privilege escalation (horizontal and vertical)

**Tools:** Burp Suite Repeater, curl, browser DevTools

**Example test:**
```
# Test IDOR by changing user ID
GET /api/users/1001/profile  →  GET /api/users/1002/profile

# Test vertical privilege escalation
Change role parameter: {"role": "user"} → {"role": "admin"}
```

---

## A02: Cryptographic Failures

**What to test:**
- Data transmitted over HTTP instead of HTTPS
- Weak or outdated TLS versions (TLS 1.0/1.1)
- Sensitive data stored in plaintext (passwords, API keys)
- Weak hashing algorithms (MD5, SHA1 without salt)

**Tools:** SSLScan, testssl.sh, Nmap ssl-enum-ciphers

**Example test:**
```bash
# Check TLS configuration
nmap --script ssl-enum-ciphers -p 443 target.com

# Check for HTTP exposure
curl -I http://target.com/login
```

---

## A03: Injection

**What to test:**
- SQL injection in all input fields and URL parameters
- Command injection in file upload, search, or processing features
- LDAP injection in authentication forms
- XSS (reflected, stored, DOM-based) in user inputs

**Tools:** SQLMap, Burp Suite Intruder, custom scripts

**Example test:**
```
# Basic SQL injection tests
' OR '1'='1
' UNION SELECT NULL,NULL--
'; WAITFOR DELAY '0:0:5'--

# XSS test
<script>alert(document.cookie)</script>
"><img src=x onerror=alert(1)>
```

---

## A04: Insecure Design

**What to test:**
- Business logic flaws (negative quantities, race conditions)
- Missing rate limiting on sensitive operations
- Lack of input validation at the design level
- Missing security controls in user workflows

**Approach:** Threat modeling, abuse case analysis

---

## A05: Security Misconfiguration

**What to test:**
- Default credentials on admin panels and services
- Unnecessary HTTP methods enabled (PUT, DELETE, TRACE)
- Directory listing enabled
- Missing security headers (CSP, HSTS, X-Frame-Options)
- Verbose error messages exposing stack traces

**Tools:** Nikto, SecurityHeaders.com, custom header checker

**Example test:**
```bash
# Check HTTP methods
curl -X OPTIONS http://target.com -I

# Check for directory listing
curl http://target.com/images/
```

---

## A06: Vulnerable and Outdated Components

**What to test:**
- Known CVEs in frameworks, libraries, and server software
- Outdated CMS versions (WordPress, Drupal)
- Unpatched server software (Apache, Nginx, OpenSSH)

**Tools:** WhatWeb, Wappalyzer, retire.js, npm audit

---

## A07: Identification and Authentication Failures

**What to test:**
- Brute force login without lockout
- Weak password policies
- Session fixation and insecure session management
- Missing MFA on critical operations
- Password reset token predictability

**Tools:** Hydra, Burp Suite Intruder, custom scripts

---

## A08: Software and Data Integrity Failures

**What to test:**
- Insecure deserialization
- CI/CD pipeline security
- Unsigned updates or dependencies
- Supply chain vulnerabilities

---

## A09: Security Logging and Monitoring Failures

**What to test:**
- Failed login attempts not logged
- No alerting on suspicious activity
- Logs stored without integrity protection
- Insufficient audit trail for sensitive operations

**Approach:** Review logging configuration, test alert triggers

---

## A10: Server-Side Request Forgery (SSRF)

**What to test:**
- URL parameters that fetch external resources
- File upload features that accept URLs
- Webhook configurations
- PDF generators or screenshot services

**Example test:**
```
# Test for SSRF
url=http://169.254.169.254/latest/meta-data/
url=http://localhost:6379/
url=http://127.0.0.1:22/
```
