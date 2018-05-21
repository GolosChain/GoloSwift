Pod::Spec.new do |spec|

    spec.name               =   "GoloSwift"
    spec.platform           =   :ios, "10.0"
    spec.swift_version      =   "4.0"

    spec.summary            =   "Swift framework for Golos.io"
    spec.homepage           =   "https://golos.io/"
    spec.license            =   { :type => 'MIT', :file => 'LICENSE.md' }
    spec.author             =   "msm72"
    spec.source_files       =   "GoloSwift", "GoloSwift/**/*.{h,m,swift}"

    spec.version            =   "1.1.3"
    spec.source             =   { :git => "https://github.com/GolosChain/GoloSwift.git", :tag => "1.1.3" }

    # Cocoapods
    spec.dependency 'Locksmith'
    spec.dependency 'CryptoSwift'
    spec.dependency 'secp256k1.swift'
    spec.dependency 'BeyovaJSON', '~> 0.0'
    spec.dependency 'Starscream', '~> 3.0'
    spec.dependency 'Localize-Swift', '~> 2.0'

end
