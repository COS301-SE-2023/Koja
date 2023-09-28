import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:provider/provider.dart';
import 'package:koja/widgets/account_settings_widget.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:integration_test/integration_test.dart';
import 'package:koja/widgets/add_email_widget.dart';
import 'package:mockito/mockito.dart';

void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });

  group('Account settings widget tests', () {
    //WidgetsFlutterBinding.ensureInitialized();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('AccountSettingsWidget UI Test', (WidgetTester tester) async {
      //FlutterError.onError = ignoreOverflowErrors;
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
              body: AccountSettingsWidget(),
            ),
          ),
        ),
      );

      expect(find.text('Add another email address'), findsOneWidget);
      expect(find.text('Add Email'), findsOneWidget);
      expect(find.text('Delete Account'), findsNWidgets(2));
      //expect(find.text('Cancel'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });

  testWidgets('Add-Email integration testing', (WidgetTester tester) async{
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
            body: AccountSettingsWidget(),
          ),
        ),
      ),
    );
    FlutterError.onError = ignoreOverflowErrors;
    await tester.pumpAndSettle();
    expect(find.byType(AccountSettingsWidget), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(AddEmailModal), findsOneWidget);
  });

  testWidgets('DeleteEmail cancel Integration Test', (WidgetTester tester) async {
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
            body: AccountSettingsWidget(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Are you sure you want to delete this account?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('DeleteEmail delete test', (WidgetTester tester) async {
    final serviceProvider = MockServiceProvider();
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
            body: AccountSettingsWidget(),
          ),
        ),
      ),
    );

    // when(serviceProvider.deleteUserAccount())
    //     .thenReturn(Future.value(true));

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Are you sure you want to delete this account?'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

  });


}

class MockServiceProvider extends Mock implements ServiceProvider {

  @override
  Future<bool> deleteUserAccount() {
    return Future.value(true);
  }
}

void ignoreOverflowErrors(
    FlutterErrorDetails details, {
      bool forceReport = false,
    }) {
  bool ifIsOverflowError = false;
  bool isUnableToLoadAsset = false;
  // Detect overflow error.
  var exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError = !exception.diagnostics.any(
          (e) => e.value.toString().startsWith("A RenderFlex overflowed by"),
    );
    isUnableToLoadAsset = !exception.diagnostics.any(
          (e) => e.value.toString().startsWith("Unable to load asset"),
    );
  }
  // Ignore if is overflow error.
  if (ifIsOverflowError || isUnableToLoadAsset) {
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}

