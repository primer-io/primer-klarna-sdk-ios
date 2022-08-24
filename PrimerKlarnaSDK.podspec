Pod::Spec.new do |s|
  s.name             = 'PrimerKlarnaSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PrimerKlarnaSDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/EvansPie/PrimerKlarnaSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EvansPie' => 'evangelos@primer.io' }
  s.source           = { :git => 'https://github.com/EvansPie/PrimerKlarnaSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.cocoapods_version = '>= 1.10.0'
  s.swift_version     = '5.3'

  s.ios.deployment_target = '10.0'

  s.source_files = 'PrimerKlarnaSDK/Classes/**/*'

  s.dependency 'PrimerSDK', '~> 2.5.0'
  s.dependency 'KlarnaMobileSDK', '2.2.2'
end
