#
# Be sure to run `pod lib lint JQTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JQTools'
  s.version          = '0.1.1'
  s.summary          = 'JQKit 自己常用的工具集合，加快开发进度'
  s.swift_versions   = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/youngerTimes/JQTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '841720330@qq.com' => '841720330@qq.com' }
  s.source           = { :git => 'https://github.com/youngerTimes/JQTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  #s.libraries  'z.1', 'sqlite3' 引用系统库
#  s.static_framework = true

  s.ios.deployment_target = '10.0'

  s.source_files = 'JQTools/Classes/**/*'
  
   s.resource_bundles = {
     'JQToolsRes' => ['JQTools/Assets/*']
   }

#   s.public_header_files = 'JQTools/Classes/OC/Header.h'
   
   s.frameworks = 'UIKit'
   s.dependency 'SnapKit'
   s.dependency 'ObjectMapper'
   s.dependency 'QMUIKit'
   s.dependency 'IQKeyboardManagerSwift', '~> 6.5.5'
   s.dependency 'RxSwift'
   s.dependency 'RxCocoa'
   s.dependency 'SwiftyUserDefaults', '4.0.0-alpha.1'
   s.dependency 'WMPageController', '~> 2.5.2' #选项卡
   s.dependency 'Then'
   s.dependency 'MJRefresh'
end
