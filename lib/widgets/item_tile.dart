// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/item_minus_button.dart';
import 'package:stockchef/widgets/item_plus_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class ItemTile extends ConsumerWidget {
  const ItemTile({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isItem = !data.containsKey('ingredients');
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    List<dynamic> preparations = ref.read(preparationsProvider);
    return InkWell(
      onTap: () {
        String message = '';
        if (isItem) {
          if (data['status'] == 'blue') {
            message = texts['item_description'][0];
          } else if (data['status'] == 'yellow') {
            message = texts['item_description'][1];
          } else if (data['status'] == 'orange') {
            for (var preparation in preparations) {
              if (preparation['ingredients'].contains(data['id']) &&
                  preparation['quantity'] < preparation['minQuantity'] &&
                  data['quantity'] < data['minQuantity']) {
                message = texts['item_description'][2];
              }
            }
            if (data['expireDate'] != 'not defined' &&
                DateTime.parse(data['expireDate'])
                    .subtract(const Duration(days: 5))
                    .isBefore(DateTime.now())) {
              message += message == ''
                  ? texts['item_description'][3]
                  : '\n${texts['item_description'][3]}';
            }
          } else {
            if (data['quantity'] <= 0) {
              message += message == ''
                  ? texts['item_description'][4]
                  : '\n${texts['item_description'][4]}';
            } else if (data['expireDate'] != 'not defined' &&
                DateTime.parse(data['expireDate']).isBefore(DateTime.now())) {
              message += message == ''
                  ? texts['item_description'][5]
                  : '\n${texts['item_description'][5]}';
            }
          }
        } else {
          if (data['status'] == 'blue') {
            message = texts['preparation_description'][0];
          } else if (data['status'] == 'orange') {
            if (data['quantity'] <= data['minQuantity']) {
              message += message == ''
                  ? texts['preparation_description'][1]
                  : '\n${texts['preparation_description'][1]}';
            } else if (data['expireDate'] != 'not defined' &&
                DateTime.parse(data['expireDate'])
                    .subtract(const Duration(days: 5))
                    .isBefore(DateTime.now())) {
              message += message == ''
                  ? texts['preparation_description'][2]
                  : '\n${texts['preparation_description'][2]}';
            }
          } else {
            if (data['quantity'] <= 0) {
              message += message == ''
                  ? texts['preparation_description'][3]
                  : '\n${texts['preparation_description'][3]}';
            } else if (data['expireDate'] != 'not defined' &&
                DateTime.parse(data['expireDate']).isBefore(DateTime.now())) {
              message += message == ''
                  ? texts['preparation_description'][4]
                  : '\n${texts['preparation_description'][4]}';
            }
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
                        data['expireDate'] == 'not defined'
                            ? Row(
                                children: [
                                  Text(ref.watch(languageNotifierProvider)[
                                              'language'] ==
                                          'en'
                                      ? 'Expire:  '
                                      : 'Vencimento:  '),
                                  const Icon(
                                    Icons.all_inclusive,
                                    size: 20,
                                  )
                                ],
                              )
                            : Text(
                                ref.watch(languageNotifierProvider)[
                                            'language'] ==
                                        'en'
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
                        ItemMinusButton(
                          isItem: isItem,
                          ref: ref,
                          amount: data['quantity'] <= 0
                              ? 0
                              : data['unit'] == 'g' || data['unit'] == 'mL'
                                  ? 10
                                  : 1,
                          data: data,
                        ),
                        ItemPlusButton(
                          isItem: isItem,
                          ref: ref,
                          amount: data['unit'] == 'g' || data['unit'] == 'mL'
                              ? 10
                              : 1,
                          data: data,
                        ),
                        InkWell(
                          onTap: () {
                            ref.read(unitItemProvider.notifier).state =
                                data['unit'];
                            if (data['expireDate'] == 'not defined') {
                              ref
                                  .read(definedExpirationProvider.notifier)
                                  .state = false;
                            } else {
                              ref
                                  .read(definedExpirationProvider.notifier)
                                  .state = true;
                            }
                            if (!isItem) {
                              ref
                                  .read(selectedIngredientsProvider.notifier)
                                  .state = data['ingredients'];
                            }

                            Navigator.pushNamed(context,
                                isItem ? '/edit_item' : '/edit_preparation',
                                arguments: data);
                          },
                          child: const Icon(
                            Icons.edit,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isItem) {
                              final preparations =
                                  ref.read(preparationsProvider);
                              for (var preparation in preparations) {
                                if (preparation['ingredients']
                                    .contains(data['id'])) {
                                  showSnackBar(
                                      context,
                                      texts['delete'][4] +
                                          ' ${preparation['name']}');
                                  return;
                                }
                              }
                            }
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  title: Text(texts['delete'][0]),
                                  content: Text(
                                      texts['delete'][2] + data['name'] + '?'),
                                  actions: ref.watch(
                                          isLoadingForgotPasswordProvider)
                                      ? [
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ]
                                      : <Widget>[
                                          TextButton(
                                            child: Text(texts['login'][17]),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          DefaultButton(
                                            text: texts['delete'][3],
                                            action: () async {
                                              ref
                                                  .read(
                                                      isLoadingForgotPasswordProvider
                                                          .notifier)
                                                  .state = true;

                                              await FirebaseServices()
                                                  .firestore
                                                  .collection('Stocks')
                                                  .doc(ref
                                                      .read(
                                                          currentStockProvider)
                                                      .id)
                                                  .collection(isItem
                                                      ? 'Items'
                                                      : 'Preparations')
                                                  .doc(data['id'])
                                                  .delete()
                                                  .then((value) {
                                                ref
                                                    .read(
                                                        isLoadingForgotPasswordProvider
                                                            .notifier)
                                                    .state = false;
                                                Navigator.pushNamed(
                                                    context,
                                                    isItem
                                                        ? '/items'
                                                        : '/preparations');
                                              });
                                            },
                                          ),
                                        ],
                                );
                              },
                            );
                          },
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
      ),
    );
  }
}
