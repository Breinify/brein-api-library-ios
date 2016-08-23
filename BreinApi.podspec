#
# Be sure to run `pod lib lint BreinApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BreinApi'
  s.version          = '0.1.0'
  s.summary          = 'This is a short description of BreinApi.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This is the description of Breinify iOS API'

  s.homepage         = 'https://github.com/Breinify'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marco' => 'marco.recchioni@breinify.com' }
  s.source           = { :git => 'https://github.com/Breinify/BreinApi.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BreinApi/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BreinApi' => ['BreinApi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Alamofire', '~> 3.4'
  s.dependency 'IDZSwiftCommonCrypto', '0.7.3'
end
