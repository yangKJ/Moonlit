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
  s.author       = { "77" => "ykj310@126.com" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/yangKJ/KJPlayerDemo.git", :tag => "#{s.version}" }
  s.platform     = :ios
  s.requires_arc = true
  s.static_framework = true
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  
  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'MediaPlayer'
  
  s.subspec 'Extension' do |xx|
    xx.source_files = "Sources/Extension/*.swift"
  end
  
  s.subspec 'Database' do |xx|
    xx.source_files = "Sources/Database/*.swift"
    xx.resources = "Sources/Database/*.{xcdatamodeld}"
  end
  
  ## 视频下载模块，支持记忆上次未下载完成的类型
  s.subspec 'Downloader' do |xx|
    xx.source_files = "Sources/Downloader/*.{h,m}"
    xx.prefix_header_contents = '#import "KJPlayer-Bridging-Header.h"'
    xx.dependency 'KJPlayer/Core'
  end
  
  s.subspec 'Core' do |xx|
    xx.source_files = "Sources/Core/*.swift"
    xx.dependency 'KJPlayer/Extension'
  end
  
  s.subspec 'AVPlayer' do |av|
    av.subspec 'AVCore' do |xx|
      xx.source_files = "Sources/AVPlayer/*.swift"
      xx.dependency 'KJPlayer/Core'
    end
    av.subspec 'AVDownloader' do |xx|
      xx.source_files = "Sources/AVPlayer/AVDownloader/**/*.swift"
      xx.frameworks = 'MobileCoreServices'
      xx.dependency 'KJPlayer/AVPlayer/AVCore'
      xx.dependency 'KJPlayer/Database'
      xx.dependency 'KJPlayer/Downloader'
    end
  end
  
  s.subspec 'MIDI' do |xx|
    xx.source_files = "Sources/MidiPlayer/*.swift"
    xx.resources = "Sources/MidiPlayer/*.{bundle}"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 自定义播放器控件模块
  s.subspec 'CustomView' do |xx|
    xx.source_files = "Sources/View/*.swift"
    xx.resource_bundles = { 'KJPlayer' => ['Sources/View/*.{ttf}'] }
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 缓存至数据库模块
  s.subspec 'Cache' do |xx|
    xx.source_files = "Sources/Cache/*.swift"
    xx.dependency 'KJPlayer/Core'
    xx.dependency 'KJPlayer/Database'
  end
  
  ## 自动记忆播放时间模块
  s.subspec 'RecordTime' do |xx|
    xx.source_files = "Sources/RecordTime/*.swift"
    xx.dependency 'KJPlayer/Core'
    xx.dependency 'KJPlayer/Database'
  end
  
  ## 主动跳过片头和片尾模块
  s.subspec 'SkipTime' do |xx|
    xx.source_files = "Sources/SkipTime/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 免费时间时间模块
  s.subspec 'FreeTime' do |xx|
    xx.source_files = "Sources/FreeTime/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
  ## 视频截图模块
  s.subspec 'Screenshots' do |xx|
    xx.source_files = "Sources/Screenshots/*.swift"
    xx.dependency 'KJPlayer/Core'
    xx.dependency 'KJPlayer/Database'
  end
  
  ## AVPlayer画中画模块
  s.subspec 'Pip' do |xx|
    xx.source_files = "Sources/Pip/*.swift"
    xx.dependency 'KJPlayer/Core'
  end
  
end
