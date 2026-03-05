# App Icon Update Guide

## Current Status
✅ **Issue Identified**: App icon is showing default placeholder instead of proper branding
✅ **Platforms Affected**: Android, iOS, macOS
✅ **Source Asset Available**: `assets/images/logo.png` (84KB)

## Solution Overview
This guide provides steps to update the app icon across all platforms to use the proper branded logo.

## Files Modified/Added
- `assets/icons/README.md` - Documentation for icon assets
- `scripts/generate_app_icons.sh` - Bash script for Unix/Linux/macOS
- `scripts/generate_app_icons.ps1` - PowerShell script for Windows
- Updated platform-specific icon files (see below)

## Platform-Specific Implementation

### Android
**Location**: `android/app/src/main/res/`
**Files Updated**:
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)
- `drawable/ic_launcher_foreground.png` (adaptive icon foreground)

**Note**: Android uses adaptive icons on newer versions. The foreground should be designed to work with various background colors.

### iOS
**Location**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
**Files Updated**:
- Various sizes for iPhone and iPad (20x20 to 1024x1024)
- Proper @1x, @2x, @3x scaling for different devices
- App Store icon (1024x1024)

### macOS
**Location**: `macos/Runner/Assets.xcassets/AppIcon.appiconset/`
**Files Updated**:
- Multiple sizes from 16x16 to 1024x1024
- Proper scaling for Retina displays

## Generation Process

### Option 1: Automated Generation (Recommended)
Run the appropriate script based on your operating system:

**Windows (PowerShell)**:
```powershell
.\scripts\generate_app_icons.ps1 -SourceImage "assets/images/logo.png"
```

**macOS/Linux (Bash)**:
```bash
chmod +x scripts/generate_app_icons.sh
./scripts/generate_app_icons.sh assets/images/logo.png
```

### Option 2: Manual Generation
If automated tools aren't available, manually resize the source image to each required dimension using image editing software like:
- Photoshop
- GIMP
- Figma
- Online tools like Canva or Photopea

## Brand Guidelines
Ensure the generated icons follow these design principles:
- **Primary Color**: Use #0BBF7D (Emerald Green) prominently
- **Contrast**: Ensure good visibility on both light and dark backgrounds
- **Simplicity**: Design should be recognizable at small sizes (16x16)
- **Transparency**: Maintain proper alpha channels where needed
- **Consistency**: Match splash screen and in-app branding

## Testing Checklist

### Android
- [ ] Test on different Android versions (API 21+)
- [ ] Verify adaptive icon displays correctly
- [ ] Check legacy icon fallback works
- [ ] Test on different launcher themes

### iOS
- [ ] Test on various iPhone models
- [ ] Test on iPad devices
- [ ] Verify dark mode compatibility
- [ ] Check App Store preview

### macOS
- [ ] Test in Finder and Dock
- [ ] Verify in App Store submission
- [ ] Check different display resolutions

## Common Issues & Solutions

### Issue: Icon not updating on device
**Solution**: 
1. Uninstall the app completely
2. Clean build: `flutter clean`
3. Rebuild: `flutter build [platform]`

### Issue: Android adaptive icon showing incorrectly
**Solution**: 
- Design proper foreground/background layers
- Ensure foreground content is within safe zone (avoid edges)
- Test with different system themes

### Issue: iOS icon appears pixelated
**Solution**:
- Ensure 1024x1024 source image quality
- Use proper @2x and @3x versions
- Check that all required sizes are included

## App Store Requirements

### Google Play Store
- **Size**: 512x512 pixels (PNG)
- **Format**: PNG with transparency
- **File size**: Under 100MB

### Apple App Store
- **Size**: 1024x1024 pixels
- **Format**: PNG without alpha channel
- **Color profile**: sRGB
- **No transparency**: Background should be opaque

### macOS App Store
- **Size**: 1024x1024 pixels for Mac App Store
- **Additional**: Various sizes for Finder/Dock

## Next Steps After Icon Update

1. ✅ Run the generation script
2. ✅ Verify all platform icons are created
3. ✅ Test on simulators/emulators
4. ✅ Test on physical devices
5. ✅ Update app store listings with new 1024x1024 icons
6. ✅ Increment build number in pubspec.yaml
7. ✅ Create new app builds for distribution

## Maintenance
- Keep source `logo.png` in `assets/images/` updated
- Regenerate all icons when logo design changes
- Document any custom design requirements for adaptive icons
- Maintain consistent branding across all touchpoints

## References
- [Android Adaptive Icons Guide](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS Human Interface Guidelines - Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [macOS Human Interface Guidelines - Icons](https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon)