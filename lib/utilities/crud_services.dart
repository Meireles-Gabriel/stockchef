import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/providers.dart';

class CRUDServices {
  Future<void> setStock(WidgetRef ref, doc) async {
    ref.read(currentStockProvider.notifier).state = doc;
    ref.read(itemsProvider.notifier).state =
        doc.reference.colection('Items').get();
    ref.read(preparationsProvider.notifier).state =
        doc.reference.colection('Preparations').get();
  }

}
