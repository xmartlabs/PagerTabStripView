Pod::Spec.new do |s|
  s.name             = "PagerTabStrip"
  s.version          = "1.0.0"
  s.summary          = "A short description of PagerTabStrip."
  s.homepage         = "https://github.com/xmartlabs/PagerTabStrip"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/xmartlabs/PagerTabStrip.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmartlabs'
  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.ios.source_files = 'PagerTabStrip/Sources/**/*.{swift}'
  # s.resource_bundles = {
  #   'PagerTabStrip' => ['PagerTabStrip/Sources/**/*.xib']
  # }
  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 4.0'
end
