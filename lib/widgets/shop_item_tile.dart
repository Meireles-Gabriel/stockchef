// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class ShopItemTile extends ConsumerStatefulWidget {
  const ShopItemTile({
    super.key,
    required this.data,
    required this.index,
  });

  final dynamic data;
  final int index;

  @override
  ConsumerState<ShopItemTile> createState() => _ShopItemTileState();
}

class _ShopItemTileState extends ConsumerState<ShopItemTile> {
  @override
  Widget build(BuildContext context) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    List<dynamic> preparations = ref.read(preparationsProvider);
    return InkWell(
      onTap: () {
        String message = '';
        if (widget.data['status'] == 'blue') {
          message = texts['item_description'][0];
        } else if (widget.data['status'] == 'yellow') {
          message = texts['item_description'][1];
        } else if (widget.data['status'] == 'orange') {
          for (var preparation in preparations) {
            if (preparation['ingredients'].contains(widget.data['id']) &&
                preparation['quantity'] < preparation['minQuantity'] &&
                widget.data['quantity'] < widget.data['minQuantity']) {
              message = texts['item_description'][2];
            }
          }
          if (widget.data['expireDate'] != 'not defined' &&
              DateTime.parse(widget.data['expireDate'])
                  .subtract(const Duration(days: 5))
                  .isBefore(DateTime.now())) {
            message += message == ''
                ? texts['item_description'][3]
                : '\n${texts['item_description'][3]}';
          }
        } else {
          if (widget.data['quantity'] <= 0) {
            message += message == ''
                ? texts['item_description'][4]
                : '\n${texts['item_description'][4]}';
          } else if (widget.data['expireDate'] != 'not defined' &&
              DateTime.parse(widget.data['expireDate'])
                  .isBefore(DateTime.now())) {
            message += message == ''
                ? texts['item_description'][5]
                : '\n${texts['item_description'][5]}';
          }
        }
        showSnackBar(context, message);
      },
      child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.data['name'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(texts['shop'][2]),
                                Text(
                                  '${widget.data['quantity']}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 62,
                              child: VerticalDivider(),
                            ),
                            Column(
                              children: [
                                Text(texts['shop'][3]),
                                Text(
                                  '${widget.data['minQuantity']}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 62,
                              child: VerticalDivider(),
                            ),
                            Column(
                              children: [
                                Text(
                                  texts['shop'][4],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${widget.data['buy']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${ref.watch(languageNotifierProvider)['language'] == 'en' ? widget.data['unit'] : widget.data['unit'] == 'Unit' ? 'Unidade(s)' : widget.data['unit'] == 'Package' ? 'Pacote(s)' : widget.data['unit'] == 'Box' ? 'Caixa(s)' : widget.data['unit']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: widget.data['buy'] <= 0
                              ? () {}
                              : () {
                                  List items =
                                      List.from(ref.read(shopItemsProvider));
                                  int buy = items[widget.index]['buy'];
                                  int amount = widget.data['unit'] == 'g' ||
                                          widget.data['unit'] == 'mL'
                                      ? 10
                                      : 1;
                                  items[widget.index] = {
                                    ...items[widget.index],
                                    'buy': buy - amount
                                  };
                                  ref.read(shopItemsProvider.notifier).state =
                                      items;
                                },
                          child: const Icon(
                            Icons.remove,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            List items = List.from(ref.read(shopItemsProvider));
                            int buy = items[widget.index]['buy'];
                            int amount = widget.data['unit'] == 'g' ||
                                    widget.data['unit'] == 'mL'
                                ? 10
                                : 1;
                            items[widget.index] = {
                              ...items[widget.index],
                              'buy': buy + amount
                            };
                            ref.read(shopItemsProvider.notifier).state = items;
                          },
                          child: const Icon(
                            Icons.add,
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
                  color: widget.data['status'] == 'red'
                      ? MyColors().statusPastelRed
                      : widget.data['status'] == 'orange'
                          ? MyColors().statusPastelOrange
                          : widget.data['status'] == 'yellow'
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
      ),
    );
  }
}
