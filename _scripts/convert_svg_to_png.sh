#!/bin/bash
# Convert SVG images to PNG for social media sharing
# Requires: cairosvg (pip install cairosvg) or rsvg-convert (brew install librsvg)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGES_DIR="$SCRIPT_DIR/../assets/images"

# Check for available converter
if command -v cairosvg &> /dev/null; then
    CONVERTER="cairosvg"
elif command -v rsvg-convert &> /dev/null; then
    CONVERTER="rsvg"
else
    echo "Error: No SVG converter found."
    echo "Install one of:"
    echo "  pip install cairosvg"
    echo "  brew install librsvg"
    exit 1
fi

echo "Using converter: $CONVERTER"

# Convert favicon (32x32)
if [ -f "$IMAGES_DIR/favicon.svg" ]; then
    echo "Converting favicon.svg..."
    if [ "$CONVERTER" = "cairosvg" ]; then
        cairosvg "$IMAGES_DIR/favicon.svg" -o "$IMAGES_DIR/favicon.png" -W 32 -H 32
    else
        rsvg-convert -w 32 -h 32 "$IMAGES_DIR/favicon.svg" > "$IMAGES_DIR/favicon.png"
    fi
fi

# Convert logo (200x48)
if [ -f "$IMAGES_DIR/logo.svg" ]; then
    echo "Converting logo.svg..."
    if [ "$CONVERTER" = "cairosvg" ]; then
        cairosvg "$IMAGES_DIR/logo.svg" -o "$IMAGES_DIR/logo.png" -W 200 -H 48
    else
        rsvg-convert -w 200 -h 48 "$IMAGES_DIR/logo.svg" > "$IMAGES_DIR/logo.png"
    fi
fi

# Convert og-image (1200x630 for Twitter/OG)
if [ -f "$IMAGES_DIR/og-image.svg" ]; then
    echo "Converting og-image.svg..."
    if [ "$CONVERTER" = "cairosvg" ]; then
        cairosvg "$IMAGES_DIR/og-image.svg" -o "$IMAGES_DIR/og-image.png" -W 1200 -H 630
    else
        rsvg-convert -w 1200 -h 630 "$IMAGES_DIR/og-image.svg" > "$IMAGES_DIR/og-image.png"
    fi
fi

echo "Done! PNG files generated in $IMAGES_DIR"
