// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

final isLoadingForgotPasswordProvider = StateProvider<bool>(
  (ref) => false,
);
void forgotPasswordDialog(BuildContext context, Map texts) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      TextEditingController email = TextEditingController();
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              texts['login'][16],
            ),
            content: TextField(
              enabled: !ref.watch(isLoadingForgotPasswordProvider),
              controller: email,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            actions: ref.watch(isLoadingForgotPasswordProvider)
                ? [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ]
                : <Widget>[
                    TextButton(
                      child: Text(texts['login'][17]),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    DefaultButton(
                      text: texts['login'][18],
                      action: () async {
                        ref.read(isLoadingForgotPasswordProvider.notifier).state = true;
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('Users')
                            .where('email', isEqualTo: email.text)
                            .limit(1)
                            .get();
                        if (querySnapshot.docs.isNotEmpty) {
                          FirebaseServices()
                              .forgotPassowrd(context, texts, email.text)
                              .then((value) {
                            ref.read(isLoadingForgotPasswordProvider.notifier).state = false;
                          }).then((value) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          ref.read(isLoadingForgotPasswordProvider.notifier).state = false;
                          showSnackBar(context, texts['login'][19])
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
                  ],
          );
        },
      );
    },
  );
}
