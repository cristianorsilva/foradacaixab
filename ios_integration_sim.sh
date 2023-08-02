output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="16.4"

flutter build ios --target=integration_test/tests/login_test.dart --simulator

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -derivedDataPath $output -sdk iphonesimulator build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Debug-iphonesimulator" "Runner_iphonesimulator$dev_target-arm64-x86_64.xctestrun"
popd


#xcodebuild test-without-building -xctestrun "build/ios_integ/Build/Products/Runner_iphonesimulator16.1-arm64-x86_64.xctestrun" -destination id=3A69D4A4-AC22-4A1A-8C69-FBFF12B0222F