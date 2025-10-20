# 🚀 Eghtanem App - Production Deployment Guide

## Overview
This guide provides step-by-step instructions for preparing and deploying the Eghtanem Flutter app to production on both Android and iOS platforms.

## 📋 Prerequisites

### For Android:
- Java JDK 11 or higher
- Android SDK with API level 21+ (Android 5.0+)
- Android Studio or command-line tools
- Google Play Console account (for Play Store deployment)

### For iOS:
- macOS with Xcode 14+
- Apple Developer Program membership
- iOS device for testing (optional but recommended)

### General:
- Flutter SDK (latest stable version)
- Git for version control

## 🔧 Production Configuration

### 1. Android Configuration

#### App Signing Setup
The Android app is configured with production signing:

```bash
# Generate keystore (run from project root)
./scripts/generate_keystore.bat  # Windows
# or
./scripts/generate_keystore.sh   # macOS/Linux
```

Update `android/key.properties` with your signing information:
```properties
storePassword=your_secure_password
keyPassword=your_secure_key_password
keyAlias=upload
storeFile=keystore.jks
```

#### Build Optimization Features:
- ✅ ProGuard/R8 obfuscation enabled
- ✅ Resource shrinking enabled
- ✅ Multi-dex support
- ✅ Optimized APK size
- ✅ Debug symbols for crash reporting

### 2. iOS Configuration

#### Bundle Configuration
Updated `ios/Runner/Info.plist` with:
- Production bundle identifier: `com.eghtanem.app`
- App display name: "Eghtanem"
- Privacy permissions for camera, microphone, photo library
- Background audio support
- App Transport Security settings

#### Code Signing
For iOS deployment, you'll need:
1. Apple Developer Program account
2. Distribution certificate
3. App Store provisioning profile

## 🏗️ Building Release Versions

### Android Release Builds

#### Option 1: Using Build Script (Recommended)
```bash
# Windows
./scripts/build_release.bat

# macOS/Linux
./scripts/build_release.sh
```

#### Option 2: Manual Build Commands
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Build APK (for direct installation)
flutter build apk --release --split-per-abi

# Build AAB (for Google Play Store)
flutter build appbundle --release
```

### iOS Release Build

#### Prerequisites:
1. Configure code signing in Xcode
2. Set up provisioning profiles
3. Ensure proper entitlements

#### Build Commands:
```bash
# Build for iOS (requires macOS)
flutter build ios --release --no-codesign

# Then open Xcode for code signing and archiving:
open ios/Runner.xcworkspace
```

## 📦 Build Outputs

### Android
- **APK files**: `build/app/outputs/flutter-apk/`
  - `app-arm64-v8a-release.apk`
  - `app-armeabi-v7a-release.apk`
  - `app-x86_64-release.apk`
- **AAB file**: `build/app/outputs/bundle/release/app-release.aab`

### iOS
- **App bundle**: `build/ios/iphoneos/Runner.app`
- **Archive**: Created in Xcode Organizer

## 🚀 Deployment

### Google Play Store (Android)

1. **Prepare Release:**
   ```bash
   # Generate AAB for Play Store
   flutter build appbundle --release
   ```

2. **Upload to Play Console:**
   - Go to Google Play Console
   - Create new release in Production/Testing track
   - Upload `app-release.aab`
   - Add release notes and screenshots
   - Set pricing and distribution
   - Submit for review

3. **Internal Testing (Recommended First):**
   - Create internal test track
   - Upload AAB and create release
   - Add testers via email
   - Distribute testing link

### Apple App Store (iOS)

1. **Prepare Archive:**
   ```bash
   # Build for iOS
   flutter build ios --release --no-codesign
   ```

2. **Code Sign and Archive in Xcode:**
   - Open `ios/Runner.xcworkspace`
   - Select "Runner" target
   - Choose "Any iOS Device" as target
   - Product → Archive
   - Validate and distribute via App Store Connect

3. **App Store Connect:**
   - Create new app version
   - Upload build
   - Add screenshots and descriptions
   - Set pricing and availability
   - Submit for review

## 🔒 Security Considerations

### Android
- Keystore file is gitignored (add to `.gitignore`)
- Store passwords securely (consider using environment variables)
- Enable ProGuard obfuscation
- Use HTTPS for all network requests

### iOS
- Use proper code signing certificates
- Enable App Transport Security
- Configure proper entitlements
- Use secure storage for sensitive data

## 📊 Performance Optimizations

### Enabled Features:
- ✅ Tree shaking (removes unused code)
- ✅ Code obfuscation (Android)
- ✅ Resource shrinking
- ✅ Split APKs by architecture
- ✅ Optimized asset compression

### Monitoring:
- Consider integrating crash reporting (Firebase Crashlytics)
- Add analytics (Firebase Analytics)
- Monitor app performance

## 🧪 Testing

### Pre-Release Checklist:
- [ ] Test on multiple devices
- [ ] Verify all features work in release mode
- [ ] Check app size and performance
- [ ] Test network requests with production API
- [ ] Verify in-app purchases (if applicable)
- [ ] Test push notifications
- [ ] Validate app icons and splash screens

### Automated Testing:
```bash
# Run tests
flutter test

# Build and analyze
flutter analyze
flutter build apk --release --analyze-size
```

## 🔄 Version Management

### Update Version:
1. Update `pubspec.yaml`:
   ```yaml
   version: 1.1.0+2  # major.minor.patch+build
   ```

2. Update Android version in `android/app/build.gradle.kts`:
   ```kotlin
   versionCode = 2
   versionName = "1.1.0"
   ```

3. Update iOS version in `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleShortVersionString</key>
   <string>1.1.0</string>
   <key>CFBundleVersion</key>
   <string>2</string>
   ```

## 🚨 Troubleshooting

### Common Issues:

#### Android Build Issues:
```bash
# Clear build cache
flutter clean
flutter pub cache repair

# Check Java version
java -version

# Verify Android SDK
flutter doctor --android-licenses
```

#### iOS Build Issues:
```bash
# Clean iOS build
flutter clean
cd ios
pod deintegrate
pod install
cd ..
```

#### Code Signing Issues:
- Verify certificates in Keychain Access (macOS)
- Check provisioning profiles in Xcode
- Ensure bundle ID matches App Store Connect

## 📞 Support

For deployment issues:
1. Check Flutter documentation: https://flutter.dev/docs
2. Android: https://developer.android.com/studio/publish
3. iOS: https://developer.apple.com/support/app-store-connect/

## 📝 Release Notes Template

```
Version X.Y.Z

🎉 New Features:
- Feature description

🐛 Bug Fixes:
- Bug fix description

🔧 Improvements:
- Performance improvement
- UI enhancement

📋 Notes:
- Any important information for users
```

---

**Remember**: Always test thoroughly before releasing to production, and consider using beta testing tracks first to catch any issues with a smaller audience.