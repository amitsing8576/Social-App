import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginwithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );

      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    //get the current logged in user from firebase

    final firebaseUser = _firebaseAuth.currentUser;

    //no user is logged in

    if (firebaseUser == null) {
      return null;
    }

    //user is logged in
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (!userDoc.exists) {
      return null;
    }
    return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userDoc['name']);
  }
}
