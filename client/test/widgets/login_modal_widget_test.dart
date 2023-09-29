import 'package:koja/providers/context_provider.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/widgets/login_modal_widget.dart';
import 'package:provider/provider.dart';

void main(){
  setUpAll(() async {
    await dotenv.load(fileName: "assets/.env");
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets('Login Modal Widget Test', (WidgetTester tester) async {

    FlutterError.onError = ignoreOverflowErrors;
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


  });
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
    //debugPrint();
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}
