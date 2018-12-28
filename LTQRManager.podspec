#
# Be sure to run `pod lib lint LTQRManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LTQRManager'
  s.version          = '0.1.0'
  s.summary          = 'LTQRManager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LTQRManager.
                       DESC

  s.homepage         = 'https://github.com/254956982@qq.com/LTQRManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '254956982@qq.com' => 'yl21ly@qq.com' }
  s.source           = { :git => 'https://github.com/yelon21/LTQRManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/yelon21'

  s.ios.deployment_target = '7.0'

  s.source_files = 'LTQRManager/Classes/**/*'
  s.resource     = "LTQRManager/Assets/*.png"
  # s.resource_bundles = {
  #   'LTQRManager' => ['LTQRManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
s.dependency 'ZXingObjC'
end
