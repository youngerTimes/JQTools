#
# Be sure to run `pod lib lint JQTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JQTools'
  s.version          = '0.1.0'
  s.summary          = 'A short description of JQTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/841720330@qq.com/JQTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '841720330@qq.com' => '841720330@qq.com' }
  s.source           = { :git => 'https://github.com/841720330@qq.com/JQTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JQTools/Classes/**/*'
  
   s.resource_bundles = {
     'JQToolsRes' => ['JQTools/Assets/*']
   }

   s.public_header_files = 'Pod/Classes/Header.h'
   s.frameworks = 'UIKit'
   s.dependency 'SnapKit'
   s.dependency 'ObjectMapper'
   s.dependency 'QMUIKit', '~> 4.0.4'
   s.dependency 'IQKeyboardManagerSwift', '~> 6.5.5'
   s.dependency 'RxSwift','~> 5.1.1'
   s.dependency 'RxCocoa','~> 5.1.1'
   s.dependency 'SwiftyUserDefaults', '4.0.0-alpha.1'
end
