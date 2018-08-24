Pod::Spec.new do |s|
  s.name         = "TTSCollectionViewManager"
  s.version      = "0.2.7"
  s.summary      = "iOS中CollectionView框架"
  s.homepage     = "https://git.tticar.com/pods/TTSCollectionViewManager"
  s.license      = "Copyright (C) 2017 Gary, Inc.  All rights reserved."
  s.author             = { "Gary" => "zguanyu@163.com" }
  s.social_media_url   = "http://www.cupinn.com"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://git.tticar.com/pods/TTSCollectionViewManager.git", :tag => '0.2.7' }
  s.source_files  = "TTSCollectionViewManager/TTSCollectionViewManager/**/*.{h,m,c}"
  s.frameworks = 'UIKit','CoreGraphics'
  s.requires_arc = true
  s.dependency 'BBNetwork'
  s.dependency 'Texture'
  s.dependency 'pop'
end
