flutter clean
flutter pub get

date_time_run=$(date +"%d_%m_%Y %H:%M:%S")

pushd android
# flutter build generates files in android/ for building the app
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/tests/login_test.dart
popd

gcloud firebase test android run --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --device-ids=crownqlteue \
  --os-version-ids=29 \
  --orientations=portrait \
  --use-orchestrator \
  --timeout 4m \
  --results-bucket=gs://fora-da-caixa-0001.appspot.com \
  --results-dir=android/tests/"$date_time_run"


# para pegar a lista de dispositivos disponíveis: gcloud firebase test android models list
# para pegar o caminho do results-bucket, ir no firebase storage, e ver os detalhes do projeto. Copie a url criada

