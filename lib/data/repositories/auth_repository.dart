import 'package:bhakti_setu/data/services/firebase/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Stream<User?> authStateChanges() => service.authStateChanges();

  Future<String?> sendOtp({required String phone}) async {
    return service.sendOtp(phoneNumber: phone);
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
