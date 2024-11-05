// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class AddStockButton extends StatelessWidget {
  const AddStockButton({
    super.key,
    required this.texts,
    required this.ref,
  });

  final Map texts;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        ref.read(isLoadingItensProvider.notifier).state = true;
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
          ref.read(isLoadingItensProvider.notifier).state = false;
          showSnackBar(context, texts['itens'][0]);
        } else {
          ref.read(isLoadingItensProvider.notifier).state = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController nameController =
                    TextEditingController();
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(texts['itens'][1]),
                  content: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: texts['itens'][2],
                    ),
                  ),
                  actions: ref.watch(isLoadingItensProvider)
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
                            text: texts['itens'][3],
                            action: () async {
                              for (var doc in databasesData.docs) {
                                if (doc['name'] == nameController.text) {
                                  ref
                                      .read(isLoadingItensProvider.notifier)
                                      .state = false;
                                  showSnackBar(context, texts['itens'][4])
                                      .then((value) async {
                                    await FirebaseServices().getStocks(ref);
                                    Navigator.of(context).pop();
                                  });
                                }
                              }
                              if (nameController.text != '') {
                                await FirebaseServices()
                                    .createStock(nameController.text)
                                    .then((value) {
                                  Navigator.of(context).pop();
                                });
                                ref
                                    .read(isLoadingItensProvider.notifier)
                                    .state = false;
                              } else {
                                ref
                                    .read(isLoadingItensProvider.notifier)
                                    .state = false;
                                showSnackBar(context, texts['itens'][5])
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
    );
  }
}
