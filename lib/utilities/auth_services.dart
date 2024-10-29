// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(
      {required BuildContext context,
      required Map texts,
      required String email,
      required String password,
      required String checkPassword,
      required String name}) async {
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        if (password.length >= 6) {
          if (password == checkPassword) {
            UserCredential credential =
                await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
            await _firestore.collection('Users').doc(credential.user!.uid).set({
              'name': name,
              'email': email,
              'subscriptionType': 'trial',
              'subscriptionStartDate': DateTime.now().toString(),
              'shareWith': '',
              'createdAt': DateTime.now().toString()
            });
            Navigator.pushNamed(context, '/sell');
            return 'success';
          } else {
            showSnackBar(context, texts['login'][15]);
            return 'passwords not equal';
          }
        } else {
          showSnackBar(context, texts['login'][10]);
          return 'short password';
        }
      } else {
        showSnackBar(context, texts['login'][8]);
        return 'fields not filled';
      }
    } catch (e) {
      String errorMessage = '';
      if (e.toString().contains('invalid-email')) {
        errorMessage = texts['login'][20];
      }
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = texts['login'][22];
      } else {
        errorMessage = "${texts['login'][9]}\n$e";
      }
      showSnackBar(context, errorMessage);
      return e.toString();
    }
  }

  Future<String> logIn(
      {required BuildContext context,
      required Map texts,
      required String email,
      required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        try {
          final user = FirebaseAuth.instance.currentUser;
          final uid = user!.uid;

          final docSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .get();

          String subscription = docSnapshot.data()!['subscriptionType'];
          Navigator.pushNamed(
              context, subscription == 'trial' ? '/sell' : '/dashboard');
        } catch (e) {
          showSnackBar(context, texts['login'][9]);
          return e.toString();
        }

        return 'success';
      } else {
        showSnackBar(context, texts['login'][7]);
        return 'fields not filled';
      }
    } catch (e) {
      String errorMessage = '';
      if (e.toString().contains('invalid-email')) {
        errorMessage = texts['login'][20];
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = texts['login'][21];
      } else {
        errorMessage = texts['login'][9];
      }
      showSnackBar(context, errorMessage);
      return e.toString();
    }
  }

  Future<String> logOut(context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamed(context, '/intro');
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> forgotPassowrd(context, texts, email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      showSnackBar(
        context,
        texts['login'][13],
      );
    }).onError((error, stachTrace) {
      showSnackBar(
        context,
        error.toString(),
      );
    });
  }
}
