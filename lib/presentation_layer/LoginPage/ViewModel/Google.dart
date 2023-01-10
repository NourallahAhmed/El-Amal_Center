import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<AuthCredential?> logIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        //log error
        return null;
      }
      return await googleUser.authCredentials();
    } on Exception catch (exception, stackTrace) {
      //log error
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      await _googleSignIn.signOut();
    } on Exception catch (exception, stackTrace) {
      //log error
    }
  }
}

extension Credentials on GoogleSignInAccount? {
  Future<AuthCredential?> authCredentials() async {
    if (this == null) {
      return Future.value(null);
    }
    final auth = await this?.authentication;
    if (auth == null) {
      return Future.value(null);
    }
    if (auth.accessToken == null || auth.idToken == null) {
      return Future.value(null);
    }
    return GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
  }
}