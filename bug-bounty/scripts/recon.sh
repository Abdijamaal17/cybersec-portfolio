#!/bin/bash
# ============================================================================
#  AUTOMATED BUG BOUNTY RECON SCRIPT
#  Author: Abdijamaal
#  Usage: ./recon.sh target.com
#  Requirements: subfinder, httpx, nuclei, waybackurls, gau, nmap
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

banner() {
    echo -e "${RED}"
    echo "  +==================================================+"
    echo "  |         BUG BOUNTY RECON AUTOMATION             |"
    echo "  |              by Abdijamaal                       |"
    echo "  +==================================================+"
    echo -e "${NC}"
}

usage() {
    echo -e "${YELLOW}Usage:${NC} $0 <domain> [options]"
    echo "Options:"
    echo "  -o, --output    Output directory (default: ./recon-<domain>)"
    echo "  -f, --full      Full scan (port scan + nuclei)"
    echo "  -q, --quick     Quick scan (subdomain enum + live check only)"
    echo "  -p, --passive   Passive only (no active scanning)"
    echo "  -h, --help      Show this help"
    exit 1
}

check_tools() {
    local tools=("subfinder" "httpx" "nuclei" "nmap" "curl" "jq")
    local missing=()
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            if [ "$tool" = "httpx" ] && command -v "httpx-toolkit" &>/dev/null; then
                continue
            fi
            missing+=("$tool")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}[!] Missing tools: ${missing[*]}${NC}"
        echo -e "${YELLOW}[*] Run: ./install-tools.sh${NC}"
    fi
}

log_info()    { echo -e "${BLUE}[*]${NC} $1"; }
log_success() { echo -e "${GREEN}[+]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[-]${NC} $1"; }
log_section() { echo -e "\n${PURPLE}${BOLD}======== $1 ========${NC}\n"; }

DOMAIN=""
OUTPUT_DIR=""
SCAN_MODE="normal"

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
        -f|--full)   SCAN_MODE="full"; shift ;;
        -q|--quick)  SCAN_MODE="quick"; shift ;;
        -p|--passive) SCAN_MODE="passive"; shift ;;
        -h|--help)   usage ;;
        *)           DOMAIN="$1"; shift ;;
    esac
done

if [ -z "$DOMAIN" ]; then banner; usage; fi
if [ -z "$OUTPUT_DIR" ]; then OUTPUT_DIR="./recon-${DOMAIN}"; fi

mkdir -p "$OUTPUT_DIR"/{subdomains,urls,vulns,ports,js,params}

HTTPX_CMD="httpx"
command -v httpx-toolkit &>/dev/null && HTTPX_CMD="httpx-toolkit"

START_TIME=$(date +%s)
banner
log_info "Target: ${BOLD}$DOMAIN${NC}"
log_info "Output: ${BOLD}$OUTPUT_DIR${NC}"
log_info "Mode:   ${BOLD}$SCAN_MODE${NC}"
check_tools

# ── PHASE 1: SUBDOMAIN ENUMERATION ──────────────────────────────────────────
log_section "PHASE 1: SUBDOMAIN ENUMERATION"

if command -v subfinder &>/dev/null; then
    log_info "Running subfinder..."
    subfinder -d "$DOMAIN" -silent -o "$OUTPUT_DIR/subdomains/subfinder.txt" 2>/dev/null
    SUB_COUNT=$(wc -l < "$OUTPUT_DIR/subdomains/subfinder.txt" 2>/dev/null || echo "0")
    log_success "Subfinder found: $SUB_COUNT subdomains"
fi

if command -v amass &>/dev/null; then
    log_info "Running amass (passive)..."
    timeout 300 amass enum -passive -d "$DOMAIN" -o "$OUTPUT_DIR/subdomains/amass.txt" 2>/dev/null || true
fi

log_info "Querying crt.sh..."
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" 2>/dev/null | \
    jq -r '.[].name_value' 2>/dev/null | \
    sed 's/\*\.//g' | sort -u > "$OUTPUT_DIR/subdomains/crtsh.txt" 2>/dev/null || true
CRT_COUNT=$(wc -l < "$OUTPUT_DIR/subdomains/crtsh.txt" 2>/dev/null || echo "0")
log_success "crt.sh found: $CRT_COUNT subdomains"

cat "$OUTPUT_DIR"/subdomains/*.txt 2>/dev/null | sort -u > "$OUTPUT_DIR/subdomains/all.txt"
TOTAL_SUBS=$(wc -l < "$OUTPUT_DIR/subdomains/all.txt" 2>/dev/null || echo "0")
log_success "Total unique subdomains: ${BOLD}$TOTAL_SUBS${NC}"

# ── PHASE 2: LIVE HOST DETECTION ─────────────────────────────────────────────
log_section "PHASE 2: LIVE HOST DETECTION"

cat "$OUTPUT_DIR/subdomains/all.txt" | \
    $HTTPX_CMD -silent -status-code -title -tech-detect -follow-redirects \
    -o "$OUTPUT_DIR/subdomains/live-detailed.txt" 2>/dev/null

cat "$OUTPUT_DIR/subdomains/all.txt" | \
    $HTTPX_CMD -silent -o "$OUTPUT_DIR/subdomains/live.txt" 2>/dev/null

LIVE_COUNT=$(wc -l < "$OUTPUT_DIR/subdomains/live.txt" 2>/dev/null || echo "0")
log_success "Live hosts: ${BOLD}$LIVE_COUNT${NC}"

if [ "$SCAN_MODE" = "quick" ]; then
    log_warning "Quick mode — skipping remaining phases"
    log_success "Results: $OUTPUT_DIR"
    exit 0
fi

# ── PHASE 3: URL DISCOVERY ───────────────────────────────────────────────────
log_section "PHASE 3: URL DISCOVERY"

if command -v waybackurls &>/dev/null; then
    log_info "Fetching wayback URLs..."
    cat "$OUTPUT_DIR/subdomains/all.txt" | waybackurls 2>/dev/null | sort -u > "$OUTPUT_DIR/urls/wayback.txt"
    WB_COUNT=$(wc -l < "$OUTPUT_DIR/urls/wayback.txt" 2>/dev/null || echo "0")
    log_success "Wayback URLs: $WB_COUNT"
fi

if command -v gau &>/dev/null; then
    log_info "Fetching GAU URLs..."
    cat "$OUTPUT_DIR/subdomains/all.txt" | gau --threads 5 2>/dev/null | sort -u > "$OUTPUT_DIR/urls/gau.txt"
    GAU_COUNT=$(wc -l < "$OUTPUT_DIR/urls/gau.txt" 2>/dev/null || echo "0")
    log_success "GAU URLs: $GAU_COUNT"
fi

cat "$OUTPUT_DIR"/urls/*.txt 2>/dev/null | sort -u > "$OUTPUT_DIR/urls/all.txt"
TOTAL_URLS=$(wc -l < "$OUTPUT_DIR/urls/all.txt" 2>/dev/null || echo "0")
log_success "Total unique URLs: ${BOLD}$TOTAL_URLS${NC}"

grep -iE '\.(js|json|xml|config|env|bak|old|sql|log|zip|tar|gz)(\?|$)' \
    "$OUTPUT_DIR/urls/all.txt" > "$OUTPUT_DIR/urls/interesting-files.txt" 2>/dev/null || true

grep -iE '(api|graphql|admin|login|auth|token|upload|config|debug|staging)' \
    "$OUTPUT_DIR/urls/all.txt" > "$OUTPUT_DIR/urls/interesting-endpoints.txt" 2>/dev/null || true

grep -iE '(=|&)' "$OUTPUT_DIR/urls/all.txt" > "$OUTPUT_DIR/urls/parameterized.txt" 2>/dev/null || true

INT_FILES=$(wc -l < "$OUTPUT_DIR/urls/interesting-files.txt" 2>/dev/null || echo "0")
INT_ENDPOINTS=$(wc -l < "$OUTPUT_DIR/urls/interesting-endpoints.txt" 2>/dev/null || echo "0")
PARAM_URLS=$(wc -l < "$OUTPUT_DIR/urls/parameterized.txt" 2>/dev/null || echo "0")

log_success "Interesting files: $INT_FILES | Endpoints: $INT_ENDPOINTS | Parameterized: $PARAM_URLS"

if [ "$SCAN_MODE" = "passive" ]; then
    log_success "Passive mode done. Results: $OUTPUT_DIR"
    exit 0
fi

# ── PHASE 4: VULNERABILITY SCANNING ─────────────────────────────────────────
log_section "PHASE 4: VULNERABILITY SCANNING"

if command -v nuclei &>/dev/null; then
    log_info "Running Nuclei..."
    nuclei -l "$OUTPUT_DIR/subdomains/live.txt" \
        -severity critical,high,medium -silent \
        -o "$OUTPUT_DIR/vulns/nuclei.txt" 2>/dev/null || true
    VULN_COUNT=$(wc -l < "$OUTPUT_DIR/vulns/nuclei.txt" 2>/dev/null || echo "0")
    log_success "Nuclei findings: ${BOLD}$VULN_COUNT${NC}"
fi

# ── PHASE 5: PORT SCANNING (full mode) ───────────────────────────────────────
if [ "$SCAN_MODE" = "full" ]; then
    log_section "PHASE 5: PORT SCANNING"
    head -20 "$OUTPUT_DIR/subdomains/live.txt" | sed 's|https\?://||' | cut -d'/' -f1 | \
        while read host; do
            nmap -sV -sC --top-ports 1000 -T4 "$host" \
                -oN "$OUTPUT_DIR/ports/nmap-${host}.txt" 2>/dev/null || true
        done
    log_success "Port scan complete"
fi

# ── PHASE 6: JS ANALYSIS ─────────────────────────────────────────────────────
log_section "PHASE 6: JS FILE ANALYSIS"

grep -iE '\.js(\?|$)' "$OUTPUT_DIR/urls/all.txt" | sort -u > "$OUTPUT_DIR/js/js-files.txt" 2>/dev/null || true
JS_COUNT=$(wc -l < "$OUTPUT_DIR/js/js-files.txt" 2>/dev/null || echo "0")
log_success "JS files found: $JS_COUNT"

if [ "$JS_COUNT" -gt 0 ]; then
    log_info "Searching for secrets in JS files (max 50)..."
    head -50 "$OUTPUT_DIR/js/js-files.txt" | while read url; do
        curl -s -L --max-time 10 "$url" 2>/dev/null | \
            grep -iEo '(api[_-]?key|api[_-]?secret|access[_-]?token|auth[_-]?token|aws[_-]?access)["']?\s*[:=]\s*["']?[a-zA-Z0-9_\-]{8,}' \
            >> "$OUTPUT_DIR/js/secrets.txt" 2>/dev/null || true
    done
    SECRETS=$(wc -l < "$OUTPUT_DIR/js/secrets.txt" 2>/dev/null || echo "0")
    [ "$SECRETS" -gt 0 ] && log_success "${RED}Potential secrets: $SECRETS (CHECK THESE!)${NC}" || log_info "No obvious secrets found"
fi

# ── REPORT ───────────────────────────────────────────────────────────────────
log_section "GENERATING REPORT"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECS=$((DURATION % 60))

cat > "$OUTPUT_DIR/REPORT.md" << REPORTEOF
# Recon Report: $DOMAIN
Date: $(date) | Duration: ${MINUTES}m ${SECS}s | Mode: $SCAN_MODE

## Summary
| Metric | Count |
|--------|-------|
| Subdomains | $TOTAL_SUBS |
| Live hosts | $LIVE_COUNT |
| Total URLs | $TOTAL_URLS |
| Interesting files | $INT_FILES |
| Interesting endpoints | $INT_ENDPOINTS |
| Parameterized URLs | $PARAM_URLS |
| JS files | $JS_COUNT |
| Nuclei findings | ${VULN_COUNT:-N/A} |

## Next Steps
1. Review nuclei findings
2. Test parameterized URLs for SQLi/XSS
3. Check API endpoints for IDOR
4. Review JS secrets
5. Manual Burp Suite testing
REPORTEOF

echo -e "${GREEN}${BOLD}RECON COMPLETE! Duration: ${MINUTES}m ${SECS}s${NC}"
log_success "Results saved to: $OUTPUT_DIR"
