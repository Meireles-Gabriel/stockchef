// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/add_stock_button.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/stock_selection_button.dart';
import 'package:stockchef/widgets/stock_settings_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
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
          texts['dashboard'][0],
        ),
      ),
      bottomNavigationBar: const DefaultBottomAppBar(),
      drawer: const DefaultDrawer(),
      body: HelperClass(
          mobile: DashboardMobileBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          tablet: DashboardTabletBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          desktop: DashboardDesktopBody(
            texts: texts,
            stocksFuture: stocksFuture,
          ),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}

class DashboardMobileBody extends ConsumerWidget {
  const DashboardMobileBody({
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
          FirebaseServices().updatePreparationsStatus(ref);

          // Obtenha os dados dos itens e preparações
          final items = ref.watch(itemsProvider);
          final preparations = ref.watch(preparationsProvider);

          // Calcule as estatísticas dos itens
          final int itemsBlue =
              items.where((item) => item['status'] == 'blue').length;
          final int itemsYellow =
              items.where((item) => item['status'] == 'yellow').length;
          final int itemsOrange =
              items.where((item) => item['status'] == 'orange').length;
          final int itemsRed =
              items.where((item) => item['status'] == 'red').length;

          // Calcule as estatísticas das preparações
          final int preparationsBlue =
              preparations.where((prep) => prep['status'] == 'blue').length;
          final int preparationsOrange =
              preparations.where((prep) => prep['status'] == 'orange').length;
          final int preparationsRed =
              preparations.where((prep) => prep['status'] == 'red').length;

          // Crie os dados para os gráficos de pizza
          final List<ChartData> itemData = [
            ChartData('${texts['dashboard'][6]}', itemsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][7]}', itemsYellow,
                MyColors().statusPastelYellow),
            ChartData('${texts['dashboard'][8]}', itemsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][9]}', itemsRed,
                MyColors().statusPastelRed),
          ];

          final List<ChartData> preparationData = [
            ChartData('${texts['dashboard'][10]}', preparationsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][11]}', preparationsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][12]}', preparationsRed,
                MyColors().statusPastelRed),
          ];
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      itemsBlue + itemsYellow + itemsOrange + itemsRed == 0
                          ? Column(
                              children: [
                                Text(
                                  texts['dashboard']
                                      [1], // Título do gráfico de itens
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][13],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ItemsGraphic(
                              size: size,
                              itemData: itemData,
                              texts: texts,
                            ),
                      const SizedBox(height: 50),
                      preparationsBlue + preparationsOrange + preparationsRed ==
                              0
                          ? Column(
                              children: [
                                Text(
                                  texts['dashboard']
                                      [2], // Título do gráfico de preparações
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][14],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : PreparationsGraphic(
                              preparationData: preparationData,
                              texts: texts,
                            ),
                    ],
                  ),
                ),
              ),
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

class DashboardTabletBody extends ConsumerWidget {
  const DashboardTabletBody({
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
          FirebaseServices().updatePreparationsStatus(ref);

          // Obtenha os dados dos itens e preparações
          final items = ref.watch(itemsProvider);
          final preparations = ref.watch(preparationsProvider);

          // Calcule as estatísticas dos itens
          final int itemsBlue =
              items.where((item) => item['status'] == 'blue').length;
          final int itemsYellow =
              items.where((item) => item['status'] == 'yellow').length;
          final int itemsOrange =
              items.where((item) => item['status'] == 'orange').length;
          final int itemsRed =
              items.where((item) => item['status'] == 'red').length;

          // Calcule as estatísticas das preparações
          final int preparationsBlue =
              preparations.where((prep) => prep['status'] == 'blue').length;
          final int preparationsOrange =
              preparations.where((prep) => prep['status'] == 'orange').length;
          final int preparationsRed =
              preparations.where((prep) => prep['status'] == 'red').length;

          // Crie os dados para os gráficos de pizza
          final List<ChartData> itemData = [
            ChartData('${texts['dashboard'][6]}', itemsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][7]}', itemsYellow,
                MyColors().statusPastelYellow),
            ChartData('${texts['dashboard'][8]}', itemsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][9]}', itemsRed,
                MyColors().statusPastelRed),
          ];

          final List<ChartData> preparationData = [
            ChartData('${texts['dashboard'][10]}', preparationsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][11]}', preparationsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][12]}', preparationsRed,
                MyColors().statusPastelRed),
          ];
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      itemsBlue + itemsYellow + itemsOrange + itemsRed == 0
                          ? Column(
                            
                              children: [
                                Text(
                                  texts['dashboard']
                                      [1], // Título do gráfico de itens
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][13],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ItemsGraphic(
                              size: size,
                              itemData: itemData,
                              texts: texts,
                            ),
                      const SizedBox(height: 50),
                      preparationsBlue + preparationsOrange + preparationsRed ==
                              0
                          ? Column(
                              children: [
                                Text(
                                  texts['dashboard']
                                      [2], // Título do gráfico de preparações
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][14],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : PreparationsGraphic(
                              preparationData: preparationData,
                              texts: texts,
                            ),
                    ],
                  ),
                ),
              ),
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

class DashboardDesktopBody extends ConsumerWidget {
  const DashboardDesktopBody({
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
          FirebaseServices().updatePreparationsStatus(ref);

          // Obtenha os dados dos itens e preparações
          final items = ref.watch(itemsProvider);
          final preparations = ref.watch(preparationsProvider);

          // Calcule as estatísticas dos itens
          final int itemsBlue =
              items.where((item) => item['status'] == 'blue').length;
          final int itemsYellow =
              items.where((item) => item['status'] == 'yellow').length;
          final int itemsOrange =
              items.where((item) => item['status'] == 'orange').length;
          final int itemsRed =
              items.where((item) => item['status'] == 'red').length;

          // Calcule as estatísticas das preparações
          final int preparationsBlue =
              preparations.where((prep) => prep['status'] == 'blue').length;
          final int preparationsOrange =
              preparations.where((prep) => prep['status'] == 'orange').length;
          final int preparationsRed =
              preparations.where((prep) => prep['status'] == 'red').length;

          // Crie os dados para os gráficos de pizza
          final List<ChartData> itemData = [
            ChartData('${texts['dashboard'][6]}', itemsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][7]}', itemsYellow,
                MyColors().statusPastelYellow),
            ChartData('${texts['dashboard'][8]}', itemsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][9]}', itemsRed,
                MyColors().statusPastelRed),
          ];

          final List<ChartData> preparationData = [
            ChartData('${texts['dashboard'][10]}', preparationsBlue,
                MyColors().statusPastelBlue),
            ChartData('${texts['dashboard'][11]}', preparationsOrange,
                MyColors().statusPastelOrange),
            ChartData('${texts['dashboard'][12]}', preparationsRed,
                MyColors().statusPastelRed),
          ];
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      itemsBlue + itemsYellow + itemsOrange + itemsRed == 0
                          ? Column(
                              children: [
                                Text(
                                  texts['dashboard']
                                      [1], // Título do gráfico de itens
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][13],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ItemsGraphic(
                              size: size,
                              itemData: itemData,
                              texts: texts,
                            ),
                      const SizedBox(height: 50),
                      preparationsBlue + preparationsOrange + preparationsRed ==
                              0
                          ? Column(
                              children: [
                                Text(
                                  texts['dashboard']
                                      [2], // Título do gráfico de preparações
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  texts['dashboard'][14],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : PreparationsGraphic(
                              preparationData: preparationData,
                              texts: texts,
                            ),
                    ],
                  ),
                ),
              ),
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

class PreparationsGraphic extends StatelessWidget {
  const PreparationsGraphic({
    super.key,
    required this.preparationData,
    required this.texts,
  });

  final List<ChartData> preparationData;
  final dynamic texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texts['dashboard'][2], // Título do gráfico de preparações
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: 500,
          child: SfCircularChart(
            legend: Legend(
              height: '80%',
              width: '100%',
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.visible,
              ),
            ),
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: preparationData,
                xValueMapper: (ChartData data, _) => data.label,
                yValueMapper: (ChartData data, _) => data.value,
                pointColorMapper: (ChartData data, _) => data.color,
                dataLabelSettings: const DataLabelSettings(
                  showZeroValue: false,
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ItemsGraphic extends StatelessWidget {
  const ItemsGraphic({
    super.key,
    required this.size,
    required this.itemData,
    required this.texts,
  });

  final Size size;
  final List<ChartData> itemData;
  final dynamic texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texts['dashboard'][1], // Título do gráfico de itens
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: 600,
          child: SfCircularChart(
            legend: Legend(
              height: '80%',
              width: '100%',
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.visible,
              ),
            ),
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: itemData,
                xValueMapper: (ChartData data, _) => data.label,
                yValueMapper: (ChartData data, _) => data.value,
                pointColorMapper: (ChartData data, _) => data.color,
                dataLabelSettings: const DataLabelSettings(
                  showZeroValue: false,
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
