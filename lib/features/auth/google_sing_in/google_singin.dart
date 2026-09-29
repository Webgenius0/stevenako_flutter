import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
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

      dev.log('🔑 Tokens received:', name: 'GoogleSignIn');
      dev.log('   ├─ accessToken : ${googleAuth.accessToken ?? 'NULL ❌'}', name: 'GoogleSignIn');
      dev.log('   └─ idToken     : ${googleAuth.idToken ?? 'NULL ❌'}', name: 'GoogleSignIn');

      // Step 3 – Build Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      dev.log('🔐 Firebase credential created (provider: ${credential.providerId})', name: 'GoogleSignIn');

      // Step 4 – Sign in to Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      dev.log('🎉 Firebase Sign-In SUCCESS:', name: 'GoogleSignIn');
      dev.log('   ├─ uid              : ${user?.uid}', name: 'GoogleSignIn');
      dev.log('   ├─ displayName      : ${user?.displayName}', name: 'GoogleSignIn');
      dev.log('   ├─ email            : ${user?.email}', name: 'GoogleSignIn');
      dev.log('   ├─ emailVerified    : ${user?.emailVerified}', name: 'GoogleSignIn');
      dev.log('   ├─ phoneNumber      : ${user?.phoneNumber ?? 'N/A'}', name: 'GoogleSignIn');
      dev.log('   ├─ photoURL         : ${user?.photoURL}', name: 'GoogleSignIn');
      dev.log('   ├─ isAnonymous      : ${user?.isAnonymous}', name: 'GoogleSignIn');
      dev.log('   ├─ isNewUser        : ${userCredential.additionalUserInfo?.isNewUser}', name: 'GoogleSignIn');
      dev.log('   ├─ providerId       : ${userCredential.additionalUserInfo?.providerId}', name: 'GoogleSignIn');
      dev.log('   ├─ creationTime     : ${user?.metadata.creationTime}', name: 'GoogleSignIn');
      dev.log('   └─ lastSignInTime   : ${user?.metadata.lastSignInTime}', name: 'GoogleSignIn');

      if (user?.providerData.isNotEmpty == true) {
        dev.log('📋 Provider data:', name: 'GoogleSignIn');
        for (final p in user!.providerData) {
          dev.log('   ├─ providerId : ${p.providerId}', name: 'GoogleSignIn');
          dev.log('   ├─ uid        : ${p.uid}', name: 'GoogleSignIn');
          dev.log('   ├─ email      : ${p.email}', name: 'GoogleSignIn');
          dev.log('   └─ displayName: ${p.displayName}', name: 'GoogleSignIn');
        }
      }

      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignIn');

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