Pod::Spec.new do |spec|
  spec.name          = 'incetro-localizable'
  spec.module_name   = 'Localizable'
  spec.version       = '1.0.0'
  spec.license       = 'MIT'
  spec.authors       = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage      = "https://github.com/Incetro/localizable.git"
  spec.summary       = 'Open Source'

  spec.ios.deployment_target     = "12.0"
  spec.osx.deployment_target     = "10.15"
  spec.watchos.deployment_target = "3.1"
  spec.tvos.deployment_target    = "12.4"

  spec.swift_version = '5.0'
  spec.source        = { git: "https://github.com/Incetro/localizable.git", tag: "#{spec.version}" }
  spec.source_files  = "Sources/Localizable/**/*.{h,swift}"

  spec.dependency 'incetro-observer-list'
end