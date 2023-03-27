import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register User
  Future<User?> register(
    String email,
    String password,
    BuildContext context,
  ) async {
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  Future<User?> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  // Future<void> logout() async {
  //   try {
  //     await firebaseAuth.signOut();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        user = userCredential.user;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  Future signOut() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
