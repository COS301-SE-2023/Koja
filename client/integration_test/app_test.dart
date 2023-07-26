import 'package:client/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client/main.dart' as app;
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });

  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('TimeBoundaries widget test', (WidgetTester tester) async {
      await tester.pumpWidget(KojaApp());
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsOneWidget);
      await Future.delayed(Duration(seconds: 3));

    });
  });

  //TODO: Add integration tests here
}

