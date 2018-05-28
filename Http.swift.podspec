Pod::Spec.new do |s|
    s.name             = 'Http.swift'
    s.version          = '2.1.2'
    s.summary          = 'A tiny http server engine written in swift.'
    s.homepage         = 'https://github.com/BiAtoms/Http.swift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Orkhan Alikhanov' => 'orkhan.alikhanov@gmail.com' }
    s.source           = { :git => 'https://github.com/BiAtoms/Http.swift.git', :tag => s.version.to_s }
    s.module_name      = 'HttpSwift'

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.tvos.deployment_target = '9.0'
    s.source_files = 'Sources/*.swift'
    s.dependency 'Socket.swift', '~> 2.2'
end
