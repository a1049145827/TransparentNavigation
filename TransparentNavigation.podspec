Pod::Spec.new do |spec|
  spec.name         = 'TransparentNavigation'
  spec.version      = '1.0.0'
  spec.platform     = :ios, '8.0'
  spec.swift_version = '4.2'
  spec.summary      = 'Transparent Navigation for iOS'
  spec.homepage     = 'https://github.com/a1049145827/TransparentNavigation'
  spec.author       = { 'Geek Bruce' => 'a1049145827@hotmail.com' }
  spec.source       = { :git => 'https://github.com/a1049145827/TransparentNavigation.git', :tag => spec.version.to_s }
  spec.description  = 'Transparent Navigation Bar for iOS support enlarging image view and reappearance offset'
  spec.source_files = 'TransparentNavigation/*.swift'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
end