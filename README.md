# Aeris — Living Weather

Aeris is a premium iOS weather app built with Swift 6, SwiftUI, WeatherKit, MapKit, and CoreLocation. No third-party dependencies.

## Architecture

MVVM, organized by feature:

- `Core/Weather/Models` — pure data types shared by the app and the widget (`WeatherCondition`, `WeatherSnapshot`, `TemperatureUnit`, etc.)
- `Core/Weather/Services` — `WeatherProvider` protocol, `WeatherKitProvider` (real data), `MockWeatherProvider` (previews/tests)
- `Core/Weather/Repository` — `WeatherRepository` (actor) coordinates fetch + cache; `WeatherCache` is a plain, queue-guarded class
- `Core/Location` — CoreLocation wrapper
- `Core/Visualization` — animated weather icon, living background scene, wind visualization
- `Persistence` — saved locations and settings (UserDefaults-backed)
- `Utilities` — unit formatting, sun position math, haptics
- `Features/*` — Today, Forecast, Map, Locations, Settings, Details screens
- `AerisWidget` — WidgetKit extension (small/medium/large), shares only the `Core/Weather/*` models/services/repository plus the icon view and unit formatter
- `AerisTests` — unit tests for the repository, condition mapping, and sun math

## Honesty about data

Air quality is **never fabricated**. `WeatherKitProvider` sets `airQuality` to `nil` unless a real data source is wired in; the UI explicitly shows "Air quality data unavailable" in that case instead of making up a number.

## Build locally

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) instead of committing a `.xcodeproj` (avoids merge conflicts and stale project state).

```bash
brew install xcodegen
xcodegen generate
open Aeris.xcodeproj
```

## CI

- `.github/workflows/ios-ci.yml` — runs on every push/PR: generates the project with XcodeGen, builds, and runs unit tests against an iPhone 16 simulator. Code signing is disabled (`CODE_SIGNING_ALLOWED=NO`) since this is a simulator-only build.
- `.github/workflows/build-ipa.yml` — manual (`workflow_dispatch`) job that archives an **unsigned** IPA for validation purposes. It cannot be installed on a real device or submitted to TestFlight as-is.

### Producing a real, installable, signed IPA

To get a real signed build (for TestFlight or device install), you need an active Apple Developer Program membership and must add these repository secrets, then extend `build-ipa.yml` to import the certificate/profile before archiving and use `xcodebuild -exportArchive` with `ExportOptions.plist` (method `app-store` for TestFlight):

- `BUILD_CERTIFICATE_BASE64`, `P12_PASSWORD`
- `BUILD_PROVISION_PROFILE_BASE64`
- `KEYCHAIN_PASSWORD`
- `APP_STORE_CONNECT_API_KEY_BASE64`, `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`

This repo does **not** fabricate signing — without those secrets, only the unsigned validation build is produced.

## Requirements

- Xcode 16+, iOS 17+ deployment target
- WeatherKit capability + entitlement (requires an Apple Developer account with WeatherKit enabled) for real data on device
- Falls back to `MockWeatherProvider` when `WeatherKit` isn't available (e.g. some CI/simulator configurations)

## Reduce Motion & Accessibility

All ambient/living animations (background gradients, icon breathing, wind pulse) respect `accessibilityReduceMotion` and stop animating when it's enabled, or when the user turns on "Always Reduce Motion" in Settings.
