import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/debouncer.dart';
import 'package:stockchef/utilities/providers.dart';

class ItemMinusButton extends HookWidget {
  final WidgetRef ref;
  final int amount;
  final Map data;

  const ItemMinusButton({
    super.key,
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
            .collection('Items')
            .doc(data['id'])
            .update({
          'quantity': FieldValue.increment(pendingUpdates.value * amount * -1),
        });
        pendingUpdates.value = 0;
      });
    }

    return InkWell(
      onTap: () {
        final List<dynamic> updatedItems = [
          for (var item in ref.read(itemsProvider))
            if (item['id'] == data['id'])
              {...item, 'quantity': item['quantity'] - amount}
            else
              item,
        ];
        ref.read(itemsProvider.notifier).state = updatedItems;

        itemPlus();
      },
      child: const Icon(
        Icons.remove,
      ),
    );
  }
}
