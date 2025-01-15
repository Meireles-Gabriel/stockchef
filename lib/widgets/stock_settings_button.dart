// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class StockSettingsButton extends StatelessWidget {
  const StockSettingsButton({
    super.key,
    required this.texts,
    required this.ref,
  });

  final Map texts;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      enabled: ref.watch(currentStockProvider) != null &&
          ref.watch(currentStockProvider)['owner'] ==
              FirebaseServices().auth.currentUser!.email,
      color: Theme.of(context).colorScheme.secondary,
      tooltip: '',
      icon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2, // Largura da borda
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        height: 50,
        width: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Center(
          child: Icon(Icons.more_vert),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts['stock_settings'][0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.share),
              ],
            )),
        PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts['stock_settings'][1],
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.delete),
              ],
            )),
      ],
      onSelected: (value) async {
        if (value == 0) {
          final userInfo = await FirebaseServices()
              .firestore
              .collection('Users')
              .doc(FirebaseServices().auth.currentUser!.uid)
              .get();
          final currentStock = await FirebaseServices()
              .firestore
              .collection('Stocks')
              .doc(ref.watch(currentStockProvider).id)
              .get();

          if (userInfo['subscriptionType'] != 'team') {
            showSnackBar(context, texts['stock_settings'][10]);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                List shareWith = userInfo['shareWith'];
                List sharedWith = currentStock['sharedWith'];
                TextEditingController emailController = TextEditingController();
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text(texts['stock_settings'][6]),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(texts['stock_settings'][7]),
                        const SizedBox(height: 20),
                        if (shareWith.isNotEmpty)
                          ...shareWith.map(
                            (email) => Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (sharedWith.contains(email)) {
                                            setState(() {
                                              sharedWith.remove(email);
                                            });
                                          } else {
                                            setState(() {
                                              sharedWith.add(email);
                                            });
                                          }
                                        });
                                        FirebaseServices()
                                            .firestore
                                            .collection('Stocks')
                                            .doc(ref
                                                .watch(currentStockProvider)
                                                .id)
                                            .update({'sharedWith': sharedWith});
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            sharedWith.contains(email)
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              email,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          shareWith.remove(email);
                                          sharedWith.remove(email);
                                          emailController.clear();
                                        });
                                        await FirebaseServices()
                                            .firestore
                                            .collection('Users')
                                            .doc(FirebaseServices()
                                                .auth
                                                .currentUser!
                                                .uid)
                                            .update({'shareWith': shareWith});
                                        final collectionRef = FirebaseServices()
                                            .firestore
                                            .collection('Stocks');
                                        final querySnapshot =
                                            await collectionRef
                                                .where('sharedWith',
                                                    arrayContains: email)
                                                .get();

                                        for (final doc in querySnapshot.docs) {
                                          final data = doc.data();
                                          final List<dynamic> emailList =
                                              data['sharedWith'] ?? [];

                                          emailList.remove(email);

                                          await doc.reference
                                              .update({'sharedWith': emailList});
                                        }
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 220,
                              child: TextField(
                                enabled: shareWith.length < 2,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                              ),
                              onPressed: shareWith.length >= 2
                                  ? null
                                  : () async {
                                      if (emailController.text.isNotEmpty) {
                                        if (shareWith
                                            .contains(emailController.text)) {
                                          showSnackBar(context,
                                              texts['stock_settings'][8]);
                                        } else {
                                          setState(() {
                                            shareWith.add(emailController.text);
                                            sharedWith
                                                .add(emailController.text);
                                            emailController.clear();
                                          });
                                          await FirebaseServices()
                                              .firestore
                                              .collection('Users')
                                              .doc(FirebaseServices()
                                                  .auth
                                                  .currentUser!
                                                  .uid)
                                              .update({'shareWith': shareWith});
                                          await FirebaseServices()
                                              .firestore
                                              .collection('Stocks')
                                              .doc(ref
                                                  .watch(currentStockProvider)
                                                  .id)
                                              .update(
                                                  {'sharedWith': sharedWith});
                                        }
                                      }
                                    },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          }
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(texts['stock_settings'][2]),
                  content: Text(texts['stock_settings'][3]),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(texts['stock_settings'][4]),
                    ),
                    DefaultButton(
                      action: () async {
                        await FirebaseServices().deleteStock(
                            ref, ref.watch(currentStockProvider).id);
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, ModalRoute.of(context)!.settings.name!);
                        Navigator.pop(context);
                      },
                      text: texts['stock_settings'][5],
                    ),
                  ],
                );
              });
        }
      },
    );
  }
}
