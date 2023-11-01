#!/bin/sh

# Create framework
echo "===========BUILD XCFRAMEWORK==========="

xcodebuild -create-xcframework \
-framework ../Sources/PrimerKlarnaXCFramework/PrimerKlarnaSDK-iOS.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-framework ../Sources/PrimerKlarnaXCFramework/PrimerKlarnaSDK-Simulator.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-output ../Sources/PrimerKlarnaXCFramework/PrimerKlarnaSDK.xcframework

