# App Icons Directory

This directory contains the source app icon files used for generating platform-specific icons.

## Files
- `logo.png` - Main app logo (used for generating all platform icons)
- `logo.ico` - Windows icon file

## Platform Icon Requirements

### Android
- Adaptive icon (foreground + background)
- Legacy icons for different densities:
  - mipmap-mdpi (48x48)
  - mipmap-hdpi (72x72)
  - mipmap-xhdpi (96x96)
  - mipmap-xxhdpi (144x144)
  - mipmap-xxxhdpi (192x192)

### iOS
- App Store icon: 1024x1024
- iPhone icons: 20x20, 29x29, 40x40, 60x60 (various scales)
- iPad icons: 20x20, 29x29, 40x40, 76x76, 83.5x83.5 (various scales)

### macOS
- App Store icon: 1024x1024
- Various sizes: 16x16, 32x32, 64x64, 128x128, 256x256, 512x512

## Generation Process
Icons are generated from the source `logo.png` using image editing software or automated tools to ensure:
- Proper sizing for each platform
- Correct aspect ratios
- Brand consistency
- Transparency handling where appropriate

## Brand Guidelines
- Primary Green: #0BBF7D (should be prominent in icon design)
- Clean, professional appearance
- Recognizable at small sizes
- Consistent with splash screen and in-app branding