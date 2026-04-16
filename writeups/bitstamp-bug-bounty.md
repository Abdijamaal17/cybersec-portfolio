# Bug Bounty: Bitstamp Cryptocurrency Exchange

**Target:** Bitstamp Ltd (bitstamp.net)
**Platform:** HackerOne
**Handle:** milhox17
**Scope:** Web application, API endpoints, subdomains in scope
**Status:** Active / Ongoing research

---

## Reconnaissance Summary

### Subdomain Enumeration
Discovered **64 active subdomains** using Subfinder, Amass, and DNS brute-forcing.

```bash
subfinder -d bitstamp.net -o bitstamp-subs.txt
amass enum -passive -d bitstamp.net >> bitstamp-subs.txt
sort -u bitstamp-subs.txt | httpx -status-code -title
```

Key subdomains identified:
- api.bitstamp.net — Primary REST/WebSocket API
- www.bitstamp.net — Main web application
- auth.bitstamp.net — Authentication service
- cdn.bitstamp.net — Static assets

### API Surface Mapping
Mapped **100+ API endpoints** through JavaScript bundle analysis, Wayback Machine historical crawl, and manual review.

```bash
waybackurls bitstamp.net | grep "api" | sort -u
gau bitstamp.net --providers wayback,otx,commoncrawl
```

---

## Findings

### Finding 1: AWS Credentials Exposure in Archived URLs

**Severity:** Critical (CVSS 9.0+)
**CWE:** CWE-312 — Cleartext Storage of Sensitive Information

**Description:**
During Wayback Machine analysis, discovered archived URLs containing AWS access keys embedded in query parameters of historical JavaScript files indexed before proper secret rotation.

**Endpoint Pattern:**
```
https://cdn.bitstamp.net/static/js/[hash].js?AWSAccessKeyId=AKIA[REDACTED]&Signature=[REDACTED]
```

**Impact:**
- Potential unauthorized access to AWS S3 buckets
- Risk of data exfiltration of customer data
- Possible lateral movement within cloud infrastructure

**Remediation:**
- Rotate all exposed AWS keys immediately
- Implement secret scanning in CI/CD pipeline (Trufflehog, GitLeaks)
- Use pre-signed URLs with short expiry instead of static credentials

---

### Finding 2: IDOR in Account Data Endpoint

**Severity:** High (CVSS 7.5)
**CWE:** CWE-639 — Authorization Bypass Through User-Controlled Key

**Description:**
Identified a potential Insecure Direct Object Reference vulnerability in the account management API. By manipulating the account_id parameter in authenticated requests, it was possible to enumerate whether other account IDs existed in the system.

**Request:**
```http
GET /api/v2/user_transactions/?account_id=1002 HTTP/1.1
Host: www.bitstamp.net
Authorization: Bearer [YOUR_TOKEN]
```

**Steps to Reproduce:**
1. Authenticate to bitstamp.net with valid account
2. Intercept transaction history request with Burp Suite
3. Modify account_id to another user's ID
4. Observe response — different behavior between existing vs non-existing IDs

**Impact:**
User account enumeration enabling targeted phishing and account takeover attempts.

**Remediation:**
- Implement server-side authorization: verify requesting user owns the account_id
- Return identical error responses for unauthorized vs non-existent resources

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Subfinder | Subdomain enumeration |
| Amass | Passive DNS enumeration |
| httpx | HTTP probing and status checking |
| Waybackurls | Historical URL discovery |
| GAU | URL collection from multiple sources |
| Burp Suite Pro | Manual traffic interception and testing |
| Nuclei | Automated vulnerability scanning |
| TruffleHog | Secret scanning in URLs |

---

## Methodology

1. **Passive Recon** — Subdomain enum, Wayback crawl, JS file analysis
2. **Active Recon** — httpx probing, Nuclei scan on in-scope assets
3. **Manual Testing** — IDOR, auth bypass, business logic flaws
4. **Reporting** — HackerOne report with PoC, CVSS scoring, remediation

---

*All testing conducted within authorized scope. Findings reported through HackerOne responsible disclosure program.*
