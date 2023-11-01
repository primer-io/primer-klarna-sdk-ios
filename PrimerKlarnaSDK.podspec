Pod::Spec.new do |spec|
  spec.name         = "PrimerKlarnaSDK"
  spec.version      = "1.1"
  spec.swift_version = '5.0'
  spec.summary      = "A wrapper of the KlarnaMobileSDK."

  spec.summary.description      = <<-DESC
  PrimerKlarnaSDK is a wrapper of the KlarnaMobileSDK that exposes its functionality source
  it can be used within the PrimerSDK as a separate module. If you want to use Klarna for
  accepting payments from Primer you have to add `pod 'PrimerKlarnaSDK'` in your podfile.
  DESC

  spec.homepage     = "https://github.com/primer-io/primer-klarna-sdk-ios"

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }

  spec.author       = { 'Primer DX Team' => 'dx@primer.io' }

  spec.social_media_url = 'https://primer.io'

  spec.platform     = :ios, "14.0"

  spec.ios.deployment_target = "14.0"
  spec.source       = { :http => 'file:' + __dir__ + '/XCFrameworks.zip' }

  spec.vendored_frameworks = 'PrimerKlarnaSDK.xcframework', 'KlarnaMobileSDK.xcframework'
end
