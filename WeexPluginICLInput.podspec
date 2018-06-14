#
#  Be sure to run `pod spec lint QBMDatePickerPlugin.podspec' to ensure this is a

Pod::Spec.new do |s|



  s.name         = "WeexPluginICLInput"
  s.version      = "0.1.4"
  s.summary      = "weex-plugin-ios-iclInput File"

  s.description  = <<-DESC
                  iCoastline 自定义Input数字键盘
                   DESC

  s.homepage     = 'https://github.com/super-chen/weex-plugin-ios-iclInput'

  s.license      = "MIT"

  s.author       = { "Frank Chen" => "superchen@live.cn" }

  s.platform     = :ios

  s.ios.deployment_target = "8.0"

  s.source       = { :git => 'https://github.com/super-chen/weex-plugin-ios-iclInput.git', :tag => s.version }

  s.source_files = "Classes/**/*.{h,m}"

  s.resources = "Classes/Resources/*"

  s.requires_arc = true

  s.dependency 'WeexSDK', '0.18'
end
