import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthModel {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    // scopes: [
    //   'email',
    //   'https://www.googleapis.com/auth/contacts.readonly',
    // ],
  );

  static Future<GoogleSignInAccount?> login() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      return googleSignInAccount;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }
}