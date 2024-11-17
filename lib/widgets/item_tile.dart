import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/language_notifier.dart';

class ItemTile extends ConsumerWidget {
  const ItemTile({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
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
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: IntrinsicHeight(
        // Define altura automática do Container
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          data['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${data['quantity']} ${ref.watch(languageNotifierProvider)['language'] == 'en' ? data['unit'] : data['unit'] == 'Unit' ? 'Unidade(s)' : data['unit'] == 'Package' ? 'Pacote(s)' : data['unit'] == 'Box' ? 'Caixa(s)' : data['unit']}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ref.watch(languageNotifierProvider)['language'] == 'en'
                            ? 'Expire: ${data['expireDate'].substring(5, 7)}-${data['expireDate'].substring(8, 10)}-${data['expireDate'].substring(0, 4)}'
                            : 'Vencimento: ${data['expireDate'].substring(8, 10)}/${data['expireDate'].substring(5, 7)}/${data['expireDate'].substring(0, 4)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Min: ${data['minQuantity']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.add,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.remove,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.edit,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 20,
              decoration: BoxDecoration(
                color: data['status'] == 'red'
                    ? MyColors().statusPastelRed
                    : data['status'] == 'orange'
                        ? MyColors().statusPastelOrange
                        : data['status'] == 'yellow'
                            ? MyColors().statusPastelYellow
                            : MyColors().statusPastelBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    20,
                  ),
                  bottomRight: Radius.circular(
                    20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
