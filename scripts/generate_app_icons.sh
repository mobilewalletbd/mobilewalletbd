#!/bin/bash

# App Icon Generation Script
# This script generates app icons for all platforms from a source image
# Usage: ./generate_app_icons.sh <source_image_path>

set -e

SOURCE_IMAGE="$1"
OUTPUT_DIR="assets/icons/generated"

if [ -z "$SOURCE_IMAGE" ]; then
    echo "Usage: $0 <source_image_path>"
    echo "Example: $0 assets/images/logo.png"
    exit 1
fi

if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Error: Source image '$SOURCE_IMAGE' not found"
    exit 1
fi

echo "Generating app icons from: $SOURCE_IMAGE"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to resize image
resize_image() {
    local input="$1"
    local output="$2"
    local size="$3"
    
    if command -v convert >/dev/null 2>&1; then
        # Using ImageMagick
        convert "$input" -resize "${size}x${size}" -background none -gravity center -extent "${size}x${size}" "$output"
    elif command -v sips >/dev/null 2>&1; then
        # Using macOS sips
        sips -z "$size" "$size" "$input" --out "$output" >/dev/null 2>&1
    else
        echo "Warning: No image processing tool found (ImageMagick or sips)"
        echo "Please install ImageMagick: brew install imagemagick"
        echo "Or manually resize the images to required dimensions"
        # Create placeholder file
        touch "$output"
    fi
}

# Generate Android icons
echo "Generating Android icons..."

# Legacy icons
ANDROID_RES_DIR="android/app/src/main/res"
resize_image "$SOURCE_IMAGE" "$ANDROID_RES_DIR/mipmap-mdpi/ic_launcher.png" 48
resize_image "$SOURCE_IMAGE" "$ANDROID_RES_DIR/mipmap-hdpi/ic_launcher.png" 72
resize_image "$SOURCE_IMAGE" "$ANDROID_RES_DIR/mipmap-xhdpi/ic_launcher.png" 96
resize_image "$SOURCE_IMAGE" "$ANDROID_RES_DIR/mipmap-xxhdpi/ic_launcher.png" 144
resize_image "$SOURCE_IMAGE" "$ANDROID_RES_DIR/mipmap-xxxhdpi/ic_launcher.png" 192

# Adaptive icon foreground (simplified - should be properly designed)
cp "$SOURCE_IMAGE" "$ANDROID_RES_DIR/drawable/ic_launcher_foreground.png"

# Generate iOS icons
echo "Generating iOS icons..."

IOS_ICONSET="ios/Runner/Assets.xcassets/AppIcon.appiconset"
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-20x20@1x.png" 20
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-20x20@2x.png" 40
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-20x20@3x.png" 60
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-29x29@1x.png" 29
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-29x29@2x.png" 58
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-29x29@3x.png" 87
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-40x40@1x.png" 40
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-40x40@2x.png" 80
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-40x40@3x.png" 120
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-60x60@2x.png" 120
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-60x60@3x.png" 180
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-76x76@1x.png" 76
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-76x76@2x.png" 152
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-83.5x83.5@2x.png" 167
resize_image "$SOURCE_IMAGE" "$IOS_ICONSET/Icon-App-1024x1024@1x.png" 1024

# Generate macOS icons
echo "Generating macOS icons..."

MACOS_ICONSET="macos/Runner/Assets.xcassets/AppIcon.appiconset"
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_16.png" 16
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_32.png" 32
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_64.png" 64
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_128.png" 128
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_256.png" 256
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_512.png" 512
resize_image "$SOURCE_IMAGE" "$MACOS_ICONSET/app_icon_1024.png" 1024

echo "✅ App icon generation completed!"
echo ""
echo "Next steps:"
echo "1. Verify all generated icons look correct"
echo "2. For Android adaptive icons, manually design proper foreground/background"
echo "3. For iOS, check that icons display well on both light and dark backgrounds"
echo "4. Test icons on actual devices/simulators"
echo "5. Update app store listings with 1024x1024 versions"