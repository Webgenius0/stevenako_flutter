import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/rx.dart';

class GoogleServicesAccount {
  // Lazy so FirebaseAuth is only accessed after Firebase.initializeApp() runs
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _rx = GoogleSignInRx();

  // ─────────────────────────────────────────────
  // SIGN IN
  // ─────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');
    dev.log('🔵 Starting Google Sign-In flow...', name: 'GoogleSignIn');

    try {
      // Step 1 – Google account chooser
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        dev.log('⚠️  User cancelled the Google account chooser.', name: 'GoogleSignIn');
        return null;
      }

      dev.log('✅ Google account selected:', name: 'GoogleSignIn');
      dev.log('   ├─ displayName : ${googleUser.displayName}', name: 'GoogleSignIn');
      dev.log('   ├─ email       : ${googleUser.email}', name: 'GoogleSignIn');
      dev.log('   ├─ id          : ${googleUser.id}', name: 'GoogleSignIn');
      dev.log('   └─ photoUrl    : ${googleUser.photoUrl}', name: 'GoogleSignIn');

      // Step 2 – Exchange for tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (kDebugMode) {
        dev.log('🔑 Tokens received (accessToken available: ${googleAuth.accessToken != null}, idToken available: ${googleAuth.idToken != null})', name: 'GoogleSignIn');
      }

      // Step 3 – Build Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (kDebugMode) {
        dev.log('🔐 Firebase credential created (provider: ${credential.providerId})', name: 'GoogleSignIn');
      }

      // Step 4 – Sign in to Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (kDebugMode) {
        dev.log('🎉 Firebase Sign-In SUCCESS (uid: ${user?.uid}, isNewUser: ${userCredential.additionalUserInfo?.isNewUser})', name: 'GoogleSignIn');
      }

      // Step 5 – Send access_token to backend to get app JWT token
      await _rx.loginWithGoogle(accessToken: googleAuth.accessToken ?? '');

      return userCredential;
    } catch (e, stackTrace) {
      dev.log('❌ Google Sign-In ERROR:', name: 'GoogleSignIn', error: e, stackTrace: stackTrace);
      dev.log('   └─ ${e.toString()}', name: 'GoogleSignIn');
      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // SIGN OUT
  // ─────────────────────────────────────────────
  Future<void> signOut() async {
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');
    dev.log('🔴 Starting Google Sign-Out...', name: 'GoogleSignIn');
    try {
      final User? userBefore = _firebaseAuth.currentUser;
      dev.log('   └─ signing out user: ${userBefore?.email ?? 'unknown'}', name: 'GoogleSignIn');

      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      dev.log('✅ Sign-Out successful.', name: 'GoogleSignIn');
      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');
    } catch (e, stackTrace) {
      dev.log('❌ Sign-Out ERROR:', name: 'GoogleSignIn', error: e, stackTrace: stackTrace);
      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');
    }
  }
}