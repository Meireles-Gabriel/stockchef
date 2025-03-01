// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class AddStockButton extends ConsumerWidget {
  const AddStockButton({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      width: 50,
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
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          ref.read(isLoadingItemsProvider.notifier).state = true;
          final userData = await FirebaseServices()
              .firestore
              .collection('Users')
              .doc(FirebaseServices().auth.currentUser!.uid)
              .get();
          final databasesData = await FirebaseServices()
              .firestore
              .collection('Stocks')
              .where('owner',
                  isEqualTo: FirebaseServices().auth.currentUser!.email)
              .get();

          if ((userData.data()!['subscriptionType'] == 'trial' ||
                  userData.data()!['subscriptionType'] == 'solo') &&
              databasesData.docs.isNotEmpty) {
            ref.read(isLoadingItemsProvider.notifier).state = false;
            showSnackBar(context, texts['items'][0]);
          } else {
            ref.read(isLoadingItemsProvider.notifier).state = false;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController nameController =
                      TextEditingController();
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text(texts['items'][1]),
                    content: TextField(
                      controller: nameController,
                      onSubmitted: (value) async {
                        for (var doc in databasesData.docs) {
                          if (doc['name'] == nameController.text) {
                            ref.read(isLoadingItemsProvider.notifier).state =
                                false;
                            showSnackBar(context, texts['items'][4])
                                .then((value) async {
                              await FirebaseServices().getStocks(ref);
                              Navigator.of(context).pop();
                            });
                          }
                        }
                        if (nameController.text != '') {
                          await FirebaseServices()
                              .createStock(ref, nameController.text)
                              .then((value) async {
                            await FirebaseServices().loadStock(ref);
                            Navigator.of(context).pop();
                          });
                          ref.read(isLoadingItemsProvider.notifier).state =
                              false;
                        } else {
                          ref.read(isLoadingItemsProvider.notifier).state =
                              false;
                          showSnackBar(context, texts['items'][5])
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: texts['items'][2],
                      ),
                    ),
                    actions: ref.watch(isLoadingItemsProvider)
                        ? [
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ]
                        : [
                            TextButton(
                              child: Text(texts['login'][17]),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            DefaultButton(
                              text: texts['items'][3],
                              action: () async {
                                for (var doc in databasesData.docs) {
                                  if (doc['name'] == nameController.text) {
                                    ref
                                        .read(isLoadingItemsProvider.notifier)
                                        .state = false;
                                    showSnackBar(context, texts['items'][4])
                                        .then((value) async {
                                      await FirebaseServices().getStocks(ref);
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                                if (nameController.text != '') {
                                  await FirebaseServices()
                                      .createStock(ref, nameController.text)
                                      .then((value) async {
                                    await FirebaseServices().loadStock(ref);
                                    Navigator.of(context).pop();
                                  });
                                  ref
                                      .read(isLoadingItemsProvider.notifier)
                                      .state = false;
                                } else {
                                  ref
                                      .read(isLoadingItemsProvider.notifier)
                                      .state = false;
                                  showSnackBar(context, texts['items'][5])
                                      .then((value) {
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                            ),
                          ],
                  );
                });
          }
        },
      ),
    );
  }
}
