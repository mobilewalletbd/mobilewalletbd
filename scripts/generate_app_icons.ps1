# App Icon Generation Script for Windows (PowerShell)
# This script generates app icons for all platforms from a source image
# Usage: .\generate_app_icons.ps1 -SourceImage "assets/images/logo.png"

param(
    [Parameter(Mandatory=$true)]
    [string]$SourceImage
)

# Check if source image exists
if (-not (Test-Path $SourceImage)) {
    Write-Error "Source image '$SourceImage' not found"
    exit 1
}

Write-Host "Generating app icons from: $SourceImage" -ForegroundColor Green

# Function to resize image using .NET System.Drawing
function Resize-Image {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [int]$Size
    )
    
    try {
        # Load System.Drawing (requires .NET Framework)
        Add-Type -AssemblyName System.Drawing
        
        $original = [System.Drawing.Image]::FromFile($InputPath)
        $resized = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($resized)
        
        # Set high quality rendering
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Draw resized image
        $graphics.DrawImage($original, 0, 0, $Size, $Size)
        
        # Save
        $resized.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $resized.Dispose()
        $original.Dispose()
        
        Write-Host "✓ Generated: $OutputPath ($Size x $Size)" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to generate $OutputPath : $($_.Exception.Message)"
        # Create empty placeholder file
        $null = New-Item -Path $OutputPath -ItemType File -Force
    }
}

# Generate Android icons
Write-Host "`nGenerating Android icons..." -ForegroundColor Yellow

$androidResDir = "android/app/src/main/res"

# Legacy icons
Resize-Image -InputPath $SourceImage -OutputPath "$androidResDir/mipmap-mdpi/ic_launcher.png" -Size 48
Resize-Image -InputPath $SourceImage -OutputPath "$androidResDir/mipmap-hdpi/ic_launcher.png" -Size 72
Resize-Image -InputPath $SourceImage -OutputPath "$androidResDir/mipmap-xhdpi/ic_launcher.png" -Size 96
Resize-Image -InputPath $SourceImage -OutputPath "$androidResDir/mipmap-xxhdpi/ic_launcher.png" -Size 144
Resize-Image -InputPath $SourceImage -OutputPath "$androidResDir/mipmap-xxxhdpi/ic_launcher.png" -Size 192

# Copy for adaptive icon foreground (should be properly designed)
Copy-Item -Path $SourceImage -Destination "$androidResDir/drawable/ic_launcher_foreground.png" -Force

# Generate iOS icons
Write-Host "`nGenerating iOS icons..." -ForegroundColor Yellow

$iosIconset = "ios/Runner/Assets.xcassets/AppIcon.appiconset"

Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-20x20@1x.png" -Size 20
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-20x20@2x.png" -Size 40
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-20x20@3x.png" -Size 60
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-29x29@1x.png" -Size 29
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-29x29@2x.png" -Size 58
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-29x29@3x.png" -Size 87
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-40x40@1x.png" -Size 40
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-40x40@2x.png" -Size 80
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-40x40@3x.png" -Size 120
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-60x60@2x.png" -Size 120
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-60x60@3x.png" -Size 180
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-76x76@1x.png" -Size 76
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-76x76@2x.png" -Size 152
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-83.5x83.5@2x.png" -Size 167
Resize-Image -InputPath $SourceImage -OutputPath "$iosIconset/Icon-App-1024x1024@1x.png" -Size 1024

# Generate macOS icons
Write-Host "`nGenerating macOS icons..." -ForegroundColor Yellow

$macosIconset = "macos/Runner/Assets.xcassets/AppIcon.appiconset"

Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_16.png" -Size 16
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_32.png" -Size 32
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_64.png" -Size 64
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_128.png" -Size 128
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_256.png" -Size 256
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_512.png" -Size 512
Resize-Image -InputPath $SourceImage -OutputPath "$macosIconset/app_icon_1024.png" -Size 1024

Write-Host "`n✅ App icon generation completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Verify all generated icons look correct" -ForegroundColor White
Write-Host "2. For Android adaptive icons, manually design proper foreground/background" -ForegroundColor White
Write-Host "3. For iOS, check that icons display well on both light and dark backgrounds" -ForegroundColor White
Write-Host "4. Test icons on actual devices/simulators" -ForegroundColor White
Write-Host "5. Update app store listings with 1024x1024 versions" -ForegroundColor White