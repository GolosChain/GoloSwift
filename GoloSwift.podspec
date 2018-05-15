Pod::Spec.new do |spec|

    spec.name               =   "GoloSwift"
    spec.swift_version      =   "4"
    spec.version            =   "1.0.2"
    spec.summary            =   "Swift framework for Golos.io"
    spec.homepage           =   "https://golos.io/"
    spec.license            =   "MIT"
    spec.author             =   "msm72"
    spec.platform           =   :ios, "10.0"
    spec.source             =   { :git => "https://github.com/Monserg/GoloSwift.git", :tag => "1.0.2" }
    spec.source_files       =   "GoloSwift", "GoloSwift/**/*.{h,m,swift}"

    # Cocoapods
    spec.dependency 'Locksmith'
    spec.dependency 'CryptoSwift'
    spec.dependency 'secp256k1.swift'
    spec.dependency 'BeyovaJSON', '~> 0.0'
    spec.dependency 'Localize-Swift', '~> 2.0'

end
