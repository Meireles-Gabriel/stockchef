// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/h_divider.dart';
import 'package:stockchef/widgets/v_divider.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  Map? userInfo;
  int? timeRemaining;

  Future<void> _getUserInfo() async {
    final docSnapshot = await FirebaseServices()
        .firestore
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();
    userInfo = docSnapshot.data();
    DateTime creationDate = DateTime.parse(userInfo!['createdAt']);
    timeRemaining = 14 - DateTime.now().difference(creationDate).inDays;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return userInfo == null
        ? Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              automaticallyImplyLeading: false,
              title: Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                Map texts = ref.watch(languageNotifierProvider)['texts'];
                return Text(
                  timeRemaining! > 0
                      ? texts['sell'][7] +
                          timeRemaining.toString() +
                          texts['sell'][8]
                      : texts['sell'][16],
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                );
              }),
              actions: [
                if (timeRemaining! > 0)
                  Consumer(builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final Size size = MediaQuery.sizeOf(context);
                    Map texts = ref.watch(languageNotifierProvider)['texts'];
                    return size.width > 768
                        ? TextButton(
                            child: Text(texts['sell'][15],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/dashboard');
                            },
                          )
                        : IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/dashboard');
                            },
                            icon: const Icon(Icons.close),
                          );
                  }),
              ],
            ),
            body: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final Size size = MediaQuery.sizeOf(context);
                Map texts = ref.watch(languageNotifierProvider)['texts'];

                return HelperClass(
                    mobile: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          texts['sell'][13],
                          style: size.width > 768
                              ? Theme.of(context).textTheme.headlineMedium
                              : Theme.of(context).textTheme.headlineSmall,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SoloPlanCard(
                          texts: texts,
                        ),
                        SizedBox(
                          width: 450,
                          child: HDivider(texts: texts),
                        ),
                        TeamPlanCard(
                          texts: texts,
                        ),
                        const SizedBox(),
                      ],
                    ),
                    tablet: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          texts['sell'][13],
                          style: size.width > 768
                              ? Theme.of(context).textTheme.headlineMedium
                              : Theme.of(context).textTheme.headlineSmall,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SoloPlanCard(
                          texts: texts,
                        ),
                        SizedBox(
                          width: 450,
                          child: HDivider(texts: texts),
                        ),
                        TeamPlanCard(
                          texts: texts,
                        ),
                        const SizedBox(),
                      ],
                    ),
                    desktop: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          texts['sell'][13],
                          style: size.width > 768
                              ? Theme.of(context).textTheme.headlineMedium
                              : Theme.of(context).textTheme.headlineSmall,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SoloPlanCard(
                              texts: texts,
                            ),
                            SizedBox(
                              height: 450,
                              child: VDivider(texts: texts),
                            ),
                            Column(
                              children: [
                                TeamPlanCard(
                                  texts: texts,
                                ),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(),
                        const SizedBox(),
                      ],
                    ),
                    paddingWidth: size.width * .05,
                    bgColor: Theme.of(context).colorScheme.surface);
              },
            ),
          );
  }
}

class SoloPlanCard extends StatelessWidget {
  const SoloPlanCard({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      width: 390,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts['sell'][9],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                          ? 'R\$ 9'
                          : '\$4',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ',90',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          texts['sell'][14],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const Spacer(),
            Text(texts['sell'][10]),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  return DefaultButton(
                    text: texts['sell'][5],
                    action: () {
                      StripeServices()
                          .soloPlanButtonAction(context, ref, texts);
                    },
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TeamPlanCard extends StatelessWidget {
  const TeamPlanCard({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: 390,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts['sell'][11],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                          ? 'R\$14'
                          : '\$9',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ',90',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          texts['sell'][14],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const Spacer(),
            Text(texts['sell'][12]),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  return DefaultButton(
                    text: texts['sell'][5],
                    action: () {
                      StripeServices()
                          .teamPlanButtonAction(context, ref, texts);
                    },
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
