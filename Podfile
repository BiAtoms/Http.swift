platform :ios, '8.0' # links Foundation.framework for targets

target 'HttpSwift' do
  use_frameworks!

  # Pods for HttpSwift
    pod 'Socket.swift'
    
  target 'HttpSwiftTests' do
    inherit! :search_paths
    pod 'Request.swift'
  end
end

# Below code is just used to make project multi-platform. You won't need it
post_install do |installer|  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @loader_path/Frameworks @executable_path/../Frameworks @loader_path/../Frameworks'
      config.build_settings['SUPPORTED_PLATFORMS'] = 'macosx appletvsimulator appletvos iphonesimulator iphoneos'
      config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,4'
      config.build_settings['SDKROOT'] = ''

      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
      config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '9.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.9'
    end
  end

  installer.pod_targets.each do |group|
    system "sed -i -e 's/UIKit/Foundation/g' '#{group.umbrella_header_path}' '#{group.prefix_header_path}'"
  end
end
