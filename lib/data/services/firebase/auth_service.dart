import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send OTP
  Future<void> sendOtp({
    required String phoneNunber,
    required Function(String verificationId) codesent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Verification Failed");
      },
      codeSent: (verificationId, resendToken) {
        codesent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
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
}
