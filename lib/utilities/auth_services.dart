// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp({
    required BuildContext context,
    required Map texts,
    required String email,
    required String password,
    required String checkPassword,
    required String name,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar(context, texts['login'][8]);
      return 'fields not filled';
    }
    if (password.length < 6) {
      showSnackBar(context, texts['login'][10]);
      return 'short password';
    }
    if (password != checkPassword) {
      showSnackBar(context, texts['login'][15]);
      return 'passwords not equal';
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'subscriptionType': 'trial',
        'subscriptionStartDate': DateTime.now().toString(),
        'subscriptionId': '',
        'customerId': '',
        'shareWith': '',
        'createdAt': DateTime.now().toString(),
      });

      Navigator.pushNamed(context, '/sell');
      return 'success';
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('invalid-email')) {
        errorMessage = texts['login'][20];
      } else if (e.toString().contains('email-already-in-use')) {
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

          String? userStripeId =
              await StripeServices().getCustomerIdByEmail(email);
          if (userStripeId == null) {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(await AuthServices().getUserUID())
                .update({'subscritionId': '', 'subscriptionType': 'trial'});
          } else {
            String? subscriptionId =
                await StripeServices().getActiveSubscriptionId(userStripeId);
            if (subscriptionId == null) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(await AuthServices().getUserUID())
                  .update({'subscritionId': '', 'subscriptionType': 'trial'});
            } else {
              String? planId = await StripeServices().getPlanId(subscriptionId);
              if (planId == null) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(await AuthServices().getUserUID())
                    .update({'subscritionId': '', 'subscriptionType': 'trial'});
              } else {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(await AuthServices().getUserUID())
                    .update({
                  'subscritionId': subscriptionId,
                  'subscriptionType': (planId == StripeServices().soloBRLId ||
                          planId == StripeServices().soloUSDId)
                      ? 'solo'
                      : (planId == StripeServices().teamBRLId ||
                              planId == StripeServices().teamUSDId)
                          ? 'team'
                          : 'trial'
                });
              }
            }
          }
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
      await _auth.signOut().then((value) {
        Navigator.pushNamed(context, '/intro');
      });

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

  Future<String> getUserUID() async {
    final user = FirebaseAuth.instance.currentUser;

    return user!.uid;
  }

  Future<String> getUserSubscription() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(await getUserUID())
        .get();

    return docSnapshot.data()!['subscriptionType'];
  }

  Future<String> getUserCustomerId() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(await getUserUID())
        .get();

    return docSnapshot.data()!['customerId'];
  }

  Future<String> getUserEmail() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(await getUserUID())
        .get();

    return docSnapshot.data()!['email'];
  }

  Future<String> getUserName() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(await getUserUID())
        .get();

    return docSnapshot.data()!['name'];
  }
}
