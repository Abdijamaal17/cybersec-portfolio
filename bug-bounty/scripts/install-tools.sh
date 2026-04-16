#!/bin/bash
# ============================================================================
#  BUG BOUNTY TOOL INSTALLER FOR KALI LINUX
#  Run: chmod +x install-tools.sh && sudo ./install-tools.sh
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}"
echo "  +==================================================+"
echo "  |       BUG BOUNTY TOOL INSTALLER                  |"
echo "  +==================================================+"
echo -e "${NC}"

# System packages
echo -e "${YELLOW}[*] Installing system packages...${NC}"
apt update -y
apt install -y \
    nmap \
    whatweb \
    wafw00f \
    dirsearch \
    sqlmap \
    nikto \
    wfuzz \
    seclists \
    wordlists \
    jq \
    curl \
    git \
    golang-go \
    python3-pip \
    chromium \
    2>/dev/null

# Go tools
echo -e "${YELLOW}[*] Installing Go-based tools...${NC}"
export PATH=$PATH:$(go env GOPATH)/bin

echo -e "${GREEN}[+] Installing subfinder...${NC}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null

echo -e "${GREEN}[+] Installing httpx...${NC}"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null

echo -e "${GREEN}[+] Installing nuclei...${NC}"
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null

echo -e "${GREEN}[+] Installing waybackurls...${NC}"
go install github.com/tomnomnom/waybackurls@latest 2>/dev/null

echo -e "${GREEN}[+] Installing gau...${NC}"
go install github.com/lc/gau/v2/cmd/gau@latest 2>/dev/null

echo -e "${GREEN}[+] Installing gf...${NC}"
go install github.com/tomnomnom/gf@latest 2>/dev/null

echo -e "${GREEN}[+] Installing ffuf...${NC}"
go install github.com/ffuf/ffuf/v2@latest 2>/dev/null

echo -e "${GREEN}[+] Installing subjack...${NC}"
go install github.com/haccer/subjack@latest 2>/dev/null

echo -e "${GREEN}[+] Installing dalfox...${NC}"
go install github.com/hahwul/dalfox/v2@latest 2>/dev/null

# Update Nuclei templates
echo -e "${YELLOW}[*] Updating nuclei templates...${NC}"
nuclei -update-templates 2>/dev/null || true

# Add Go bin to PATH permanently
GOPATH_BIN=$(go env GOPATH)/bin
if ! grep -q "GOPATH" ~/.zshrc 2>/dev/null; then
    echo "export PATH=\$PATH:$GOPATH_BIN" >> ~/.zshrc
fi
if ! grep -q "GOPATH" ~/.bashrc 2>/dev/null; then
    echo "export PATH=\$PATH:$GOPATH_BIN" >> ~/.bashrc
fi

echo ""
echo -e "${GREEN}ALL TOOLS INSTALLED!${NC}"
echo ""
echo -e "${YELLOW}Installed tools:${NC}"
echo "  subfinder    — Subdomain enumeration"
echo "  httpx        — HTTP probing & tech detection"
echo "  nuclei       — Vulnerability scanning"
echo "  waybackurls  — Wayback Machine URL fetcher"
echo "  gau          — Get All URLs"
echo "  gf           — Grep patterns for bounty"
echo "  ffuf         — Web fuzzer"
echo "  subjack      — Subdomain takeover checker"
echo "  dalfox       — XSS scanner"
echo "  dirsearch    — Directory brute-forcing"
echo "  sqlmap       — SQL injection automation"
echo "  nikto        — Web server scanner"
echo "  nmap         — Network scanner"
echo "  seclists     — Wordlists collection"
echo ""
echo -e "${YELLOW}Run: source ~/.zshrc && ./recon.sh target.com${NC}"
