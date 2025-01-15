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
import 'package:stockchef/widgets/show_snack_bar.dart';
import 'package:stockchef/widgets/stock_selection_button.dart';
import 'package:stockchef/widgets/stock_settings_button.dart';

class PreparationsPage extends ConsumerStatefulWidget {
  const PreparationsPage({super.key});

  @override
  ConsumerState<PreparationsPage> createState() => _PreparationsPageState();
}

class _PreparationsPageState extends ConsumerState<PreparationsPage> {
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
          texts['dashboard'][2],
        ),
      ),
      bottomNavigationBar: const DefaultBottomAppBar(),
      drawer: const DefaultDrawer(),
      body: HelperClass(
          mobile: PreparationsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          tablet: PreparationsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          desktop: PreparationsPageBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}

class PreparationsPageBody extends ConsumerWidget {
  const PreparationsPageBody({
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
          FirebaseServices().updatePreparationsStatus(ref);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StockSettingsButton(ref: ref, texts: texts),
                  StockSelectionButton(texts: texts),
                  AddStockButton(
                    texts: texts,
                  ),
                ],
              ),
              ref.watch(preparationsProvider).isEmpty
                  ? Text(texts['preparations'][7])
                  : SizedBox(
                      height: size.height * .6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ref.watch(preparationsProvider).length,
                        itemBuilder: (context, index) {
                          final data = ref.watch(preparationsProvider)[index];
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
                      text: texts['preparations'][8],
                      action: () {
                        ref.read(itemsProvider).isEmpty
                            ? showSnackBar(context, texts['preparations'][9])
                            : Navigator.pushNamed(
                                context, '/create_preparation');
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
