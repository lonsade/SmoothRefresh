Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "SmoothRefresh"
s.summary = "Refresh control without freezes and jumps."
s.requires_arc = true

# 2
s.version = "0.0.3"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4
s.author = { "Nikita Zhudin" => "dantes04015380209@gmail.com" }

# 5
s.homepage = "https://github.com/lonsade"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/lonsade/SmoothRefresh.git",
:tag => "v0.0.3" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "SmoothRefresh/**/*.{swift}"

# 10
s.swift_version = "4.2"

end
