// Auth cubit : State management for authentication

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/data/firebase_auth_repo.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/domain/repos/auth_repo.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit(FirebaseAuthRepo authrepo, {required this.authRepo})
      : super(AuthInitial());

  // check if user is already authenticated

  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(unAuthenticated());
    }
  }

  //get current user

  AppUser? get currentUser => _currentUser;

  //login user

  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginwithEmailAndPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(unAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(unAuthenticated());
    }
  }

  //register user
  Future<void> register(String email, String pw, String name) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(email, pw, name);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(unAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(unAuthenticated());
    }
  }

  //logout user
  Future<void> logout() async {
    await authRepo.logout();
    _currentUser = null;
    emit(unAuthenticated());
  }
}
