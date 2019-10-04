#
#  Be sure to run `pod spec lint BottomHalfModal.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "BottomHalfModal"
  spec.version      = "1.0.0"
  spec.summary      = "A customizable bottom half modal used in merpay"

  spec.description  = <<-DESC
  A customizable bottom half modal used in merpay
                   DESC

  spec.homepage     = "https://github.com/mercari/BottomHalfModal"
  spec.screenshots  = "https://github.com/mercari/BottomHalfModal/raw/master/Screenshots/basic.gif"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = ['Mercari, Inc.']
  spec.ios.deployment_target = "11.0"
  spec.source       = { :git => 'https://github.com/mercari/BottomHalfModal.git', :tag => spec.version.to_s }

  spec.source_files = "BottomHalfModal/**/*.swift"

  spec.frameworks = "UIKit"

  spec.cocoapods_version = '>= 1.4.0'
  spec.swift_version = '5.0'

end
