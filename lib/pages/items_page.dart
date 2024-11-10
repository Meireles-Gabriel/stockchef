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
      body: FutureBuilder(
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
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasData) {
      return HelperClass(
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            // Verifica se o itemsProvider é um Future
            FutureBuilder(
              future: ref.watch(itemsProvider) as Future<dynamic>,
              builder: (context, AsyncSnapshot itemsSnapshot) {
                if (itemsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (itemsSnapshot.hasError) {
                  return Text('Erro ao carregar itens: ${itemsSnapshot.error}');
                } else if (itemsSnapshot.hasData) {
                  final itemsData = itemsSnapshot.data as QuerySnapshot<Map<String, dynamic>>;
                  if (itemsData.docs.isEmpty) {
                    return Text(texts['items'][7]);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemsData.docs.length,
                    itemBuilder: (context, index) {
                      final data = itemsData.docs[index].data();
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['quantity'].toString()),
                      );
                    },
                  );
                } else {
                  return const Text('Nenhum dado disponível');
                }
              },
            ),
            ref.watch(currentStockProvider) != null
                ? DefaultButton(
                    text: texts['items'][8],
                    action: () {
                      Navigator.pushNamed(context, '/create_item');
                    })
                : const SizedBox(),
          ],
        ),
        tablet: const Placeholder(),
        desktop: const Placeholder(),
        paddingWidth: size.width * .1,
        bgColor: Theme.of(context).colorScheme.surface,
      );
    } else {
      if (kDebugMode) {
        print('No data');
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  },
)
    );
  }
}
