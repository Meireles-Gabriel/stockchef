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
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/item_tile.dart';
import 'package:stockchef/widgets/stock_selection_button.dart';
import 'package:stockchef/widgets/stock_settings_button.dart';

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
                  StockSettingsButton(ref: ref, texts: texts),
                  StockSelectionButton(texts: texts),
                  AddStockButton(texts: texts),
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: ref.read(itemsProvider).isEmpty
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/shop');
                                },
                          style: ref.read(itemsProvider).isEmpty
                              ? const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.grey),
                                )
                              : ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_grocery_store,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                texts['shop'][0],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/create_item');
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.primary),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                texts['items'][8],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
