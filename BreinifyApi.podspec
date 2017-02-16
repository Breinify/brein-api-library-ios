Pod::Spec.new do |s|
  s.name             = 'BreinifyApi'
  s.version          = '0.4.1'
  s.summary          = 'Breinify´s DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips'
  s.description      = 'Breinifys DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips. We believe that in many situations, a critical component of a great user experience is personalization. With all the data available on the web it should be easy to provide a unique experience to every visitor, and yet, sometimes you may find yourself wondering why it is so difficult.'
  s.homepage         = 'https://github.com/Breinify'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marco' => 'marco.recchioni@breinify.com' }
  s.source           = { :git => 'https://github.com/Breinify/brein-api-library-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'
  s.source_files = 'BreinifyApi/Classes/**/*'
  s.dependency 'Alamofire', '3.5.1'
  s.dependency 'IDZSwiftCommonCrypto', '0.8.3'
end
