platform :ios, '9.0'
use_frameworks!

target 'BreinifyApi' do

  pod 'NetUtils', '~> 4.2'

  target 'BreinifyApiTests' do
    inherit! :search_paths
    pod 'NetUtils', '~> 4.2'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end