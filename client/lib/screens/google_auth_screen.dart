// import 'dart:async';
// import 'dart:convert';

// import 'package:client/models/event_wrapper_module.dart';
// import 'package:client/screens/navigation_management_screen.dart';
// import 'package:client/widgets/event_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';
// // ...

// class GoogleAuthScreen extends StatefulWidget {
//   static const routeName = '/google-auth';
//   const GoogleAuthScreen({super.key});

//   @override
//   GoogleAuthScreenState createState() => GoogleAuthScreenState();
// }

// class GoogleAuthScreenState extends State<GoogleAuthScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final completer = Completer<BuildContext>();
//     if (!completer.isCompleted) {
//       completer.complete(context);
//     }
//     final provider = Provider.of<EventProvider>(context);
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Auth'),
//         ),
//         body: InAppWebView(
//           initialUrlRequest: URLRequest(
//             url: Uri.parse('http://localhost:8080/login/google'),
//           ),
//           initialOptions: InAppWebViewGroupOptions(
//             crossPlatform: InAppWebViewOptions(
//               clearCache: true,
//               userAgent:
//                   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36',
//             ),
//           ),
//           onLoadStop: (InAppWebViewController controller, Uri? uri) async {
//             List<EventWrapper> events = [];
//             if (uri != null) {
//               String responseBody = await controller.evaluateJavascript(
//                   source: 'document.body.innerHTML');
//               final response = jsonDecode(responseBody);
//               for (var obj in response) {
//                 events.add(EventWrapper(jsonEncode(obj)));
//               }
//               provider.setEventWrappers(events);
//               completer.future.then((context) {
//                 Navigator.of(context)
//                     .pushReplacementNamed(NavigationScreen.routeName);
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
