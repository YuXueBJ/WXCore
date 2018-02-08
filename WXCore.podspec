#
# Be sure to run `pod lib lint WXCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WXCore'
  s.version          = '1.1.0'
  s.summary          = 'A short description of WXCore.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
项目基础库 1:对表格的封装
         2:对数据库的格式化封装

                       DESC

  s.homepage         = 'https://github.com/YuXueBJ/WXCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '朱洪伟' => 'zhuhw@xiaoshouyi.com' }
  s.source           = { :git => 'https://github.com/YuXueBJ/WXCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WXCore/Classes/**/*.{h,m}'
  s.resources = 'WXCore/Assets/WXTableViewLoadMoreCell.xib'

  s.resource_bundles = {
    'WXCore' => ['WXCore/Assets/*']
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'MJRefresh'
    s.dependency "MBProgressHUD"
    s.dependency 'SDWebImage', '~> 4.0'
end
