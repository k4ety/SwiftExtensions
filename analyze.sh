xcodebuild clean build -workspace NXTSwiftExtensions.xcworkspace/ -scheme SwiftExtensions > xcodebuild.log
swiftlint analyze --compiler-log-path xcodebuild.log

