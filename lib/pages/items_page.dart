// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/add_stock_button.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/stock_selection_button.dart';

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          texts['dashboard'][1],
        ),
      ),
      bottomNavigationBar: const DefaultBottomAppBar(),
      drawer: const DefaultDrawer(),
      body: HelperClass(
          mobile: FutureBuilder(
            future: FirebaseServices().getStocks(ref),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Error getting Data$snapshot');
                }
                return const Center(
                  child: Text('Erro ao carregar dados iniciais.'),
                );
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StockSelectionButton(texts: texts),
                            AddStockButton(
                              texts: texts,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ref.watch(currentStockProvider) == null
                            ? Text(texts['items'][7])
                            : FutureBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('Stocks')
                                    .doc(ref.read(currentStockProvider).id)
                                    .collection('Items')
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot itemsSnapshot) {
                                  if (itemsSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (itemsSnapshot.hasError) {
                                    return Center(
                                      child: Text(
                                          'Erro ao carregar itens: ${itemsSnapshot.error}'),
                                    );
                                  } else if (itemsSnapshot.hasData) {
                                    final itemsData = itemsSnapshot.data!;
                                    if (itemsData.docs.isEmpty) {
                                      return Center(
                                        child: Text(texts['items'][7]),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: itemsData.docs.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            itemsData.docs[index].data();
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(2, 4),
                                                  ),
                                                ],
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data['name'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      Text(
                                                        '${data['quantity']} ${data['unit']}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Expire: ${data['expireDate']}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      Text(
                                                        'Min: ${data['minQuantity']}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(
                                          'Nenhum dado disponível no momento.'),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                    ref.watch(currentStockProvider) != null
                        ? DefaultButton(
                            text: texts['items'][8],
                            action: () {
                              Navigator.pushNamed(context, '/create_item');
                            })
                        : const SizedBox(),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Nenhum dado disponível no momento.'),
                );
              }
            },
          ),
          tablet: const Placeholder(),
          desktop: const Placeholder(),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}
