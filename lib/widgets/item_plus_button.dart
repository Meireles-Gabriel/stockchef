import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/debouncer.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/providers.dart';

class ItemPlusButton extends HookWidget {
  final bool isItem;
  final WidgetRef ref;
  final int amount;
  final Map data;

  const ItemPlusButton({
    super.key,
    required this.isItem,
    required this.ref,
    required this.amount,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final pendingUpdates = useState(0);

    void itemPlus() {
      pendingUpdates.value += 1;
      Debouncer.run(() async {
        await FirebaseFirestore.instance
            .collection('Stocks')
            .doc(ref.read(currentStockProvider).id)
            .collection(isItem ? 'Items' : 'Preparations')
            .doc(data['id'])
            .update({
          'quantity': FieldValue.increment(pendingUpdates.value * amount),
        });
        pendingUpdates.value = 0;
      });
    }

    return InkWell(
      onTap: () {
        final List<dynamic> updatedItems = [
          for (var item in isItem
              ? ref.read(itemsProvider)
              : ref.read(preparationsProvider))
            if (item['id'] == data['id'])
              {...item, 'quantity': item['quantity'] + amount}
            else
              item,
        ];
        isItem
            ? ref.read(itemsProvider.notifier).state = updatedItems
            : ref.read(preparationsProvider.notifier).state = updatedItems;

        itemPlus();
        isItem
            ? FirebaseServices().updateItemsStatus(ref)
            : FirebaseServices().updatePreparationsStatus(ref);
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
