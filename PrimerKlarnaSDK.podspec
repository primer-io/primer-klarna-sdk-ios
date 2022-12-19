Pod::Spec.new do |s|
  s.name             = 'PrimerKlarnaSDK'
  s.version          = '1.0.3'
  s.summary          = 'A wrapper of the KlarnaMobileSDK.'
  
  s.description      = <<-DESC
  PrimerKlarnaSDK is a wrapper of the KlarnaMobileSDK that exposes its functionality source
  it can be used within the PrimerSDK as a separate module. If you want to use Klarna for
  accepting payments from Primer you have to add `pod 'PrimerKlarnaSDK'` in your podfile.
  DESC
  
  s.homepage         = 'https://github.com/primer-io/primer-klarna-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Primer DX Team' => 'dx@primer.io' }
  s.source           = { :git => 'https://github.com/primer-io/primer-klarna-sdk-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://primer.io'
  
  s.cocoapods_version = '>= 1.10.0'
  s.swift_version     = '5.3'
  
  s.ios.deployment_target = '10.0'
  
  s.source_files = 'PrimerKlarnaSDK/Classes/**/*'
  s.dependency 'KlarnaMobileSDK', '2.2.2'
end
