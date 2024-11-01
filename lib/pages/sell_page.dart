// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/auth_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          Map texts = ref.watch(languageNotifierProvider)['texts'];
          String soloBRLUrl =
              'https://checkout.stripe.com/c/pay/cs_test_a1KPsxdLg3ym3tM8AfD7ylHjE0SH3FuP72jLK1hdMspoS9RsHhcpzK63Nv#fid1d2BpamRhQ2prcSc%2FJ0hqa3F2YHd3ZHEnKSd2cGd2ZndsdXFsamtQa2x0cGBrYHZ2QGtkZ2lgYSc%2FY2RpdmApJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRURmlhUkRCS2FGRDd8bk5fYHFdN29VMG9wZnNuYFdPYlR1MnVjak82RG40TjJfQ0JIUTxAMFBLR3BPYTB1fW5cMzNTbmh2amNPMFNIZH9QV1QwR0JmcGA1NWh%2Fc0E3b0kxJyknY3dqaFZgd3Ngdyc%2FcXdwYCknaWR8anBxUXx1YCc%2FJ3Zsa2JpYFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl';
          String teamBRLUrl =
              'https://checkout.stripe.com/c/pay/cs_test_a1LTxcufwwvWKOOersoskg3cw1PqKpCQG8dDGph41tBFBTtayrIt0WbJYO#fid1d2BpamRhQ2prcSc%2FJ0hqa3F2YHd3ZHEnKSd2cGd2ZndsdXFsamtQa2x0cGBrYHZ2QGtkZ2lgYSc%2FY2RpdmApJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRURmlhUkRCS2FGRDd8bk5fYHFdN29VMG9wZnNuYFdPYlR1MnVjak82RG40TjJfQ0JIUTxAMFBLR3BPYTB1fW5cMzNTbmh2amNPMFNIZH9QV1QwR0JmcGA1NWh%2Fc0E3b0kxJyknY3dqaFZgd3Ngdyc%2FcXdwYCknaWR8anBxUXx1YCc%2FJ3Zsa2JpYFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl';
          String soloUSDUrl =
              'https://checkout.stripe.com/c/pay/cs_test_a1O0duDRdYSO1e7BtV623jO16cc3cc4qUMcdDCLfdjO09ubrwgKOyysVqM#fid1d2BpamRhQ2prcSc%2FJ0hqa3F2YHd3ZHEnKSd2cGd2ZndsdXFsamtQa2x0cGBrYHZ2QGtkZ2lgYSc%2FY2RpdmApJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRURmlhUkRCS2FGRDd8bk5fYHFdN29VMG9wZnNuYFdPYlR1MnVjak82RG40TjJfQ0JIUTxAMFBLR3BPYTB1fW5cMzNTbmh2amNPMFNIZH9QV1QwR0JmcGA1NWh%2Fc0E3b0kxJyknY3dqaFZgd3Ngdyc%2FcXdwYCknaWR8anBxUXx1YCc%2FJ3Zsa2JpYFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl';
          String teamUSDUrl =
              'https://checkout.stripe.com/c/pay/cs_test_a1qlk96ALiTyZLsWgO5TeCGFoZsbUlOWPfj0Wk1YnMZw6p6aWFu19xA0yB#fid1d2BpamRhQ2prcSc%2FJ0hqa3F2YHd3ZHEnKSd2cGd2ZndsdXFsamtQa2x0cGBrYHZ2QGtkZ2lgYSc%2FY2RpdmApJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRURmlhUkRCS2FGRDd8bk5fYHFdN29VMG9wZnNuYFdPYlR1MnVjak82RG40TjJfQ0JIUTxAMFBLR3BPYTB1fW5cMzNTbmh2amNPMFNIZH9QV1QwR0JmcGA1NWh%2Fc0E3b0kxJyknY3dqaFZgd3Ngdyc%2FcXdwYCknaWR8anBxUXx1YCc%2FJ3Zsa2JpYFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl';
          return HelperClass(
              mobile: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 220,
                          child: DefaultButton(
                            text: 'Solo',
                            action: () async {
                              if (kIsWeb) {
                                if (PlatformDispatcher.instance.locale
                                        .toString() ==
                                    'pt_BR') {
                                  launchUrl(Uri.parse(soloBRLUrl));
                                } else {
                                  launchUrl(Uri.parse(soloUSDUrl));
                                }
                              } else {
                                String customerId = await StripeServices()
                                    .createCustomer(
                                        context,
                                        texts,
                                        await AuthServices().getUserName(),
                                        await AuthServices().getUserEmail());
                                try {
                                  List? intentData = await StripeServices()
                                      .createPaymentIntent(
                                          context,
                                          texts,
                                          customerId,
                                          PlatformDispatcher.instance.locale
                                                      .toString() ==
                                                  'pt_BR'
                                              ? StripeServices().soloBRLId
                                              : StripeServices().soloUSDId);
                                  final clientSecret = intentData![0];
                                  final intentId = intentData[1];
                                  if (clientSecret == null) {
                                    throw Exception(
                                        "Erro ao criar o PaymentIntent");
                                  }

                                  await StripeServices().showPaymentSheet(
                                    context,
                                    texts,
                                    clientSecret,
                                    customerId,
                                    ref.watch(themeNotifierProvider),
                                  );
                                  if (kDebugMode) {
                                    print("Pagamento confirmado!");
                                  }
                                  await StripeServices()
                                      .retrieveAndAttachPaymentMethod(
                                          intentId, customerId);
                                  final subscriptionId = await StripeServices()
                                      .createSubscription(
                                          context,
                                          texts,
                                          customerId,
                                          PlatformDispatcher.instance.locale
                                                      .toString() ==
                                                  'pt_BR'
                                              ? StripeServices().soloBRLprice
                                              : StripeServices().soloUSDprice,
                                          StripeServices().soloBRLId);
                                  if (subscriptionId != null) {
                                    if (kDebugMode) {
                                      print(
                                          "Assinatura criada com sucesso! ID: $subscriptionId");
                                    }
                                  } else {
                                    throw Exception(
                                        "Erro ao criar a assinatura");
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print("Erro no processo de assinatura: $e");
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 220,
                          child: DefaultButton(
                            text: 'Team',
                            action: () {
                              try {} catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 220,
                          child: DefaultButton(
                            text: 'Check Subscription',
                            action: () {
                              try {} catch (e) {
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
                            text: 'Change Subscription',
                            action: () {
                              try {} catch (e) {
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
                            action: () {
                              try {} catch (e) {
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
