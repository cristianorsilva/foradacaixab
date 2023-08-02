import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import '../share/test_constants.dart' as constants;

Future<void> takeScreenshot(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String dirFeature, String dirDateHour, String dirTestName) async {
  DateFormat formatter = DateFormat('HH:mm:ss:SSSS');
  String screenshotName = formatter.format(DateTime.now()).replaceAll(":", "_");

  await tester.pumpAndSettle();
  await binding.takeScreenshot('${constants.mainDirectory}$dirFeature$dirDateHour$dirTestName$screenshotName');
}

String defineDirectoryDateHour() {
  DateFormat formatter;
  formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  String dirDateHour = "${formatter.format(DateTime.now()).replaceAll("/", "_").replaceAll(" ", "_").replaceAll(":", "_")}/";
  return dirDateHour;
}
