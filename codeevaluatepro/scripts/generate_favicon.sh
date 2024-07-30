#!/bin/bash

# Set colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Set the output directory
OUTPUT_DIR="resources/public"

echo -e "${CYAN}Generating favicon.ico in ${OUTPUT_DIR}...${NC}"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Check if magick command is available
if command -v magick &> /dev/null; then
    CMD="magick"
    echo -e "${YELLOW}Using ImageMagick v7+ (magick command)${NC}"
else
    CMD="convert"
    echo -e "${YELLOW}Using ImageMagick v6 or lower (convert command)${NC}"
fi

# Create a 256x256 image with a blue background and white 'CE' text
$CMD -size 256x256 xc:#4A90E2 -font Helvetica -pointsize 144 -fill white -gravity center -draw "text 0,0 'CE'" "${OUTPUT_DIR}/favicon_256.png"

# Create favicon.ico with multiple sizes
$CMD "${OUTPUT_DIR}/favicon_256.png" \
  \( -clone 0 -resize 16x16 \) \
  \( -clone 0 -resize 32x32 \) \
  \( -clone 0 -resize 48x48 \) \
  \( -clone 0 -resize 64x64 \) \
  -delete 0 -alpha off -colors 256 "${OUTPUT_DIR}/favicon.ico"

# Clean up temporary file
rm "${OUTPUT_DIR}/favicon_256.png"

echo -e "${GREEN}favicon.ico has been generated successfully in ${OUTPUT_DIR}!${NC}"
