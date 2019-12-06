# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'KonoWorker' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for KonoWorker
    pod 'Realm'
    pod 'Google/SignIn'
    pod 'SCLAlertView-Objective-C'
    pod 'IGListKit', '~> 3.0'
    pod 'PINRemoteImage'
    pod 'AFNetworking', '~> 3.0'
    pod 'Masonry'
    pod 'MBProgressHUD', '~> 1.1.0'
  target 'KonoWorkerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'KonoWorkerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'FSPagerView'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
