import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';

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
      itens.add({
        'name': item['name'],
        'quantity': item['quantity'],
        'minQuantity': item['minQuantity'],
        'unit': item['unit'],
        'status': item['status'],
        'buy': item['status'] == 'blue' || item['status'] == 'yellow'
            ? 0
            : item['status'] == 'orange'
                ? item['minQuantity'] - item['quantity']
                : item['minQuantity'],
      });
    }
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
            DefaultButton(text: texts['shop'][1], action: () {})
          ],
        ),
      ),
      body: HelperClass(
          mobile: const ShopBody(),
          tablet: const Placeholder(),
          desktop: const Placeholder(),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}

class ShopBody extends ConsumerWidget {
  const ShopBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}
