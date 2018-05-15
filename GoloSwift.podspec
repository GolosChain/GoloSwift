Pod::Spec.new do |s|
#1.
s.name              =   "GoloSwift"
#2.
s.version           =   "1.0.0"
#3.
s.summary           =   "Swift framework for Golos.io"
#4.
s.homepage          =   "https://golos.io/"
#5.
s.license           =   "MIT"
#6.
s.author            =   "msm72"
#7.
s.platform          =   :ios, "10.0"
#8.
s.source            =   { :git => "URL", :tag => "1.0.0" }
#9.
s.source_files      =   "GoloSwift", "GoloSwift/**/*.{h,m,swift}"
#10.
s.frameworks        =   'BeyovaJSON'
s.ios.dependency        'BeyovaJSON', '~> 0.0'
s.requires_arc      =   true
end
