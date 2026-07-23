# PrimerKlarnaSDK — guidance for AI agents

## What this is

A thin Swift wrapper around Klarna's `KlarnaMobileSDK`, distributed as an XCFramework via CocoaPods and Swift Package Manager. It is consumed as a payment-method module by the main Primer iOS SDK (`primer-sdk-ios`). The public surface is small: a turnkey `PrimerKlarnaViewController` and a headless `PrimerKlarnaProvider` / `PrimerKlarnaProviding` protocol, plus `PrimerKlarnaError`. iOS 14.0+.

## Repo structure

```
Framework/
  PrimerKlarnaSDK.xcodeproj/          # Xcode project — this is what you open
  PrimerKlarnaSDK/
    Sources/                          # ← all hand-written Swift lives here
      Error/                          #   PrimerKlarnaError.swift
      Extensions/                     #   Array+ / Date+ helpers
      Provider/                       #   PrimerKlarnaProvider — headless integration
      ViewController/                 #   PrimerKlarnaViewController — turnkey UI
      Version/version.swift           #   version constant (bumped by Commitizen)
    Framework/*.xcframework/          # Klarna binaries linked by the Xcode target — DO NOT EDIT
    PrimerKlarnaSDK.h                 # Obj-C umbrella header
  PrimerKlarnaSDKTests/               # XCTest target (stubs only today)

Scripts/                              # bash scripts that build the release XCFramework
  make.sh                             #   entry point; runs prepare → archive → build → finalize

Package.swift                         # SPM manifest — binaryTargets only
PrimerKlarnaSDK.podspec               # CocoaPods spec
.cz.toml                              # Commitizen (release version + changelog)
Dangerfile.swift                      # Danger PR title check (Conventional Commits)

# Committed build outputs — DO NOT hand-edit
PrimerKlarnaSDK.xcframework/          # our built framework (output of Scripts/make.sh)
KlarnaMobileSDK.xcframework/          # ↓ vendored from Klarna, replaced wholesale on upgrade
KlarnaCore.xcframework/
KlarnaCoreWebView.xcframework/
KlarnaNetworkCore.xcframework/
KlarnaNetworkIdentity.xcframework/
KlarnaNetworkMessaging.xcframework/
KlarnaNetworkPayment.xcframework/
KlarnaPayments.xcframework/
XCFrameworks.zip                      # required for the CocoaPod
```

## Setup & run

Prerequisites: Xcode with iOS 14 SDK, Ruby (for CocoaPods gem).

```sh
bundle install                                          # installs the cocoapods gem
open Framework/PrimerKlarnaSDK.xcodeproj                # edit / build in Xcode
```

To rebuild the shippable XCFramework after touching `Sources/`:

```sh
cd Scripts && sh make.sh                                # regenerates PrimerKlarnaSDK.xcframework + XCFrameworks.zip
```

This SDK has no runtime app of its own — it is exercised in-app by consumers (chiefly `primer-sdk-ios`). No env vars, no local URLs.

## Tests

`Framework/PrimerKlarnaSDKTests/PrimerKlarnaSDKTests.swift` contains XCTest stubs only — the target must compile and run green, but there are no meaningful assertions today. If you add behaviour to `Sources/`, add tests here.

Run all tests:

```sh
xcodebuild test -project Framework/PrimerKlarnaSDK.xcodeproj \
                -scheme PrimerKlarnaSDK \
                -destination 'platform=iOS Simulator,name=iPhone 15'
```

Run a single test: append `-only-testing:PrimerKlarnaSDKTests/PrimerKlarnaSDKTests/<methodName>`.

No Docker, no network, no external services.

## Acceptance gates (must pass before merge)

Run all of the following locally — this repo has no PR test CI. Only Danger runs on GitHub PRs; `pod lib lint` runs on tag via GitLab. If you skip these, breakage surfaces at release time.

1. **Build** — `xcodebuild build -project Framework/PrimerKlarnaSDK.xcodeproj -scheme PrimerKlarnaSDK -destination 'generic/platform=iOS'`
2. **Tests** — the `xcodebuild test` command above.
3. **Pod lint** — `bundle exec pod lib lint --allow-warnings` (mirrors what GitLab CI runs on tag; catches podspec / vendored-framework packaging breakage).
4. **Rebuild the XCFramework if `Sources/` changed** — `cd Scripts && sh make.sh`, then commit the updated `PrimerKlarnaSDK.xcframework/` and `XCFrameworks.zip` so the shipped binary matches source.
5. **Conventional Commit PR title** — enforced by `Dangerfile.swift`. Allowed prefixes: `feat`, `fix`, `chore`, `ci`, `refactor`, `docs`, `perf`, `test`, `build`, `revert`, `style`, `BREAKING CHANGE`.

## Conventions & guardrails

- **Do not hand-edit `*.xcframework/` directories or `XCFrameworks.zip`.** The Klarna ones (`KlarnaMobileSDK`, `KlarnaCore`, `KlarnaCoreWebView`, `KlarnaNetwork*`, `KlarnaPayments`) are vendored — to upgrade, replace the whole directory with the new Klarna release. `PrimerKlarnaSDK.xcframework/` and `XCFrameworks.zip` are outputs of `Scripts/make.sh` — edit `Sources/`, then rerun the script.
- **The Klarna xcframeworks appear twice** — at the repo root (shipped via pod / SPM) and under `Framework/PrimerKlarnaSDK/Framework/` (linked by the Xcode project). When upgrading Klarna, update **both** copies.
- **Version bumps are Commitizen-driven.** Do not hand-edit `Framework/PrimerKlarnaSDK/Sources/Version/version.swift`, `PrimerKlarnaSDK.podspec`'s `spec.version`, or `.cz.toml` directly — the `Create Release` GitHub workflow runs `cz bump` and opens the release PR. Merging the PR tags the release and triggers the GitLab job that pushes to CocoaPods trunk.
- **`Scripts/*.sh` is legacy.** The team is migrating wrapper SDKs to a Fastlane build (as done in `primer-stripe-sdk-ios`). Until that lands here, `make.sh` is still the correct way to rebuild — don't invest in extending the bash scripts.
- **`.travis.yml` is stale** — references Xcode 7.3 and a non-existent `Example/` workspace. Ignore it; real CI lives in `.github/workflows/` and `.gitlab-ci.yml`.
- **CODEOWNERS gates.** Changes to `version.swift`, `PrimerKlarnaSDK.podspec`, and `.github/workflows/**` require `@primer-io/checkout-pci-reviewers` review; everything else goes to `@primer-io/acceptance-mobile-ios`.
- **The public API is a small, stable surface.** Additions to `PrimerKlarnaViewController`, `PrimerKlarnaProvider`, `PrimerKlarnaProviding`, or `PrimerKlarnaError` are visible to every merchant integrating via `primer-sdk-ios` — treat renames and removals as breaking changes.

## Where to find more

- [`README.md`](./README.md) — full public API walkthrough (delegates, payment categories, integration options) and installation instructions.
- [`CHANGELOG.md`](./CHANGELOG.md) — auto-generated by Commitizen from Conventional Commits.
- Klarna Mobile SDK reference — https://docs.klarna.com/mobile-sdk/ios/get-started/
- Owning team: `@primer-io/acceptance-mobile-ios` (see [`.github/CODEOWNERS`](./.github/CODEOWNERS)). Slack: `#eng-ios-chapter`.
- Primer CLAUDE.md standard: [ADR 046 — Standardized CLAUDE.md format](https://primer-io.gitlab.io/general/engineering-standards/standards/046-claudemd_format/).
