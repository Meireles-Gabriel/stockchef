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

final isLoadingItensProvider = StateProvider<bool>(
  (ref) => false,
);
final stocksProvider = StateProvider<List>(
  (ref) => [],
);
