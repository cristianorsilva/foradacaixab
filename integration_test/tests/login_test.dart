import 'dart:io';

import 'package:foradacaixab/main.dart' as app;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../screens/home_screen.dart';
import '../screens/login_not_remembered_screen.dart';

/// to run these tests on terminal:
/// (Windows): flutter drive \ --driver=test_driver/integration_test.dart \ --target=integration_test/tests/login_test.dart \
/// (macOS): flutter drive --driver=test_driver/integration_test.dart --target=integration_test/tests/login_test.dart



Future<void> main() async{

  IntegrationTestWidgetsFlutterBinding binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(
        () async {
      if (Platform.isAndroid) {
        //await binding.convertFlutterSurfaceToImage();
        //await binding.convertFlutterSurfaceToImage().onError((error, stackTrace) => null);
      }
      if (Platform.isIOS){
        binding.testTextInput.register(); //important to run on physical iOS devices
      }
    },
  );

  group('Login Tests', () {
    testWidgets('TC 001 - Invalid Password', (tester) async{
      //starts the app
      await app.main();
      //wait for app to be settled
      await tester.pumpAndSettle();

      await LoginNotRememberedScreen().informUserAndPassword(tester, '92903540039', '172838');
      await LoginNotRememberedScreen().tapButtonLogin(tester);

      //expects to find message
      //expect(find.text('Usuário ou senha inválidos'), findsOneWidget);
      //expects to find message
      LoginNotRememberedScreen().checkTextAlertDialogMessage(tester, 'Usuário ou senha inválidos').call();

    });

    testWidgets('TC 002 - Successful Login', (tester) async{
      //starts the app
      await app.main();
      //wait for app to be settled
      await tester.pumpAndSettle();

      await LoginNotRememberedScreen().informUserAndPassword(tester, '92903540039', '172839');
      await LoginNotRememberedScreen().tapButtonLogin(tester);
      //if logged with success, expects to find the welcome message for user
      HomeScreen().checkTextWelcomeUser(tester, 'Olá, João').call();
    });

  });

}