import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class CreateItemPage extends ConsumerStatefulWidget {
  const CreateItemPage({super.key});

  @override
  ConsumerState<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends ConsumerState<CreateItemPage> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController minQuantityController;
  late TextEditingController expirationDateController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    quantityController = TextEditingController();
    minQuantityController = TextEditingController(text: '0');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts['create_item'][0],
        ),
      ),
      drawer: const DefaultDrawer(),
      bottomNavigationBar: const DefaultBottomAppBar(),
      body: HelperClass(
          mobile: Column(
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
                                ref.read(unitItemProvider.notifier).state =
                                    selected;
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
                                  child: Text(ref.watch(
                                                  languageNotifierProvider)[
                                              'language'] ==
                                          'en'
                                      ? ref.watch(unitItemProvider)
                                      : ref.watch(unitItemProvider) == 'Unit'
                                          ? 'Unidade'
                                          : ref.watch(unitItemProvider) ==
                                                  'Package'
                                              ? 'Pacote'
                                              : ref.watch(unitItemProvider) ==
                                                      'Box'
                                                  ? 'Caixa'
                                                  : ref
                                                      .watch(unitItemProvider)),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _DateTextFormatter(
                                  ref.watch(languageNotifierProvider)[
                                              'language'] ==
                                          'pt'
                                      ? '/'
                                      : '-'),
                            ],
                            decoration: InputDecoration(
                              labelText: ref.watch(languageNotifierProvider)[
                                          'language'] ==
                                      'pt'
                                  ? 'dd/mm/aaaa'
                                  : 'mm/dd/yyyy',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                            minQuantityController.text = '0';
                            ref
                                .read(unitItemProvider.notifier)
                                .state = ref.watch(
                                        languageNotifierProvider)['language'] ==
                                    'en'
                                ? 'Select Unit'
                                : 'Selecinar Unidade';
                            ref.read(definedExpirationProvider.notifier).state =
                                true;
                            Navigator.pushNamed(context, '/items');
                          },
                          child: Text(
                            texts['create_item'][9],
                          ),
                        ),
                        DefaultButton(
                          text: texts['create_item'][10],
                          action: () {
                            if (nameController.text == '' ||
                                quantityController.text == '' ||
                                minQuantityController.text == '' ||
                                (ref.watch(definedExpirationProvider) &&
                                    expirationDateController.text == '')) {
                              showSnackBar(context, texts['create_item'][11]);
                            } else {
                              if (ref.watch(definedExpirationProvider) &&
                                  expirationDateController.text.length != 8) {
                                try {
                                  DateTime exDate;
                                  if (ref.watch(languageNotifierProvider)[
                                          'language'] ==
                                      'pt') {
                                    exDate = DateTime(
                                      int.parse(expirationDateController.text
                                          .substring(6)),
                                      int.parse(expirationDateController.text
                                          .substring(3, 5)),
                                      int.parse(expirationDateController.text
                                          .substring(0, 2)),
                                    );
                                  } else {
                                    exDate = DateTime(
                                      int.parse(expirationDateController.text
                                          .substring(6)),
                                      int.parse(expirationDateController.text
                                          .substring(0, 2)),
                                      int.parse(expirationDateController.text
                                          .substring(3, 5)),
                                    );
                                  }
                                } catch (e) {
                                  showSnackBar(
                                      context, texts['create_item'][12]);
                                }
                              } else {
                                showSnackBar(context, texts['create_item'][12]);
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
          ),
          tablet: const Placeholder(),
          desktop: const Placeholder(),
          paddingWidth: size.width * .1,
          bgColor: Theme.of(context).colorScheme.surface),
    );
  }
}

class _DateTextFormatter extends TextInputFormatter {
  final String separator;

  _DateTextFormatter(this.separator);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    if (text.length >= 2 && text[2] != separator) {
      text = text.substring(0, 2) + separator + text.substring(2);
    }
    if (text.length >= 5 && text[5] != separator) {
      text = text.substring(0, 5) + separator + text.substring(5);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
