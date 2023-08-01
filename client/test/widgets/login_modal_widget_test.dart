import 'package:client/providers/context_provider.dart';
import 'package:client/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/widgets/login_modal_widget.dart';
import 'package:provider/provider.dart';

void main(){
  setUpAll(() async {
    await dotenv.load(fileName: "assets/.env");
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets('Login Modal Widget Test', (WidgetTester tester) async {
    // await tester.pumpWidget(
    //   MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider<ContextProvider>(
    //         create: (_) => ContextProvider(),
    //       ),
    //       ChangeNotifierProvider<ServiceProvider>(
    //         create: (_) => ServiceProvider(),
    //       ),
    //     ],
    //     child: MaterialApp(
    //       home: Scaffold(
    //         body: LoginModal(),
    //       ),
    //     ),
    //   ),
    // );
    final serviceProvider = ServiceProvider();
    final contextProvider = ContextProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ServiceProvider>.value(
            value: serviceProvider,
          ),
          ChangeNotifierProvider<ContextProvider>.value(
            value: contextProvider,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LoginModal(),
          ),
        ),
      ),
    );
    expect(find.byType(LoginModal), findsOneWidget);
    expect(find.text("Debug Mode Route"), findsOneWidget);

    //await tester.tap(find.widgetWithText(ElevatedButton, "Debug Mode Route"));
    //await tester.pumpAndSettle(Duration(seconds: 2));

    //await tester.enterText(, text)
  });
}