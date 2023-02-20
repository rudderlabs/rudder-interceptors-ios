source 'https://github.com/CocoaPods/Specs.git'
workspace 'RudderOneTrust.xcworkspace'
use_frameworks!
inhibit_all_warnings!

def shared_pods
    pod 'Rudder'
end

target 'RudderOneTrustiOS' do
    platform :ios, '11.0'
    shared_pods
    pod 'OneTrust-CMP-XCFramework', '202301.1.0'
    target 'RudderOneTrustiOSTests' do
        inherit! :complete
    end
end

target 'RudderOneTrusttvOS' do
    platform :tvos, '11.0'
    pod 'OneTrust-CMP-tvOS-XCFramework', '202301.1.0'
    shared_pods
    target 'RudderOneTrusttvOSTests' do
        inherit! :complete
    end
end

target 'SampleSwiftiOS' do
    platform :ios, '11.0'
    pod 'RudderOneTrustConsentFilter', :path => '.'
    pod 'Rudder-Adjust'
    pod 'Rudder-Appsflyer', :git => 'https://github.com/rudderlabs/rudder-integration-appsflyer-ios.git', :commit => '7590be8a0ed5110659faaf4514111bd7cdce909e'
    pod 'Rudder-Facebook'
    pod 'Rudder-Firebase'
    pod 'Rudder-Braze'
end

target 'SampleSwifttvOS' do
    platform :tvos, '11.0'
    pod 'RudderOneTrustConsentFilter', :path => '.'
end

target 'SampleObjCiOS' do
    platform :ios, '11.0'
    pod 'RudderOneTrustConsentFilter', :path => '.'
end

target 'SampleObjCtvOS' do
    platform :tvos, '11.0'
    pod 'RudderOneTrustConsentFilter', :path => '.'
end
