
target 'SketchyCode' do
  use_frameworks!

  pod 'StencilSwiftKit', '~> 1.0'
  pod 'Commander'
  pod 'PathKit'
  pod 'Marshal'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
