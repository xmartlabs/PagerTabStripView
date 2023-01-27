Pod::Spec.new do |s|
  s.name             = "PagerTabStripView"
  s.version          = "4.0.0"
  s.summary          = "PagerTabStripView allows navigating through pages using a custom navigation bar in SwiftUI."
  s.homepage         = "https://github.com/xmartlabs/PagerTabStripView"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.authors          = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/xmartlabs/PagerTabStripView.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmartlabs'
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.7'
  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*.{swift}'
  s.ios.frameworks = 'SwiftUI'
end
