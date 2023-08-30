import 'package:koja/providers/service_provider.dart';
import 'package:koja/widgets/location_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Create a mock for ServiceProvider to simulate its behavior during testing

void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });
  // Test the LocationListWidget
  testWidgets('LocationListWidget Test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Create a mock instance of the ServiceProvider
    final serviceProvider = ServiceProvider();

    // Prepare some dummy location list data

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ServiceProvider>.value(
            value: serviceProvider,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LocationListWidget(),
          ),
        ),
      ),
    );

    // Test if the LocationListWidget is rendered on the screen
    expect(find.byType(LocationListWidget), findsOneWidget);



  });
}
