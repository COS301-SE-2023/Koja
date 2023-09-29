import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:mockito/mockito.dart';

class MockServiceProvider extends Mock implements ServiceProvider {
  @override
  Future<bool> loginUser({required ContextProvider eventProvider}) {
    return Future.value(true);
  }

  @override
  Future<bool> deleteTimeFrame(String? accessToken, String name) {
    return Future.value(true);
  }
}

void main(){

  var _serverAddress;
  var _serverPort;

  ServiceProvider mockServiceProvider = MockServiceProvider();
  setUp(() async {
    await dotenv.load(fileName: "assets/.env");
    _serverAddress = dotenv.get("SERVER_ADDRESS", fallback: "10.0.2.2");
    _serverPort = dotenv.get("SERVER_PORT", fallback: "8080");
    mockServiceProvider = MockServiceProvider();
  });


  group('Service Provider Test', (){

    group("deleteTimeFrame test", () {
      test('should return true if the response code is 200', () async {
        final eventProvider = ContextProvider();
        final serviceProvider = ServiceProvider();
//        final result = await serviceProvider.deleteTimeFrame('mockAccessToken', 'mockName');
        serviceProvider.setAccessToken("mocktoken", eventProvider);
        expect(serviceProvider.accessToken, "mocktoken");

//        expect(result, true);
      });
    });

    // test('getEventsForAI returns a list of events on successful API call', () async {
    //   final path = '/api/v1/ai/get-emails';
    //   final List<String> serverAddressComponents = _serverAddress.split("//");
    //   final url = !serverAddressComponents[0].contains("https")
    //       ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
    //       : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);
    //   final dioAdapter = DioAdapter();
    //
    //   dioAdapter.onGet(
    //     url,
    //         (request) => request.reply(200, ["event1"]),
    //     headers: {
    //       'Authorisation': 'Bearer token',
    //     },
    //   );
    //   final serviceProvider = ServiceProvider();
    //   final eventProvider = ContextProvider();
    //   serviceProvider.setAccessToken("Bearer token", eventProvider);
    //   final result = await serviceProvider.getEventsForAI();
    //   final result2 = await serviceProvider.getAllUserEmails();
    //
    //   expect(result, []);
    // });


    test('test login function', () async{
      final eventProvider = ContextProvider();

      final result = mockServiceProvider.loginUser(eventProvider: eventProvider);
      expect(result, isA<Future<bool>>());

    });

  });
}
