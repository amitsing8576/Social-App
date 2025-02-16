// auth repo to outline auth operations of this app

import 'package:socialapp/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginwithEmailAndPassword(String email, String password);
  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password, String name);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
