import 'package:client/providers/service_provider.dart';
import 'package:client/widgets/location_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

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
    final locationList = [
      ['Location 1', 'lat1', 'lng1'],
      ['Location 2', 'lat2', 'lng2'],
      ['Location 3', 'lat3', 'lng3'],
    ];
    
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
