import 'package:bhakti_setu/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool isLoading = false;
  String? verificationId;
  String? error;
  User? user;

  // Send OTP
  Future<void> sendOtp(String phone) async {
    try {
      isLoading = true;
      notifyListeners();

      await repository.sendOtp(
        phone: phone,
        codesent: (id) {
          verificationId = id;
        },
        onError: (err) {
          error = err;
        },
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      isLoading = true;
      notifyListeners();

      user = await repository.verifyOtp(
        verificationId: verificationId!,
        otp: otp,
      );

      return user != null;
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
    user = repository.getUser();
    return user != null;
  }

  Future<void> logout() async {
    await repository.logout();
    user = null;
    notifyListeners();
  }
}
