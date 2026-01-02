#!/bin/bash
# Serve the documentation wiki locally using Docsify
# Usage: ./docs/serve.sh

cd "$(dirname "$0")"

# Check if docsify-cli is installed
if command -v docsify &> /dev/null; then
    echo "Starting Docsify server..."
    docsify serve .
else
    echo "docsify-cli not found, using Python HTTP server..."
    echo "For better experience, install docsify-cli: npm i -g docsify-cli"
    echo ""
    echo "Serving at http://localhost:3000"
    python3 -m http.server 3000
fi
