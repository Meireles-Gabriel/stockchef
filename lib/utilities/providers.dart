import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/language_notifier.dart';

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
final createItemNameProvider = StateProvider<String>(
  (ref) => '',
);
final createItemQuantityProvider = StateProvider<String>(
  (ref) => '',
);
final createItemMinQuantityProvider = StateProvider<String>(
  (ref) => '0',
);
final createItemExpirationDateProvider = StateProvider<String>(
  (ref) => '',
);

final unitItemProvider = StateProvider<String>((ref) {
  return ref.watch(languageNotifierProvider)['language'] == 'en'
      ? 'Select Unit'
      : 'Selecinar Unidade';
});
final definedExpirationProvider = StateProvider<bool>(
  (ref) => true,
);

final currentStockProvider = StateProvider<dynamic>((ref) => null);
final itemsProvider = StateProvider<dynamic>((ref) => null);
final preparationsProvider = StateProvider<dynamic>((ref) => null);
