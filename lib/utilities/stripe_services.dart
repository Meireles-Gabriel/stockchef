// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:stockchef/utilities/auth_services.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';

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
            (planId == soloBRLId || planId == soloUSDId) ? 'brl' : 'usd',
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
          .doc(await AuthServices().getUserUID())
          .update({
        'subscritionId': subscriptionId,
        'subscriptionType':
            (planId == soloBRLId || planId == soloUSDId) ? 'solo' : 'team'
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
        if (subscription['status'] == 'active') {
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

  Future<String?> checkSubscriptionStatus(String subscriptionId) async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
      },
    );

    if (response.statusCode == 200) {
      final status = jsonDecode(response.body)['status'];

      if (kDebugMode) {
        print("Status da assinatura: $status");
      }
      return status;
    } else {
      if (kDebugMode) {
        print("Erro ao verificar status da assinatura: ${response.body}");
      }
      return null;
    }
  }

  Future<void> cancelSubscription(
      BuildContext context, Map texts, String subscriptionId) async {
    final response = await http.delete(
      Uri.parse('https://api.stripe.com/v1/subscriptions/$subscriptionId'),
      headers: {
        'Authorization': 'Bearer $secKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(await AuthServices().getUserUID())
            .update({'subscritionId': '', 'subscriptionType': 'trial'});
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
}
