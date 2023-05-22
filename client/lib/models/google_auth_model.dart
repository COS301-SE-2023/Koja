import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;

class GoogleSignInApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "nope",
    scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  );
  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  Future logout() => _googleSignIn.signOut();

  Future<AccessCredentials> obtainCredentials() async {
    final completer = Completer<AccessCredentials>();

    final token = await requestAccessCredentials(
      clientId:
          "317800768757-1o32l18bigldbdn6gta1rcbl5m04l8gd.apps.googleusercontent.com",
      scopes: [
        'email',
        'https://www.googleapis.com/auth/calendar',
      ],
    );

    final response = await http.post(
      Uri.parse("http://localhost:8080/establishSession"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(token.toJson()),
    );

    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      print('Data sent successfully');
      completer.complete(token);
    } else {
      completer.completeError(Exception('Failed to send data'));
    }
    return completer.future;
  }
}
