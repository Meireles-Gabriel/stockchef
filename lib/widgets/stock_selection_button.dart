import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/providers.dart';

class StockSelectionButton extends ConsumerWidget {
  const StockSelectionButton({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.secondary,
      tooltip: '',
      icon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2, // Largura da borda
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        height: 50,
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                ref.watch(currentStockProvider) != null
                    ? ref.watch(currentStockProvider)['name']
                    : texts['items'][6],
              ),
              if (ref.watch(currentStockProvider) == null)
                const Icon(Icons.arrow_right, size: 34,),
            ],
          ),
        ),
      ),
      itemBuilder: (context) {
        return ref.watch(stocksProvider).map((doc) {
          return PopupMenuItem(
            value: doc,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: 250,
              child: Center(
                child: Text(
                  doc['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList();
      },
      onSelected: (value) {
        FirebaseServices().setStock(ref, value);
      },
    );
  }
}
