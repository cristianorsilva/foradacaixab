output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="16.4"

flutter build ios --target=integration_test/tests/pix_test.dart --release

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd

# xcodebuild test-without-building -xctestrun "build/ios_integ/Build/Products/Runner_iphoneos16.1-arm64.xctestrun" -destination 'name=iPhone de Cristiano'