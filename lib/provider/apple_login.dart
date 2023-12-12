import 'package:flutter/widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInHelper {
  static Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return credential;
    } catch (error) {
      print('Apple Sign-In Error: $error');
      return null;
    }
  }

  static Future<void> signOut() async {
    // Perform any necessary sign-out actions here
  }
}
