# HackerOne Bug Report Template

## Title
[Vuln Type] in [Feature/Endpoint] allows [Impact] on [target.com]

---

## Summary
A [vulnerability type] was discovered in [endpoint/feature] that allows an attacker to [impact description]. This vulnerability exists because [root cause].

## Severity
**[Critical / High / Medium / Low]**

CVSS Score: X.X
CVSS Vector: [Use https://www.first.org/cvss/calculator/3.1]

## Steps to Reproduce

1. Navigate to `https://target.com/endpoint`
2. [Login as regular user / No authentication needed]
3. [Intercept request with Burp Suite]
4. [Modify parameter X to Y]
5. [Forward the request]
6. [Observe the response / behavior]

## Proof of Concept

### HTTP Request
```http
POST /api/endpoint HTTP/1.1
Host: target.com
Authorization: Bearer [token]
Content-Type: application/json

{"user_id": "1002"}
```

### HTTP Response
```http
HTTP/1.1 200 OK
Content-Type: application/json

{"name": "victim_user", "email": "victim@email.com"}
```

### Screenshots
[Attach screenshots showing the vulnerability]

## Impact
An attacker could exploit this vulnerability to:
- [Impact 1: e.g., access other users' data]
- [Impact 2: e.g., modify account settings]
- [Impact 3: e.g., escalate privileges]

**Business Impact:** [Describe real-world consequences]

## Affected Scope
- **URL:** `https://target.com/api/endpoint`
- **Parameter:** `user_id`
- **Method:** POST

## Remediation
- [Recommendation 1: e.g., Implement proper authorization checks]
- [Recommendation 2: e.g., Validate user ownership of resources]

## References
- [OWASP reference link]
- [CWE reference link]

---

## Common Bug Types — Quick Reference

### IDOR Report Title Examples
- [IDOR] in /api/users/{id} allows accessing other users' profiles
- [IDOR] in /api/orders/{id}/invoice allows downloading other users' invoices

### XSS Report Title Examples
- [Reflected XSS] in search parameter on example.com/search
- [Stored XSS] in user profile bio field affects all viewers

### Broken Access Control Title Examples
- [BAC] Regular user can access admin panel at /admin/dashboard
- [BAC] Unauthenticated access to /api/internal/users endpoint

### Info Disclosure Title Examples
- [Info Disclosure] API key exposed in /static/js/app.js
- [Info Disclosure] Debug endpoint /api/debug leaks server configuration
