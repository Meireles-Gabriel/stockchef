// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          Map texts = ref.watch(languageNotifierProvider)['texts'];
          return HelperClass(
              mobile: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: DefaultButton(
                          text: 'Change Subscription',
                          action: () async {
                            try {
                              await StripeServices()
                                  .upgradePlanButtonAction(context, ref, texts);
                            } catch (e) {
                              if (kDebugMode) {
                                showSnackBar(context, e.toString());
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: DefaultButton(
                          text: 'Cancel Subscription',
                          action: () async {
                            await StripeServices()
                                .cancelPlanButtonAction(context, texts);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: DefaultButton(
                          text: 'Log Out',
                          action: () {
                            try {
                              FirebaseServices().logOut(context);
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              tablet: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: const Placeholder(),
                ),
              ),
              desktop: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: const Placeholder(),
                ),
              ),
              paddingWidth: size.width * .1,
              bgColor: Theme.of(context).colorScheme.surface);
        },
      ),
    );
  }
}
