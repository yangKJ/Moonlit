#
# Be sure to run 'pod lib lint KJPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'KJPlayer'
  s.version      = "2.2.0"
  s.summary      = "KJPlayer play and cache, AVPlayer / MIDIPlayer / IJKPlayer"
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage     = "https://github.com/yangKJ/KJPlayerDemo"
  s.license      = "Copyright (c) 2019 yangkejun"
  s.author       = { "77" => "yangkj310@gmail.com" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/yangKJ/KJPlayerDemo.git", :tag => "#{s.version}" }
  s.platform     = :ios
  s.requires_arc = true
  s.static_framework = true
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  
  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'MediaPlayer'
  
  ## 视频基础模块
  s.subspec 'Core' do |xx|
    xx.source_files = "Sources/Core/**/*.{swift,h,m}"
    xx.prefix_header_contents = '#import "KJPlayer-Bridging-Header.h"'
    xx.resources = "Sources/Core/Database/*.{xcdatamodeld}"
    xx.resource_bundles = { 'KJPlayer' => ['Sources/Core/View/*.{ttf}'] }
  end
  
  ## AVPlayer内核模块
  s.subspec 'AVPlayer' do |xx|
    xx.source_files = "Sources/Kernel/AVPlayer/*.swift"
    xx.frameworks = 'MobileCoreServices'
    xx.dependency 'KJPlayer/Core'
  end
  
  ## ---------------------- 功能模块 ----------------------
  
  ## 缓存至数据库模块
  s.subspec 'Cache' do |xx|
    xx.source_files = "Sources/Protocols/Cache/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 自动记忆播放时间模块
  s.subspec 'RecordTime' do |xx|
    xx.source_files = "Sources/Protocols/RecordTime/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 主动跳过片头和片尾模块
  s.subspec 'SkipTime' do |xx|
    xx.source_files = "Sources/Protocols/SkipTime/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 免费时间时间模块
  s.subspec 'FreeTime' do |xx|
    xx.source_files = "Sources/Protocols/FreeTime/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## AVPlayer画中画模块
  s.subspec 'Pip' do |xx|
    xx.source_files = "Sources/Protocols/Pip/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
end
