import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:koja/Utils/event_util.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:koja/widgets/settings_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });
  //WidgetsFlutterBinding.ensureInitialized();
  testWidgets('Settings Widget Tests', (WidgetTester tester) async{

    final serviceProvider = ServiceProvider();
    final contextProvider = ContextProvider();
    FlutterError.onError = ignoreOverflowErrors;

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
            body: Settings(),
          ),
        ),
      ),
    );
    expect(find.byType(Settings), findsOneWidget);
    expect(find.text('Set Your Active Times'), findsOneWidget);
    expect(find.text('Set Your Location'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(2));

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
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}