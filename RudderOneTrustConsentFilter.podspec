require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name             = 'RudderOneTrustConsentFilter'
  s.module_name      = 'RudderOneTrustConsentFilter'
  s.version          = package['onetrust_version']
  s.summary          = "Privacy and Security focused Segment-alternative. iOS, tvOS, watchOS & macOS SDK"
  s.description      = <<-DESC
  Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC

  s.homepage         = "https://github.com/rudderlabs/rudder-interceptors-ios"
  s.license          = { :type => "Apache", :file => "LICENSE" }
  s.author           = { "RudderStack" => "arnab@rudderlabs.com" }
  s.source           = { :git => "https://github.com/rudderlabs/rudder-interceptors-ios.git", :tag => "v#{s.version}" }

  s.swift_version = '5.3'
  
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  
  
  s.source_files = 'RudderOneTrust/Sources/Common/**/*.swift'
  s.ios.source_files = 'RudderOneTrust/Sources/iOS/**/*.swift'
  s.tvos.source_files = 'RudderOneTrust/Sources/tvOS/**/*.swift'

  s.ios.dependency 'OneTrust-CMP-XCFramework', '202301.1.0'
  s.tvos.dependency 'OneTrust-CMP-tvOS-XCFramework', '202301.1.0'
  
  s.dependency 'Rudder', '~> 1.10'
end
