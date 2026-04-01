import 'package:bhakti_setu/data/services/firebase/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<void> sendOtp({
    required String phone,
    required Function(String) codesent,
    required Function(String) onError,
  }) async {
    await service.sendOtp(
      phoneNumber: phone,
      codesent: codesent,
      onError: onError,
    );
  }

  Future<User?> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    return await service.verifyOtp(
      verificationId: verificationId,
      smsCode: otp,
    );
  }

  User? getUser() => service.getCurrentUser();

  Future<void> logout() => service.logout();
}
