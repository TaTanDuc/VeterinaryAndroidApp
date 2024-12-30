import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user!;
  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Sign-in failed or cancelled');
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google authentication failed: missing token');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
    } catch (e, stackTrace) {
      print("Error during Google Sign-In: $e");
      print("Stack trace: $stackTrace");
    }
  }
}
