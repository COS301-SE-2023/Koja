import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class GoogleSignInApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "nope",
    scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  );
  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  Future logout() => _googleSignIn.signOut();

  // Initialize the browser oauth2 flow functionality then use it to obtain credentials.
  Future<AccessCredentials> obtainCredentials() async {
    return await requestAccessCredentials(
        clientId:
            "317800768757-1o32l18bigldbdn6gta1rcbl5m04l8gd.apps.googleusercontent.com",
        scopes: [
          'email',
          'https://www.googleapis.com/auth/calendar.events',
        ]);
  }
}
