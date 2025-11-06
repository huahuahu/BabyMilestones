#!/bin/bash
# Format Swift code using SwiftFormat
# This script should be run on macOS with SwiftFormat installed
#
# Usage:
#   ./format.sh        # Check formatting
#   ./format.sh --fix  # Fix formatting issues

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SWIFTFORMAT_CONFIG="$REPO_ROOT/.swiftformat"

if ! command -v swiftformat &> /dev/null; then
    echo "❌ SwiftFormat not found"
    echo "Install via Homebrew: brew install swiftformat"
    echo "Or via Mint: mint install nicklockwood/SwiftFormat"
    exit 1
fi

echo "🔍 Running SwiftFormat..."
echo "Config: $SWIFTFORMAT_CONFIG"
echo "Target: $REPO_ROOT/app-ios"

if [ "$1" == "--fix" ]; then
    echo "Mode: Fix"
    swiftformat "$REPO_ROOT/app-ios" --config "$SWIFTFORMAT_CONFIG"
    echo "✅ Formatting applied"
else
    echo "Mode: Check"
    if swiftformat "$REPO_ROOT/app-ios" --config "$SWIFTFORMAT_CONFIG" --lint; then
        echo "✅ Code is properly formatted"
    else
        echo "❌ Formatting issues found"
        echo "Run './format.sh --fix' to auto-fix"
        exit 1
    fi
fi
