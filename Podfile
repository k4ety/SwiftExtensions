# Specs Sources
source 'https://github.com/k4ety/Pods.git'
source 'https://github.com/CocoaPods/Specs.git'

# Project Config
platform :ios, '10.0'

# Settings
use_frameworks!
inhibit_all_warnings!

target 'SwiftExtensions' do
  pod 'SwiftLint'
  
  pod 'KeychainAccess'

  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'
end

pre_install do |installer|
  # Fix for "The target * has transitive dependencies that include static binaries"
  # https://github.com/CocoaPods/CocoaPods/issues/3289
  Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

post_install do |installer|
  # Create acknowledgements file
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-SwiftExtensions/Pods-SwiftExtensions-acknowledgements.plist', 'Acknowledgements.plist', :remove_destination => true)
  
  # Fix for IB to be able to find things in frameworks, update compiler settings to prevent warnings
  installer.pods_project.targets.each do |target|
    target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = "-Owholemodule"
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
      next unless config.name == 'Debug'
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(FRAMEWORK_SEARCH_PATHS)']
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = "-Onone"
    end
  end
end
