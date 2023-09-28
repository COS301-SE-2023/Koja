import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:koja/widgets/all_emails_widget.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:provider/provider.dart';

void main(){

  setUp(() async{
    await dotenv.load(fileName: 'assets/.env');
  });

  group('All emails widget tests', (){
      testWidgets('UI test', (WidgetTester tester) async{
        final serviceProvider = ServiceProvider();
        final contextProvider = ContextProvider();
        final deleteFunction = (BuildContext context) {};
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
                body: AllEmailsWidget("test@example.com", deleteFunction),
              ),
            ),
          ),
        );

          expect(find.byType(AllEmailsWidget),findsOneWidget);
          expect(find.text("test@example.com"), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });
  });
}