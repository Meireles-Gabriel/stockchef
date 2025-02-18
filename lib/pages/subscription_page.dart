// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/default_drawer.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  Map? userInfo;

  Future<void> _getUserInfo() async {
    final docSnapshot = await FirebaseServices()
        .firestore
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();
    userInfo = docSnapshot.data();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
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
              title: Text(
                texts['dashboard'][3],
              ),
            ),
            bottomNavigationBar: const DefaultBottomAppBar(),
            drawer: const DefaultDrawer(),
            body: HelperClass(
              mobile: SubscriptionBody(userInfo: userInfo),
              tablet: SubscriptionBody(userInfo: userInfo),
              desktop: SubscriptionBody(userInfo: userInfo),
              paddingWidth: size.width * .1,
              bgColor: Theme.of(context).colorScheme.surface,
            ),
          );
  }
}

class SubscriptionBody extends ConsumerWidget {
  final Map? userInfo;
  const SubscriptionBody({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          texts['subscription'][0],
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          userInfo!['subscriptionType'] == 'trial'
              ? texts['subscription'][1]
              : userInfo!['subscriptionType'] == 'solo'
                  ? texts['subscription'][2]
                  : texts['subscription'][3],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 40,
        ),
        userInfo!['subscriptionType'] == 'trial'
            ? SizedBox(
                height: 50,
                width: 220,
                child: DefaultButton(
                  text: texts['subscription'][4],
                  action: () async {
                    Navigator.pushNamed(context, '/sell');
                  },
                ),
              )
            : userInfo!['subscriptionType'] == 'solo'
                ? Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: DefaultButton(
                          text: texts['subscription'][5],
                          action: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Consumer(
                                  builder: (BuildContext context, WidgetRef ref,
                                      Widget? child) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      title: Text(
                                        texts['subscription'][7],
                                      ),
                                      content: Text(texts['subscription'][8]),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(texts['login'][17]),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        DefaultButton(
                                          text: texts['subscription'][10],
                                          action: () async {
                                            try {
                                              await StripeServices()
                                                  .upgradePlanButtonAction(
                                                      context, ref, texts);
                                              Navigator.pushNamed(
                                                  context, '/subscription');
                                            } catch (e) {
                                              if (kDebugMode) {
                                                showSnackBar(
                                                    context, e.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: DefaultButton(
                          text: texts['subscription'][6],
                          action: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Consumer(
                                  builder: (BuildContext context, WidgetRef ref,
                                      Widget? child) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      title: Text(
                                        texts['subscription'][9],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(texts['login'][17]),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        DefaultButton(
                                          text: texts['subscription'][10],
                                          action: () async {
                                            await StripeServices()
                                                .cancelPlanButtonAction(
                                                    context, texts);
                                            Navigator.pushNamed(
                                                context, '/sell');
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 50,
                    width: 220,
                    child: DefaultButton(
                      text: texts['subscription'][6],
                      action: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Consumer(
                              builder: (BuildContext context, WidgetRef ref,
                                  Widget? child) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  title: Text(
                                    texts['subscription'][9],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(texts['login'][17]),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    DefaultButton(
                                      text: texts['subscription'][10],
                                      action: () async {
                                        await StripeServices()
                                            .cancelPlanButtonAction(
                                                context, texts);
                                        Navigator.pushNamed(context, '/sell');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}
