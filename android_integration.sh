flutter clean
flutter pub get

pushd android
# flutter build generates files in android/ for building the app
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/tests/login_test.dart

popd

# Se a execução acima falhar, rode os comandos: flutter clean e flutter pub get e então execute novamente

# para testar, rode o comando: ./gradlew app:connectedAndroidTest -Ptarget='pwd'/../integration_test/tests/login_test.dart