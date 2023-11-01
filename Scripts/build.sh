#!/bin/sh

# Create framework
echo "===========BUILD XCFRAMEWORK==========="

xcodebuild -create-xcframework \
-framework ../Sources/Frameworks/PrimerKlarnaSDK-iOS.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-framework ../Sources/Frameworks/PrimerKlarnaSDK-Simulator.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-output ../Sources/Frameworks/PrimerKlarnaSDK.xcframework

