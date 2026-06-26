#!/bin/bash
# Build the bootstrap package for soph1e ra1n jailbreak
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOTSTRAP_DIR="$(dirname "$SCRIPT_DIR")/bootstrap"
OUTPUT_DIR="$BOOTSTRAP_DIR/build"

echo "==> soph1e ra1n Bootstrap Builder"
echo ""

BOOTSTRAP_VER="1.0.0"
BOOTSTRAP_ARCH="iphoneos-arm64"

echo "Bootstrap version: $BOOTSTRAP_VER"
echo "Architecture: $BOOTSTRAP_ARCH"
echo ""

# Create directory structure
mkdir -p "$OUTPUT_DIR/bootstrap"
mkdir -p "$OUTPUT_DIR/bootstrap/usr/bin"
mkdir -p "$OUTPUT_DIR/bootstrap/usr/lib"
mkdir -p "$OUTPUT_DIR/bootstrap/etc"
mkdir -p "$OUTPUT_DIR/bootstrap/Library"

# Write version info
echo "soph1e ra1n bootstrap v$BOOTSTRAP_VER" > "$OUTPUT_DIR/bootstrap/version.txt"
echo "Built: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$OUTPUT_DIR/bootstrap/version.txt"
echo "Exploit: soph1e ra1n" >> "$OUTPUT_DIR/bootstrap/version.txt"

# Write APT sources list
mkdir -p "$OUTPUT_DIR/bootstrap/etc/apt"
mkdir -p "$OUTPUT_DIR/bootstrap/etc/apt/sources.list.d"
cat > "$OUTPUT_DIR/bootstrap/etc/apt/sources.list.d/sileo.sources" << 'SOURCESEOF'
Types: deb
URIs: https://repo.chariz.com/
Suites: ./
Components: 
SOURCESEOF

# Essential packages list
cat > "$OUTPUT_DIR/bootstrap/packages.txt" << 'PKGSEOF'
# Essential bootstrap packages
firmware-sbin
org.thebigboss.repo.icons
shell-cmds
system-cmds
tar
unzip
zip
sed
grep
awk
PKGSEOF

# Reinstall script (runs on-device)
cat > "$OUTPUT_DIR/bootstrap/reinstall.sh" << 'REINSTALLEOF'
#!/bin/bash
# Reinstall bootstrap packages
echo "soph1e ra1n: Reinstalling bootstrap..."
apt-get update
apt-get install -y firmware-sbin shell-cmds system-cmds tar unzip zip
echo "Bootstrap reinstalled successfully"
REINSTALLEOF
chmod +x "$OUTPUT_DIR/bootstrap/reinstall.sh"

# Create bootstrap tar
cd "$OUTPUT_DIR"
tar -czf "soph1e ra1n-bootstrap-$BOOTSTRAP_VER.tar.gz" bootstrap/

echo ""
echo "Bootstrap package created:"
echo "  $OUTPUT_DIR/soph1e ra1n-bootstrap-$BOOTSTRAP_VER.tar.gz"
echo ""
echo "Contents:"
ls -la "$OUTPUT_DIR/bootstrap/"
echo ""
echo "To install on device:"
echo "  scp soph1e ra1n-bootstrap-$BOOTSTRAP_VER.tar.gz root@device:/"
echo "  ssh root@device 'tar -xzf soph1e ra1n-bootstrap-$BOOTSTRAP_VER.tar.gz -C /'"
