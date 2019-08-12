Pod::Spec.new do |s|
  s.name                  = 'SwiftExtensions'
  s.version               = '0.1.0'
  s.summary               = 'Shared Swift extensions'
  s.description           = 'Shared Swift extensions'
  
  s.homepage              = 'https://github.com/k4ety/SwiftExtensions'
  #  s.license               = { :type => 'Commercial', :text => 'SwiftExtensions: Copyright Paul King.' }
  s.author                = { 'Paul King' => 'paul@k4ety.com' }
  s.source                = { :git => 'https://github.com/k4ety/SwiftExtensions.git', :tag => s.version.to_s }
  s.platform              = :ios, '10.0'
  
  s.dependency 'Fabric'
  s.dependency 'Crashlytics'
  s.dependency 'KeychainAccess'
  s.dependency 'Firebase/Analytics'
  s.frameworks = 'Fabric', 'Crashlytics', 'FirebaseCore', 'FirebaseAnalytics', 'FIRAnalyticsConnector', 'FirebaseCoreDiagnostics', 'FirebaseInstanceID', 'GoogleAppMeasurement', 'GoogleUtilities', 'KeychainAccess', 'nanopb'
  
  s.source_files            = 'SwiftExtensions/**/*.{d,h,m,swift}', 'Views/**/*.{d,h,m,swift}', 'Pods/**/*.{d,h,m,swift}', 'Info.plist'
  s.resources               = 'Acknowledgements.plist'
  s.resource_bundle         = {'SwiftExtensions-Localization' => ['Views/*.lproj/*.{storyboard,xib,strings}', 'SwiftExtensions/**/*.xcassets']}
  s.ios.vendored_frameworks = 'Fabric.framework', 'Crashlytics.framework', 'KeychainAccess.framework', 'FirebaseCore.framework', 'FirebaseAnalytics.framework', 'FIRAnalyticsConnector.framework', 'FirebaseCoreDiagnostics.framework', 'FirebaseInstanceID.framework', 'GoogleAppMeasurement.framework', 'GoogleUtilities.framework', 'nanopb.framework'
  
  s.xcconfig   = {
    'SWIFT_VERSION' => '5.0'
  }
  
  s.pod_target_xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Fabric/iOS $(PODS_ROOT)/Crashlytics/iOS $(PODS_ROOT)/FirebaseAnalytics/Frameworks',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/**',
    'INFOPLIST_FILE' => '${PODS_TARGET_SRCROOT}/Info.plist',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC'
  }
end
