platform :ios, '12.0'
use_frameworks!

target 'Marvel' do
  pod 'RxCocoaNetworking'
  pod 'SwiftHash'
  pod 'SwiftLint'

  target 'MarvelTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'RxNimble/RxTest', :git => 'https://github.com/gobetti/RxNimble.git', :branch => 'rxtest-support'
  end
end
