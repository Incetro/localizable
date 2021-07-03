use_frameworks!

inhibit_all_warnings!

def standard_pods
  pod "incetro-observer-list", :git => 'https://github.com/Incetro/observer-list'
end

target 'Localizable IOS' do
  use_frameworks!
  platform :ios, "12.1"
  standard_pods
end

target 'Localizable tvOS' do
  use_frameworks!
  platform :tvos, "12.4"
  standard_pods
end

target 'Localizable macOS' do
  use_frameworks!
  platform :osx, "10.15"
  standard_pods
end

target 'Localizable watchOS' do
  use_frameworks!
  platform :watchos, "3.1"
  standard_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
            end
        end
    end
  installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end 