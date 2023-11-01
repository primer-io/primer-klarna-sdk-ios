#!/bin/sh

# Archive framework for device
echo "===========ARCHIVATION FOR IOS DEVICES==========="

cd ../Framework

xcodebuild archive \
-scheme PrimerKlarnaSDK \
-destination "generic/platform=iOS" \
-archivePath ../Sources/PrimerKlarnaXCFramework/PrimerKlarnaSDK-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Archive framework for simulators
echo "===========ARCHIVATION FOR IOS SIMULATORS==========="

xcodebuild archive \
-scheme PrimerKlarnaSDK \
-destination "generic/platform=iOS Simulator" \
-archivePath ../Sources/PrimerKlarnaXCFramework/PrimerKlarnaSDK-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
