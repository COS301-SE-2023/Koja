import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthModel {
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    return await _googleSignIn.signIn();
  }

  // static Future logout() => _googleSignIn.signOut();
}
