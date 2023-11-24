#!/bin/sh

cd ../

# Remove archives
rm -r PrimerKlarnaSDK-iOS.xcarchive
rm -r PrimerKlarnaSDK-Simulator.xcarchive

# Remove zip archive
rm -r XCFrameworks.zip

# Zip xcframeworks
zip -r XCFrameworks.zip PrimerKlarnaSDK.xcframework KlarnaMobileSDK.xcframework
