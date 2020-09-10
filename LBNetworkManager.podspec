Pod::Spec.new do |spec|
  spec.name         = "LBNetworkManager"
  spec.version      = "1.0.0"
  spec.summary      = "对AFNetworking实用性封装。"
  spec.description  = "对AFNetworking进行针项目的实用性封装。"
  spec.homepage     = "https://github.com/A1129434577/LBNetworkManager"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBNetworkManager.git', :tag => spec.version.to_s }
  spec.dependency     "AFNetworking"
  spec.source_files = "LBNetworkManager/**/*.{h,m}"
  spec.requires_arc = true
end
#--use-libraries
