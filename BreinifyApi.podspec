#
# Be sure to run `pod lib lint BreinifyApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BreinifyApi'
  s.version          = '0.2.1'
  s.summary          = 'Breinify´s DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Breinifys DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips. We believe that in many situations, a critical component of a great user experience is personalization. With all the data available on the web it should be easy to provide a unique experience to every visitor, and yet, sometimes you may find yourself wondering why it is so difficult.'

  s.homepage         = 'https://github.com/Breinify'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marco' => 'marco.recchioni@breinify.com' }
  s.source           = { :git => 'https://github.com/Breinify/brein-api-library-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BreinifyApi/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BreinApi' => ['BreinifyApi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Alamofire', '~> 3.4'
  s.dependency 'IDZSwiftCommonCrypto', '0.7.3'
end
