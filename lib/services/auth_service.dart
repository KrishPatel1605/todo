import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  Future<AuthResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign-in aborted');
    }
    final googleAuth = await googleUser.authentication;

    // Sign in to Supabase with Google ID token
    final response = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
    return response;
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await _googleSignIn.signOut();
  }

  User? get user => Supabase.instance.client.auth.currentUser;
}
