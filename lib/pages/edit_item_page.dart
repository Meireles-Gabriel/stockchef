// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/date_text_formatter.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class EditItemPage extends ConsumerStatefulWidget {
  const EditItemPage({super.key});

  @override
  ConsumerState<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends ConsumerState<EditItemPage> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController minQuantityController;
  late TextEditingController expirationDateController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    quantityController = TextEditingController();
    minQuantityController = TextEditingController();
    expirationDateController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    minQuantityController.dispose();
    expirationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = data['name'];
    quantityController.text = data['quantity'].toString();
    minQuantityController.text = data['minQuantity'].toString();
    expirationDateController.text = ref
                .read(languageNotifierProvider)['language'] ==
            'pt'
        ? '${data['expireDate'].substring(8, 10)}/${data['expireDate'].substring(5, 7)}/${data['expireDate'].substring(0, 4)}'
        : '${data['expireDate'].substring(5, 7)}-${data['expireDate'].substring(8, 10)}-${data['expireDate'].substring(0, 4)}';
    if (data['expireDate'] == 'not defined') {
      expirationDateController.text = '';
    }
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts['edit_item'][0],
        ),
      ),
      drawer: const DefaultDrawer(),
      bottomNavigationBar: const DefaultBottomAppBar(),
      body: HelperClass(
        mobile: EditItemBody(
          ref: ref,
          data: data,
          nameController: nameController,
          quantityController: quantityController,
          minQuantityController: minQuantityController,
          expirationDateController: expirationDateController,
        ),
        tablet: EditItemBody(
          ref: ref,
          data: data,
          nameController: nameController,
          quantityController: quantityController,
          minQuantityController: minQuantityController,
          expirationDateController: expirationDateController,
        ),
        desktop: EditItemBody(
          ref: ref,
          data: data,
          nameController: nameController,
          quantityController: quantityController,
          minQuantityController: minQuantityController,
          expirationDateController: expirationDateController,
        ),
        paddingWidth: size.width * .1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class EditItemBody extends StatelessWidget {
  const EditItemBody({
    super.key,
    required this.ref,
    required this.data,
    required this.nameController,
    required this.quantityController,
    required this.minQuantityController,
    required this.expirationDateController,
  });
  final WidgetRef ref;
  final Map data;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController minQuantityController;
  final TextEditingController expirationDateController;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final List<String> unidadesDeMedida = [
      'Unit',
      'Kg',
      'g',
      'L',
      'mL',
      'Package',
      'Box'
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 390,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: texts['create_item'][1],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    texts['create_item'][2],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Text(
                    texts['create_item'][3],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: minQuantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    texts['create_item'][4],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    height: 40,
                    width: 170,
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
                    child: Center(
                      child: PopupMenuButton<String>(
                        color: Theme.of(context).colorScheme.secondary,
                        onSelected: (String selected) {
                          ref.read(unitItemProvider.notifier).state = selected;
                        },
                        itemBuilder: (BuildContext context) {
                          return unidadesDeMedida.map((String unidade) {
                            return PopupMenuItem<String>(
                              value: unidade,
                              child: Text(
                                ref.watch(languageNotifierProvider)[
                                            'language'] ==
                                        'en'
                                    ? unidade
                                    : unidade == 'Unit'
                                        ? 'Unidade'
                                        : unidade == 'Package'
                                            ? 'Pacote'
                                            : unidade == 'Box'
                                                ? 'Caixa'
                                                : unidade,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                            );
                          }).toList();
                        },
                        child: SizedBox(
                          height: 40,
                          width: 170,
                          child: Center(
                            child: Text(
                              ref.watch(languageNotifierProvider)['language'] ==
                                      'en'
                                  ? ref.watch(unitItemProvider)
                                  : ref.watch(unitItemProvider) == 'Unit'
                                      ? 'Unidade'
                                      : ref.watch(unitItemProvider) == 'Package'
                                          ? 'Pacote'
                                          : ref.watch(unitItemProvider) == 'Box'
                                              ? 'Caixa'
                                              : ref.watch(unitItemProvider),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    texts['create_item'][5],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: 170,
                    child: TextField(
                      enabled: ref.watch(definedExpirationProvider),
                      controller: expirationDateController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DateTextFormatter(
                            ref.watch(languageNotifierProvider)['language'] ==
                                    'pt'
                                ? '/'
                                : '-'),
                      ],
                      decoration: InputDecoration(
                        labelText:
                            ref.watch(languageNotifierProvider)['language'] ==
                                    'pt'
                                ? 'dd/mm/aaaa'
                                : 'mm/dd/yyyy',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(definedExpirationProvider.notifier).state =
                          !ref.watch(definedExpirationProvider);
                    },
                    child: Row(
                      children: [
                        Icon(
                          !ref.watch(definedExpirationProvider)
                              ? Icons.check
                              : Icons.check_box_outline_blank,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          texts['create_item'][8],
                        ),
                        const SizedBox(
                          width: 65,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      nameController.clear();
                      quantityController.clear();
                      minQuantityController.clear();
                      expirationDateController.clear();
                      ref.read(unitItemProvider.notifier).state =
                          ref.watch(languageNotifierProvider)['language'] ==
                                  'en'
                              ? 'Select Unit'
                              : 'Selecionar Unidade';
                      ref.read(definedExpirationProvider.notifier).state = true;
                      Navigator.pop(context);
                    },
                    child: Text(
                      texts['create_item'][9],
                    ),
                  ),
                  DefaultButton(
                    text: texts['edit_item'][1],
                    action: () async {
                      if (nameController.text == '' ||
                          quantityController.text == '' ||
                          minQuantityController.text == '' ||
                          ref.watch(unitItemProvider) == 'Selecionar Unidade' ||
                          ref.watch(unitItemProvider) == 'Select Unit' ||
                          (ref.watch(definedExpirationProvider) &&
                              (expirationDateController.text == '' ||
                                  expirationDateController.text.length < 10))) {
                        showSnackBar(context, texts['create_item'][11]);
                      } else {
                        DateTime? exDate;
                        if (ref.watch(definedExpirationProvider) &&
                            expirationDateController.text.length == 10) {
                          try {
                            if (ref.watch(
                                    languageNotifierProvider)['language'] ==
                                'pt') {
                              exDate = DateTime(
                                int.parse(
                                    expirationDateController.text.substring(6)),
                                int.parse(expirationDateController.text
                                    .substring(3, 5)),
                                int.parse(expirationDateController.text
                                    .substring(0, 2)),
                              );
                            } else {
                              exDate = DateTime(
                                int.parse(
                                    expirationDateController.text.substring(6)),
                                int.parse(expirationDateController.text
                                    .substring(0, 2)),
                                int.parse(expirationDateController.text
                                    .substring(3, 5)),
                              );
                            }
                          } catch (e) {
                            showSnackBar(context, texts['create_item'][12]);
                            return;
                          }
                        } else {
                          if (ref.watch(definedExpirationProvider)) {
                            showSnackBar(context, texts['create_item'][12]);
                            return;
                          }
                        }

                        String name = nameController.text.trim();
                        String quantity = quantityController.text.trim();
                        String minQuantity = minQuantityController.text.trim();
                        String expDate = ref.watch(definedExpirationProvider)
                            ? exDate.toString()
                            : 'not defined';

                        final items = ref.watch(itemsProvider);

                        bool duplicated = false;
                        for (var item in items) {
                          if (name == item['name'] &&
                              data['id'] != item['id']) {
                            showSnackBar(context, texts['create_item'][13]);
                            duplicated = true;
                            return;
                          }
                        }
                        if (!duplicated) {
                          await FirebaseServices()
                              .firestore
                              .collection('Stocks')
                              .doc(ref.watch(currentStockProvider).id)
                              .collection('Items')
                              .doc(data['id'])
                              .update({
                            'name': name,
                            'quantity': int.parse(quantity),
                            'minQuantity': int.parse(minQuantity),
                            'unit': ref.read(unitItemProvider),
                            'expireDate': expDate,
                            'status': 'blue',
                          });

                          ref.read(definedExpirationProvider.notifier).state =
                              true;
                          ref.read(unitItemProvider.notifier).state =
                              ref.watch(languageNotifierProvider)['language'] ==
                                      'en'
                                  ? 'Select Unit'
                                  : 'Selecionar Unidade';

                          Navigator.pushNamed(context, '/items');
                        }
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * .1,
        )
      ],
    );
  }
}
