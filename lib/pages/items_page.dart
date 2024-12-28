// ignore_for_file: use_build_context_synchronously

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
import 'package:stockchef/widgets/item_tile.dart';
import 'package:stockchef/widgets/stock_selection_button.dart';

class ItemsPage extends ConsumerStatefulWidget {
  const ItemsPage({super.key});

  @override
  ConsumerState<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends ConsumerState<ItemsPage> {
  late Future<List<dynamic>> stocksFuture;

  @override
  void initState() {
    super.initState();
    stocksFuture = FirebaseServices().getStocks(ref);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          texts['dashboard'][1],
        ),
      ),
      bottomNavigationBar: const DefaultBottomAppBar(),
      drawer: const DefaultDrawer(),
      body: HelperClass(
          mobile: ItemsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          tablet: ItemsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          desktop: ItemsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}

class ItemsPageBody extends ConsumerWidget {
  const ItemsPageBody({
    super.key,
    required this.texts,
    required this.stocksFuture,
  });

  final Map texts;
  final Future stocksFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return FutureBuilder(
      future: stocksFuture,
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
            child: Text('Error getting Data.'),
          );
        } else if (snapshot.hasData) {
          FirebaseServices().updateItemsStatus(ref);
          return Column(
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
              ref.watch(itemsProvider).isEmpty
                  ? Text(texts['items'][7])
                  : SizedBox(
                      height: size.height * .6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ref.watch(itemsProvider).length,
                        itemBuilder: (context, index) {
                          final data = ref.watch(itemsProvider)[index];
                          return Column(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return ItemTile(
                                    data: data,
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                            ],
                          );
                        },
                      ),
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
    );
  }
}
