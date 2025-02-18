import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/shop_item_tile.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  List itens = [];

  @override
  void initState() {
    super.initState();
    for (var item in ref.read(itemsProvider)) {
      itens.add(
        {
          'id': item['id'],
          'name': item['name'],
          'quantity': item['quantity'],
          'minQuantity': item['minQuantity'],
          'unit': item['unit'],
          'status': item['status'],
          'expireDate': item['expireDate'],
          'buy': item['status'] == 'blue' || item['status'] == 'yellow'
              ? 0
              : item['status'] == 'orange'
                  ? item['minQuantity'] - item['quantity']
                  : item['minQuantity'],
        },
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopItemsProvider.notifier).state = itens;
    });
  }

  Future<void> generatePdf(List items) async {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                '${texts['shop'][5]}${ref.read(currentStockProvider)['name']}',
                style: const pw.TextStyle(fontSize: 24),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                texts['shop'][5] == 'Compras'
                    ? '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
                    : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: [texts['shop'][7], texts['shop'][6], texts['shop'][4]],
                data: items.map((item) {
                  return [item['name'], item['unit'], item['buy'].toString()];
                }).toList(),
                cellAlignment: pw.Alignment.center,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: '${texts['shop'][5]}${ref.read(currentStockProvider)['name']}',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(texts['shop'][0]),
            DefaultButton(
              text: texts['shop'][1],
              action: () {
                List itemsToBuy = ref
                    .read(shopItemsProvider)
                    .where((item) => item['buy'] > 0)
                    .toList();
                generatePdf(itemsToBuy);
              },
            ),
          ],
        ),
      ),
      body: HelperClass(
        mobile: itens.isEmpty
            ? const CircularProgressIndicator()
            : ShopBody(itens: itens),
        tablet: itens.isEmpty
            ? const CircularProgressIndicator()
            : ShopBody(itens: itens),
        desktop: itens.isEmpty
            ? const CircularProgressIndicator()
            : ShopBody(itens: itens),
        paddingWidth: size.width * .1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class ShopBody extends ConsumerWidget {
  final List itens;
  const ShopBody({
    super.key,
    required this.itens,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        itemCount: ref.watch(shopItemsProvider).length,
        itemBuilder: (context, index) {
          // build your item here
          return Column(
            children: [
              const SizedBox(height: 10),
              ShopItemTile(
                data: ref.watch(shopItemsProvider)[index],
                index: index,
              ),
            ],
          );
        });
  }
}
