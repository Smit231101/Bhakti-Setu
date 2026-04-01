import 'dart:async';

import 'package:bhakti_setu/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  late final Stream<User?> authStateChanges;
  late final StreamSubscription<User?> _authSubscription;

  AuthProvider(this.repository) {
    authStateChanges = repository.authStateChanges().asBroadcastStream();
    _authSubscription = authStateChanges.listen((currentUser) {
      user = currentUser;
      notifyListeners();
    });
    user = repository.getUser();
  }

  bool isLoading = false;
  String? verificationId;
  String? error;
  User? user;

  // Send OTP
  Future<void> sendOtp(String phone) async {
    try {
      isLoading = true;
      error = null;
      verificationId = null;
      user = null;
      notifyListeners();

      verificationId = await repository.sendOtp(phone: phone);

      if (verificationId == null) {
        user = repository.getUser();
      }
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.code;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      if (verificationId == null) {
        error = "OTP session expired. Please request a new OTP.";
        return false;
      }

      user = await repository.verifyOtp(
        verificationId: verificationId!,
        otp: otp.trim(),
      );

      return user != null;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.code;
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Check login
  bool isLoggedIn() {
    return user != null;
  }

  Future<void> logout() async {
    await repository.logout();
    user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
