Pod::Spec.new do |s|
  s.name         = "networkapihelper"
  s.version      = "1.0.0"
  s.summary      = "base on afnetworking Cache"
  s.description  = <<-DESC
		   code for networking Cache similar for
 		   DESC
  s.homepage     = "https://github.com/greathjh/networkCache"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "greathjh" => "hdgfh000@163.com" }
  s.authors            = { "greathjh" => "hdgfh000@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/greathjh/networkCache.git", :tag => "#{s.version}" }

s.subspec 'apiTools' do |tools|
    tools.source_files = 'AFNetworking/AFSecurityPolicy.{h,m}'
    tools.public_header_files = "AFNetworking/AFSecurityPolicy.h"
    #tools.frameworks = "SystemConfiguration"
  end

  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "MJExtension", "~> 3.0.13"
  s.dependency "PINCache"
  s.dependency "AFNetworking"
  s.dependency "YYModel"

end
