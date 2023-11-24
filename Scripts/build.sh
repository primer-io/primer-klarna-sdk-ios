#!/bin/sh

# Create framework
echo "===========BUILD XCFRAMEWORK==========="

xcodebuild -create-xcframework \
-framework ../PrimerKlarnaSDK-iOS.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-framework ../PrimerKlarnaSDK-Simulator.xcarchive/Products/Library/Frameworks/PrimerKlarnaSDK.framework \
-output ../PrimerKlarnaSDK.xcframework

