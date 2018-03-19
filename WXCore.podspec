
Pod::Spec.new do |s|
  s.name             = 'WXCore'
  s.version          = '1.0.0'
  s.summary          = '表格的封装库 WXCore.'
  s.description      = <<-DESC
                    *   项目基础库 1:对表格的封装
                                 2:对数据库的格式化封装
                       DESC
  s.homepage         = 'https://github.com/YuXueBJ/WXCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '朱洪伟' => 'zhwios@126.com' }
  s.source           = { :git => 'https://github.com/YuXueBJ/WXCore.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'WXCore/Classes/**/*.{h,m}'
  s.resources = 'WXCore/Assets/*.{png,xib}'
  #s.resource_bundles = {
  # 'WXCore' => ['WXCore/Assets/*']
  #}
  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'MJRefresh'
    s.dependency 'MBProgressHUD'
    s.dependency 'SDWebImage'
    s.dependency 'Masonry'
end
