import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Send OTP
  Future<String?> sendOtp({
    required String phoneNumber,
  }) async {
    final normalizedPhoneNumber = _normalizePhoneNumber(phoneNumber);

    if (normalizedPhoneNumber == null) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'Enter a valid phone number',
      );
    }

    final completer = Completer<String?>();

    if (kDebugMode) {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: normalizedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (verificationId, resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw FirebaseAuthException(
          code: 'timeout',
          message: 'Timed out while waiting for OTP. Please try again.',
        );
      },
    );
  }

  // Verify OTP
  Future<User?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  String? _normalizePhoneNumber(String rawPhoneNumber) {
    final compact = rawPhoneNumber.replaceAll(RegExp(r'[\s()-]'), '');

    if (compact.isEmpty) {
      return null;
    }

    if (compact.startsWith('+') && RegExp(r'^\+\d{10,15}$').hasMatch(compact)) {
      return compact;
    }

    if (RegExp(r'^\d{10}$').hasMatch(compact)) {
      return '+91$compact';
    }

    if (RegExp(r'^91\d{10}$').hasMatch(compact)) {
      return '+$compact';
    }

    return null;
  }
}
