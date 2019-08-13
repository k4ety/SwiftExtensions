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
end

post_install do |installer|
  # Create acknowledgements file
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-SwiftExtensions/Pods-SwiftExtensions-acknowledgements.plist', 'Acknowledgements.plist', :remove_destination => true)
end
