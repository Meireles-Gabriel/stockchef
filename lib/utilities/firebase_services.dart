// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class FirebaseServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'subscriptionType': 'trial',
        'subscriptionStartDate': DateTime.now().toString(),
        'subscriptionId': '',
        'subscriptionStatus': 'notSubscribed',
        'customerId': '',
        'shareWith': [],
        'receiveFrom': [],
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
        await auth.signInWithEmailAndPassword(email: email, password: password);
        try {
          String? subscription =
              await StripeServices().getCustomerSubscription();
          final docSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(auth.currentUser!.uid)
              .get();

          List receiveFrom = docSnapshot.data()!['receiveFrom'];
          Navigator.pushNamed(
              context,
              (subscription == 'trial' && receiveFrom.isEmpty)
                  ? '/sell'
                  : '/dashboard');
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
      await auth.signOut().then((value) {});

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> forgotPassowrd(context, texts, email) async {
    await auth.sendPasswordResetEmail(email: email).then((value) {
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

  Future<String> getUserSubscription() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get();

    return docSnapshot.data()!['subscriptionType'];
  }

  Future<String> getUserCustomerId() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get();

    return docSnapshot.data()!['customerId'];
  }

  Future<String> getUserName() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get();

    return docSnapshot.data()!['name'];
  }

  Future<void> createStock(WidgetRef ref, String name) async {
    await firestore.collection('Stocks').doc().set({
      'name': name,
      'owner': auth.currentUser!.email,
      'sharedWith': [],
      'canEdit': [],
    });
    var colection = await firestore
        .collection('Stocks')
        .where('name', isEqualTo: name)
        .where('owner', isEqualTo: auth.currentUser!.email)
        .get();
    ref.read(currentStockProvider.notifier).state = colection.docs[0];
  }

  Future<List> getStocks(ref) async {
    var ownedStocks = await FirebaseServices()
        .firestore
        .collection('Stocks')
        .where('owner', isEqualTo: FirebaseServices().auth.currentUser!.email)
        .get();
    var sharedStocks = await FirebaseServices()
        .firestore
        .collection('Stocks')
        .where('sharedWith',
            arrayContains: FirebaseServices().auth.currentUser!.email)
        .get();
    List stocks = [];
    for (var doc in ownedStocks.docs) {
      stocks.add(doc);
    }
    for (var doc in sharedStocks.docs) {
      stocks.add(doc);
    }
    ref.read(stocksProvider.notifier).state = stocks;
    if (ref.watch(currentStockProvider) == null && stocks.isNotEmpty) {
      ref.read(currentStockProvider.notifier).state = stocks[0];
      ref.read(itemsProvider.notifier).state =
          (await stocks[0].reference.collection('Items').orderBy('name').get())
              .docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data(),
                  })
              .toList();

      ref.read(preparationsProvider.notifier).state =
          (await stocks[0].reference.collection('Preparations')
              .orderBy('name')
              .get())
              .docs
              .map((doc) => {
                    'id': doc.id, 
                    ...doc.data(), 
                  })
              .toList();
    } else {
      ref.read(itemsProvider.notifier).state = (await ref
              .watch(currentStockProvider)
              .reference
              .collection('Items')
              .orderBy('name')
              .get())
          .docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(), 
              })
          .toList();
      ref.read(preparationsProvider.notifier).state = (await ref
              .watch(currentStockProvider)
              .reference
              .collection('Preparations')
              .orderBy('name')
              .get())
          .docs
          .map((doc) => {
                'id': doc.id, 
                ...doc.data(), 
              })
          .toList();
    }

    return stocks;
  }
  
  Future<void> loadStock(ref) async{
    ref.read(itemsProvider.notifier).state = (await ref
            .watch(currentStockProvider)
            .reference
            .collection('Items')
            .orderBy('name')
            .get())
        .docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
    ref.read(preparationsProvider.notifier).state = (await ref
            .watch(currentStockProvider)
            .reference
            .collection('Preparations')
            .orderBy('name')
            .get())
        .docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

 Future<void> updateItemsStatus(ref)async{
  List<dynamic> items = ref.read(itemsProvider);
  for (var item in items){
    
  }
 }

}
