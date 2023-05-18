import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "nope",
    scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  );
  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  Future logout() => _googleSignIn.signOut();
}
