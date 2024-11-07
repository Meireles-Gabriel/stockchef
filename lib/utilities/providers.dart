import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingLogInProvider = StateProvider<bool>(
  (ref) => false,
);
final isLoadingSignUpProvider = StateProvider<bool>(
  (ref) => false,
);
final isLoadingForgotPasswordProvider = StateProvider<bool>(
  (ref) => false,
);
final isLoadingItemsProvider = StateProvider<bool>(
  (ref) => false,
);
final stocksProvider = StateProvider<List>(
  (ref) => [],
);
final currentStockProvider = StateProvider<dynamic>((ref) => null);
final itemsProvider = StateProvider<dynamic>((ref) => null);
final preparationsProvider = StateProvider<dynamic>((ref) => null);
