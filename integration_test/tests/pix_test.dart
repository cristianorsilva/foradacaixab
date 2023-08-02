import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:foradacaixab/database/pix_key_type.dart';
import 'package:foradacaixab/main.dart';
import 'package:integration_test/integration_test.dart';
import '../screens/home_screen.dart';
import '../screens/login_not_remembered_screen.dart';
import '../screens/pix/pix_screen.dart';
import '../screens/pix/pix_transfer_recipient_screen.dart';
import '../screens/transfer/transfer_receipt_screen.dart';
import '../screens/transfer/transfer_value_screen.dart';
import '../screens/transfer/verify_data_screen.dart';
import '../share/test_base.dart' as test_base;
import '../share/test_extensions.dart';
import 'package:intl/intl.dart';
import 'package:foradacaixab/main.dart' as app;

/// to run these tests on terminal:
/// (Windows): flutter drive \ --driver=test_driver/integration_test.dart \ --target=integration_test/tests/pix_test.dart \
/// (macOS): flutter drive --driver=test_driver/integration_test.dart --target=integration_test/tests/pix_test.dart

Future<void> main() async{

  IntegrationTestWidgetsFlutterBinding binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  String dirFeature = "Feature Pix/";
  String dirDateHour = test_base.defineDirectoryDateHour();
  String dirTestName = "";

  setUpAll(
        () async {
      if (Platform.isAndroid) {
        //await binding.convertFlutterSurfaceToImage();
        await binding.convertFlutterSurfaceToImage().onError((error, stackTrace) => null);
      }
      if (Platform.isIOS){
        binding.testTextInput.register(); //important to run on physical iOS devices
      }
    },
  );

  Future<void> takeScreenshot(WidgetTester tester) async {
    await test_base.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
  }

  group('Pix Transfer', () {

    testWidgets('TC 100 - Validate \'Transfer Data\' screen', (tester) async {
      //starts the app
      await app.main();
      //wait for app to be settled
      await tester.pumpAndSettle();

      //define the directory for the test result
      dirTestName = "TC 100 - Validate Transfer Data Screen/";

      try {
        //performs login
        await LoginNotRememberedScreen().informUserAndPassword(tester, '92903540039', '172839');
        await takeScreenshot(tester);
        await LoginNotRememberedScreen().dragButtonLogin(tester);
        await takeScreenshot(tester);
        await LoginNotRememberedScreen().tapButtonLogin(tester);

        //access pix screen and perform a transfer
        await HomeScreen().tapPix(tester);
        await takeScreenshot(tester);
        await PixScreen().tapPixTransfer(tester);
        await TransferValueScreen().informValueToTransfer(tester, '1,25');
        await takeScreenshot(tester);
        await TransferValueScreen().tapIconContinue(tester);
        await PixTransferRecipientScreen().selectPixKeyType(tester, EnumPixKeyType.cpf_cnpj);
        await PixTransferRecipientScreen().informPixKeyToTransfer(tester, '97114700040');
        await takeScreenshot(tester);
        await PixTransferRecipientScreen().tapIconContinue(tester);

        await takeScreenshot(tester);

        await VerifyDataScreen().dragRecipientAccountNumber(tester);
        await takeScreenshot(tester);

        await tester.pumpAndSettle();

        //validates the transfer data:
        tester.checkExpectedTextOnTextWidgets({
          VerifyDataScreen().checkTransferValue(tester, 'R\$ 1,25'),
          VerifyDataScreen().checkTransferWhen(tester, 'Agora'),
          VerifyDataScreen().checkTransferType(tester, 'Pix'),
          VerifyDataScreen().checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
          VerifyDataScreen().checkRecipientDocumentNumber(tester, '***.147.000-**'),
          VerifyDataScreen().checkRecipientBankName(tester, 'Banco Solar'),
          VerifyDataScreen().checkRecipientAgencyNumber(tester, '2258-4'),
          VerifyDataScreen().checkRecipientAccountNumber(tester, '32542-3'),
        });
      } catch (e) {
        await takeScreenshot(tester);
        rethrow;
      }
    });

    testWidgets('TC 101 - Successful Pix Transfer', (tester) async {
      //starts the app
      await app.main();
      //wait for app to be settled
      await tester.pumpAndSettle();

      //define the directory for the test result
      dirTestName = "TC 101 - Successful Pix Transfer/";

      try {
        //performs login
        await LoginNotRememberedScreen().informUserAndPassword(tester, '92903540039', '172839');
        await takeScreenshot(tester);
        await LoginNotRememberedScreen().dragButtonLogin(tester);
        await takeScreenshot(tester);
        await LoginNotRememberedScreen().tapButtonLogin(tester);

        //access pix screen and perform a transfer
        await HomeScreen().tapPix(tester);
        await takeScreenshot(tester);
        await PixScreen().tapPixTransfer(tester);
        await TransferValueScreen().informValueToTransfer(tester, '1,25');
        await takeScreenshot(tester);
        await TransferValueScreen().tapIconContinue(tester);
        await PixTransferRecipientScreen().selectPixKeyType(tester, EnumPixKeyType.cpf_cnpj);
        await PixTransferRecipientScreen().informPixKeyToTransfer(tester, '97114700040');
        await takeScreenshot(tester);
        await PixTransferRecipientScreen().tapIconContinue(tester);

        await takeScreenshot(tester);

        await VerifyDataScreen().dragRecipientAccountNumber(tester);
        await takeScreenshot(tester);

        await tester.pumpAndSettle();

        await VerifyDataScreen().tapButtonTransfer(tester);

        //screenshot from the first part of screen
        await takeScreenshot(tester);
        //scrolls the screen to make sure other elements are visible
        await TransferReceiptScreen().dragTransactionID(tester);
        //screenshot from the first part of screen
        await takeScreenshot(tester);

        tester.checkExpectedTextOnTextWidgets({
          //check transfer
          TransferReceiptScreen().checkTransferValue(tester, 'R\$ 1,25'),
          TransferReceiptScreen().checkTransferWhen(tester, DateFormat('dd/MM/yyyy').format(DateTime.now())),
          TransferReceiptScreen().checkTransferType(tester, 'Pix'),
          //check recipient
          TransferReceiptScreen().checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
          TransferReceiptScreen().checkRecipientDocumentNumber(tester, '971.147.000-40'),
          TransferReceiptScreen().checkRecipientBankName(tester, 'Banco Solar'),
          TransferReceiptScreen().checkRecipientAgencyNumber(tester, '2258-4'),
          TransferReceiptScreen().checkRecipientAccountNumber(tester, '32542-3'),
          TransferReceiptScreen().checkRecipientAccountType(tester, 'Conta Corrente'),
          //check sender
          TransferReceiptScreen().checkSenderUserName(tester, 'João Carlos da Silva'),
          TransferReceiptScreen().checkSenderDocumentNumber(tester, '929.035.400-39'),
          TransferReceiptScreen().checkSenderBankName(tester, 'CrediBank'),
          TransferReceiptScreen().checkSenderAgencyNumber(tester, '0124-5'),
          TransferReceiptScreen().checkSenderAccountNumber(tester, '12452-6'),
          TransferReceiptScreen().checkSenderAccountType(tester, 'Conta Corrente'),
          //check transaction id
          TransferReceiptScreen().checkTransactionID(tester, 'E7565486895648s89657978BH'),
        });

        await TransferReceiptScreen().dragClose(tester);
        await TransferReceiptScreen().tapClose(tester);
      } catch (e) {
        await takeScreenshot(tester);
        rethrow;
      }

    });
  });

}
