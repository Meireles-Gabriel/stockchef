// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeServices {
  final pubKey =
      'pk_test_51QCldWAGNdCA2ykKZetX2jP5jucvkeRJgQp7pfoJ3Ak1K7ZFGMT9E5UNBuJd5pxkY66VkmsofJ5VMazURQ5BGcue00mzvD2jL4';
  final secKey =
      'sk_test_51QCldWAGNdCA2ykKwFTqRLfmt6DbKn5Vam7k6jTj5Pyk00NYh3rZ3k2wkkAMa9yOfAHFARqJQBYVtJUL1F00uPDE00kNU5gd0F';

  final soloBRLId = 'prod_R8HRoDQr9nSxSM';
  final soloBRLprice = 'price_1QG0sfAGNdCA2ykKajaINR4d';
  final teamBRLId = 'prod_R8HRnqJcWdQRnz';
  final teamBRLprice = 'price_1QG0syAGNdCA2ykKwxwbKDw2';
  final soloUSDId = 'prod_R8HSdX7wr9Fa0N';
  final soloUSDprice = 'price_1QG0tIAGNdCA2ykKGltKNaGG';
  final teamUSDId = 'prod_R8HTWDGjn70Mcl';
  final teamUSDprice = 'price_1QG0uaAGNdCA2ykK2W0PUsZA';

  Future<dynamic> createCustomer(
      BuildContext context, Map texts, String name, String email) async {
    try {
      final customerResponse = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $secKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'email': email,
        },
      );

      return jsonDecode(customerResponse.body)['id'];
    } catch (e) {
      showSnackBar(context, texts['sell'][0]);
      return e.toString();
    }
  }

  Future<List?> createPaymentIntent(
      BuildContext context, Map texts, String customerId, String planId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
        'amount': planId == soloBRLId
            ? '990'
            : planId == teamBRLId
                ? '1490'
                : planId == soloUSDId
                    ? '490'
                    : '990',
        'currency':
            (planId == soloBRLId || planId == teamBRLId) ? 'brl' : 'usd',
        'setup_future_usage': 'off_session',
        'payment_method_types[]': 'card',
      },
    );

    if (response.statusCode == 200) {
      final clientSecret = jsonDecode(response.body)['client_secret'];
      final intentId = jsonDecode(response.body)['id'];
      return [clientSecret, intentId];
    } else {
      showSnackBar(context, texts['sell'][0]);
      if (kDebugMode) {
        print("Erro ao criar o PaymentIntent: ${response.body}");
      }
      return null;
    }
  }

  Future<void> showPaymentSheet(BuildContext context, Map texts,
      String clientSecret, String customerId, ThemeMode theme) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'StockChef',
          customerId: customerId,
          style: theme,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (kDebugMode) {
        print("Pagamento realizado com sucesso!");
      }
    } on StripeException catch (e) {
      showSnackBar(context, texts['sell'][0]);
      if (kDebugMode) {
        print("Erro no pagamento: $e");
      }
    } catch (e) {
      showSnackBar(context, texts['sell'][0]);
      if (kDebugMode) {
        print("Erro inesperado: $e");
      }
    }
  }

  Future<void> retrieveAndAttachPaymentMethod(
      String paymentIntentId, String customerId) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
      headers: {
        'Authorization': 'Bearer $secKey',
      },
    );

    if (response.statusCode == 200) {
      final paymentMethodId = jsonDecode(response.body)['payment_method'];

      await attachPaymentMethodToCustomer(paymentMethodId, customerId);
    } else {
      if (kDebugMode) {
        print("Erro ao recuperar PaymentIntent: ${response.body}");
      }
    }
  }

  Future<void> attachPaymentMethodToCustomer(
      String paymentMethodId, String customerId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers/$customerId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Método de pagamento associado ao cliente com sucesso.");
      }
    } else {
      if (kDebugMode) {
        print("Erro ao associar método de pagamento: ${response.body}");
      }
    }
  }

  Future<String?> createSubscription(BuildContext context, Map texts,
      String customerId, String priceId, String planId) async {
    final trialEnd =
        DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch ~/
            1000;
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
        'items[0][price]': priceId,
        'trial_end': trialEnd.toString(),
      },
    );

    if (response.statusCode == 200) {
      final subscriptionId = jsonDecode(response.body)['id'];
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseServices().auth.currentUser!.uid)
          .update({
        'subscriptionId': subscriptionId,
        'subscriptionType':
            (planId == soloBRLId || planId == soloUSDId) ? 'solo' : 'team',
        'subscriptionStatus': 'active',
      });
      if (kDebugMode) {
        showSnackBar(context, texts['sell'][1]);
        print("Assinatura criada com sucesso: $subscriptionId");
      }
      return subscriptionId;
    } else {
      if (kDebugMode) {
        showSnackBar(context, texts['sell'][0]);
        print("Erro ao criar assinatura: ${response.body}");
      }
      return null;
    }
  }

  Future<String?> getCustomerIdByEmail(String email) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/customers?email=$email'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'].isNotEmpty) {
        return data['data'][0]['id'];
      }
    } else {
      if (kDebugMode) {
        print("Cliente não possui assinatura.");
      }
    }
    return null;
  }

  Future<String?> getActiveSubscriptionId(String customerId) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/subscriptions?customer=$customerId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var subscription in data['data']) {
        if (subscription['status'] == 'active' ||
            subscription['status'] == 'trialing' ||
            subscription['status'] == 'past_due') {
          return subscription['id'];
        }
      }
    } else {
      if (kDebugMode) {
        print("Nenhuma assinatura encontrada.");
      }
    }
    return null;
  }

  Future<String?> getPlanId(String subscriptionId) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      dynamic subInfo = jsonDecode(response.body);
      if (subInfo != null && subInfo['items']['data'].isNotEmpty) {
        return subInfo['items']['data'][0]['price']['product'];
      }

      return null;
    } else {
      if (kDebugMode) {
        print("Erro ao buscar assinatura: ${response.body}");
      }
      return null;
    }
  }

  Future<String?> getCustomerSubscription() async {
    String userSubscriptionType = 'not logged';
    String? userStripeId = await StripeServices()
        .getCustomerIdByEmail(FirebaseServices().auth.currentUser!.email!);

    if (userStripeId == null) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseServices().auth.currentUser!.uid)
          .update({'subscriptionId': '', 'subscriptionType': 'trial'});
    } else {
      String? subscriptionId =
          await StripeServices().getActiveSubscriptionId(userStripeId);
      if (subscriptionId == null) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseServices().auth.currentUser!.uid)
            .update({'subscriptionId': '', 'subscriptionType': 'trial'});
      } else {
        String? planId = await StripeServices().getPlanId(subscriptionId);
        if (planId == null) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseServices().auth.currentUser!.uid)
              .update({'subscriptionId': '', 'subscriptionType': 'trial'});
        } else {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseServices().auth.currentUser!.uid)
              .update({
            'subscriptionId': subscriptionId,
            'subscriptionType': (planId == StripeServices().soloBRLId ||
                    planId == StripeServices().soloUSDId)
                ? 'solo'
                : (planId == StripeServices().teamBRLId ||
                        planId == StripeServices().teamUSDId)
                    ? 'team'
                    : 'trial'
          });
        }
      }
    }
    final docSnap = await FirebaseServices()
        .firestore
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();
    var userInfo = docSnap.data();
    if (userInfo!['subscriptionStatus'] == 'canceled') {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseServices().auth.currentUser!.uid)
          .update({'subscriptionId': '', 'subscriptionType': 'trial'});
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();

    userSubscriptionType = docSnapshot.data()!['subscriptionType'];
    return userSubscriptionType;
  }

  Future<void> cancelSubscription(
      BuildContext context, Map texts, String subscriptionId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'cancel_at_period_end': 'true',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseServices().auth.currentUser!.uid)
            .update({
          'subscriptionId': '',
          'subscriptionType': 'trial',
          'subscriptionStatus': 'canceled',
        });
        print("Assinatura cancelada com sucesso.");
        showSnackBar(context, texts['sell'][2]);
      }
    } else {
      if (kDebugMode) {
        showSnackBar(context, texts['sell'][0]);
        print("Erro ao cancelar a assinatura: ${response.body}");
      }
    }
  }

  Future<void> soloPlanButtonAction(
      BuildContext context, WidgetRef ref, Map texts) async {
    String soloBRLUrl = 'https://buy.stripe.com/test_dR6bJMb2w0s45SE7ss';
    String soloUSDUrl = 'https://buy.stripe.com/test_28oeVYgmQ7Uwa8U3ce';

    if (kIsWeb) {
      if (PlatformDispatcher.instance.locale.toString() == 'pt_BR') {
        launchUrl(Uri.parse(soloBRLUrl));
      } else {
        launchUrl(Uri.parse(soloUSDUrl));
      }
    } else {
      String customerId = await StripeServices().createCustomer(
          context,
          texts,
          await FirebaseServices().getUserName(),
          FirebaseServices().auth.currentUser!.email!);
      try {
        List? intentData = await StripeServices().createPaymentIntent(
            context,
            texts,
            customerId,
            PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                ? StripeServices().soloBRLId
                : StripeServices().soloUSDId);
        final clientSecret = intentData![0];
        final intentId = intentData[1];
        if (clientSecret == null) {
          throw Exception("Erro ao criar o PaymentIntent");
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
            .retrieveAndAttachPaymentMethod(intentId, customerId);
        final subscriptionId = await StripeServices().createSubscription(
            context,
            texts,
            customerId,
            PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                ? StripeServices().soloBRLprice
                : StripeServices().soloUSDprice,
            StripeServices().soloBRLId);
        if (subscriptionId != null) {
          if (kDebugMode) {
            print("Assinatura criada com sucesso! ID: $subscriptionId");
          }
        } else {
          throw Exception("Erro ao criar a assinatura");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Erro no processo de assinatura: $e");
        }
      }
    }
  }

  Future<void> teamPlanButtonAction(
      BuildContext context, WidgetRef ref, Map texts) async {
    String teamBRLUrl = 'https://buy.stripe.com/test_4gw7tw5Icb6Iepa7st';

    String teamUSDUrl = 'https://buy.stripe.com/test_5kA5lodaE4Ik1Co8wz';
    if (kIsWeb) {
      if (PlatformDispatcher.instance.locale.toString() == 'pt_BR') {
        launchUrl(Uri.parse(teamBRLUrl));
      } else {
        launchUrl(Uri.parse(teamUSDUrl));
      }
    } else {
      String customerId = await StripeServices().createCustomer(
          context,
          texts,
          await FirebaseServices().getUserName(),
          FirebaseServices().auth.currentUser!.email!);
      try {
        List? intentData = await StripeServices().createPaymentIntent(
            context,
            texts,
            customerId,
            PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                ? StripeServices().teamBRLId
                : StripeServices().teamUSDId);
        final clientSecret = intentData![0];
        final intentId = intentData[1];
        if (clientSecret == null) {
          throw Exception("Erro ao criar o PaymentIntent");
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
            .retrieveAndAttachPaymentMethod(intentId, customerId);
        final subscriptionId = await StripeServices().createSubscription(
            context,
            texts,
            customerId,
            PlatformDispatcher.instance.locale.toString() == 'pt_BR'
                ? StripeServices().teamBRLprice
                : StripeServices().teamUSDprice,
            StripeServices().teamBRLId);
        if (subscriptionId != null) {
          if (kDebugMode) {
            print("Assinatura criada com sucesso! ID: $subscriptionId");
          }
          Navigator.pushNamed(context, '/dashboard');
        } else {
          throw Exception("Erro ao criar a assinatura");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Erro no processo de assinatura: $e");
        }
      }
    }
  }

  Future<void> upgradePlanButtonAction(
      BuildContext context, WidgetRef ref, Map texts) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();

    String subscriptionId = docSnapshot.data()!['subscriptionId'];
    String planPrice = PlatformDispatcher.instance.locale.toString() == 'pt_BR'
        ? StripeServices().teamBRLprice
        : StripeServices().teamUSDprice;

    final getSubscriptionResponse = await http.get(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
      },
    );

    if (getSubscriptionResponse.statusCode != 200) {
      if (kDebugMode) {
        print('Erro ao buscar a assinatura: ${getSubscriptionResponse.body}');
      }
      return;
    }

    final subscriptionData = jsonDecode(getSubscriptionResponse.body);
    final subscriptionItemId = subscriptionData['items']['data'][0]['id'];
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'items[0][id]': subscriptionItemId,
        'items[0][deleted]': 'true',
        'items[1][price]': planPrice,
        'proration_behavior': 'create_prorations',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        await getCustomerSubscription();
        print('Assinatura alterada para o novo plano com sucesso');
      }
    } else {
      if (kDebugMode) {
        print('Erro ao alterar a assinatura: ${response.body}');
      }
    }
  }

  Future<void> cancelPlanButtonAction(BuildContext context, Map texts) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseServices().auth.currentUser!.uid)
        .get();

    String subscriptionId = docSnapshot.data()!['subscriptionId'];
    await cancelSubscription(context, texts, subscriptionId);

    await getCustomerSubscription();
  }
}
