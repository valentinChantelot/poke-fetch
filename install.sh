#!/usr/bin/env bash

# poke-fetch installer
# Simple installation script that works on any distro

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local all_found=true
    
    # Check fastfetch
    if ! command -v fastfetch >/dev/null 2>&1; then
        print_error "fastfetch is not installed"
        echo "         Install it from: https://github.com/fastfetch-cli/fastfetch"
        all_found=false
    else
        print_success "fastfetch is installed"
    fi
    
    # Check pokemon-colorscripts
    if ! command -v pokemon-colorscripts >/dev/null 2>&1; then
        print_error "pokemon-colorscripts is not installed"
        echo "         Install it from: https://gitlab.com/phoneybadger/pokemon-colorscripts"
        all_found=false
    else
        print_success "pokemon-colorscripts is installed"
    fi
    
    if [[ "$all_found" == false ]]; then
        echo ""
        print_warning "Please install missing dependencies and run this script again"
        exit 1
    fi
    
    echo ""
}

# Install the script
install_script() {
    local install_dir="$HOME/.local/bin"
    local script_path="$install_dir/poke-fetch"
    
    print_info "Installing poke-fetch script..."
    
    # Create directory if it doesn't exist
    if [[ ! -d "$install_dir" ]]; then
        mkdir -p "$install_dir"
        print_success "Created directory: $install_dir"
    fi
    
    # Check if script already exists
    if [[ -f "$script_path" ]]; then
        print_warning "poke-fetch already exists at $script_path"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Create the script
    cat > "$script_path" << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

# Check fastfetch dependency
command -v fastfetch >/dev/null 2>&1 || {
    echo "❌ fastfetch is not installed" >&2
    exit 1
}

if command -v pokemon-colorscripts >/dev/null 2>&1; then
    fastfetch_cmd=(fastfetch --file-raw /dev/stdin --logo-padding-left 4)
    
    # Hardcoded, depends on the config - maybe a future improvement
    fastfetch_height=15
    
    # Get generated pokemon height
    pokemon_output=$(pokemon-colorscripts -r --no-title)
    pokemon_lines=$(echo "$pokemon_output" | wc -l)
    
    if (( fastfetch_height > pokemon_lines )); then
        padding=$(( (fastfetch_height - pokemon_lines) / 2 ))
        {
            for ((i=0; i<padding; i++)); do
                echo
            done
            echo "$pokemon_output"
        } | "${fastfetch_cmd[@]}"
    else
        echo "$pokemon_output" | "${fastfetch_cmd[@]}"
    fi
else
    fastfetch
fi
EOF
    
    # Make executable
    chmod +x "$script_path"
    print_success "Script installed at: $script_path"
    echo ""
}

# Check PATH
check_path() {
    print_info "Checking PATH configuration..."
    
    if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
        print_success "~/.local/bin is in your PATH"
        echo ""
    else
        print_warning "~/.local/bin is NOT in your PATH"
        echo ""
        print_info "Add this line to your shell configuration file:"
        echo ""
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        print_info "For zsh, add it to: ~/.zshrc"
        print_info "For bash, add it to: ~/.bashrc"
        echo ""
        print_info "Then reload your shell or run:"
        print_info "  - for zsh: source ~/.zshrc"
        print_info "  - for bash: source ~/.bashrc"
        echo ""
    fi
}

# Main installation
main() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║     poke-fetch Installation Script   ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    check_dependencies
    install_script
    check_path
    
    print_success "Installation complete!"
    echo ""
    print_info "To test, run: poke-fetch"
    print_info "Or add it to your shell config to run automatically"
    echo ""
}

# Run installation
main