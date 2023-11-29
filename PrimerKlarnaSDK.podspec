Pod::Spec.new do |spec|
  spec.name         = "PrimerKlarnaSDK"
  spec.version      = "1.1.0-b0"
  spec.swift_version = '5.0'
  spec.summary      = "A wrapper of the KlarnaMobileSDK."
  spec.description  = "PrimerKlarnaSDK is a wrapper of the KlarnaMobileSDK that exposes its functionality source it can be used within the PrimerSDK as a separate module."
  spec.homepage     = "https://github.com/primer-io/primer-klarna-sdk-ios"

  spec.license      = { :type => 'MIT', :file => __dir__ + '/LICENSE' }

  spec.author       = { 'Primer DX Team' => 'dx@primer.io' }

  spec.platform     = :ios, "14.0"

  spec.ios.deployment_target = "14.0"
  spec.source       = { :git => 'https://github.com/primer-io/primer-klarna-sdk-ios.git', :tag => spec.version.to_s }

  spec.vendored_frameworks = 'PrimerKlarnaSDK.xcframework', 'KlarnaMobileSDK.xcframework'
end