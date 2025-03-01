import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/forgot_password_dialog.dart';
import 'package:stockchef/widgets/h_divider.dart';
import 'package:stockchef/widgets/language_switch.dart';
import 'package:stockchef/widgets/v_divider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageSwitch()],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final TextEditingController logInEmail = TextEditingController();
          final TextEditingController logInPassword = TextEditingController();
          final TextEditingController signUpName = TextEditingController();
          final TextEditingController signUpEmail = TextEditingController();
          final TextEditingController signUpPassword = TextEditingController();
          final TextEditingController signUpCheckPassword =
              TextEditingController();

          final FocusNode focusNodeloginEmail = FocusNode();
          final FocusNode focusNodeloginPassword = FocusNode();
          final FocusNode focusNodesignUpName = FocusNode();
          final FocusNode focusNodesignUpEmail = FocusNode();
          final FocusNode focusNodesignUpPassword = FocusNode();
          final FocusNode focusNodesignUpCheckPassword = FocusNode();

          Map texts = ref.watch(languageNotifierProvider)['texts'];
          return HelperClass(
            mobile: SingleChildScrollView(
              child: SizedBox(
                height: size.height * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LogInFields(
                      logInEmail: logInEmail,
                      logInPassword: logInPassword,
                      focusNodeloginEmail: focusNodeloginEmail,
                      focusNodeloginPassword: focusNodeloginPassword,
                    ),
                    HDivider(texts: texts),
                    SignUpFields(
                      signUpName,
                      signUpEmail,
                      signUpPassword,
                      signUpCheckPassword,
                      focusNodesignUpName,
                      focusNodesignUpEmail,
                      focusNodesignUpPassword,
                      focusNodesignUpCheckPassword,
                    )
                  ],
                ),
              ),
            ),
            tablet: SingleChildScrollView(
              child: SizedBox(
                height: size.height * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LogInFields(
                      logInEmail: logInEmail,
                      logInPassword: logInPassword,
                      focusNodeloginEmail: focusNodeloginEmail,
                      focusNodeloginPassword: focusNodeloginPassword,
                    ),
                    VDivider(texts: texts),
                    SignUpFields(
                      signUpName,
                      signUpEmail,
                      signUpPassword,
                      signUpCheckPassword,
                      focusNodesignUpName,
                      focusNodesignUpEmail,
                      focusNodesignUpPassword,
                      focusNodesignUpCheckPassword,
                    ),
                  ],
                ),
              ),
            ),
            desktop: SingleChildScrollView(
              child: SizedBox(
                height: size.height * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LogInFields(
                      logInEmail: logInEmail,
                      logInPassword: logInPassword,
                      focusNodeloginEmail: focusNodeloginEmail,
                      focusNodeloginPassword: focusNodeloginPassword,
                    ),
                    VDivider(texts: texts),
                    SignUpFields(
                      signUpName,
                      signUpEmail,
                      signUpPassword,
                      signUpCheckPassword,
                      focusNodesignUpName,
                      focusNodesignUpEmail,
                      focusNodesignUpPassword,
                      focusNodesignUpCheckPassword,
                    ),
                  ],
                ),
              ),
            ),
            paddingWidth: size.width * 0.1,
            bgColor: Theme.of(context).colorScheme.surface,
          );
        },
      ),
    );
  }
}

class LogInFields extends ConsumerWidget {
  final dynamic logInEmail;
  final dynamic logInPassword;
  final FocusNode focusNodeloginEmail;
  final FocusNode focusNodeloginPassword;

  const LogInFields({
    super.key,
    required this.logInEmail,
    required this.logInPassword,
    required this.focusNodeloginEmail,
    required this.focusNodeloginPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width < 768 ? size.width * .7 : size.height * .35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: logInEmail,
              focusNode: focusNodeloginEmail,
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(focusNodeloginPassword),
              decoration: InputDecoration(
                labelText: texts['login'][1],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: logInPassword,
              focusNode: focusNodeloginPassword,
              onSubmitted: (ref.watch(isLoadingLogInProvider) ||
                      ref.watch(isLoadingSignUpProvider))
                  ? null
                  : (value) {
                      ref.read(isLoadingLogInProvider.notifier).state = true;
                      FirebaseServices()
                          .logIn(
                              context: context,
                              texts: texts,
                              email: logInEmail.text,
                              password: logInPassword.text)
                          .then((value) {
                        ref.read(isLoadingLogInProvider.notifier).state = false;
                      });
                    },
              obscureText: true,
              decoration: InputDecoration(
                labelText: texts['login'][2],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .7,
              child: ref.watch(isLoadingLogInProvider)
                  ? const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DefaultButton(
                      text: texts['login'][3],
                      action: (ref.watch(isLoadingLogInProvider) ||
                              ref.watch(isLoadingSignUpProvider))
                          ? null
                          : () {
                              ref.read(isLoadingLogInProvider.notifier).state =
                                  true;
                              FirebaseServices()
                                  .logIn(
                                      context: context,
                                      texts: texts,
                                      email: logInEmail.text,
                                      password: logInPassword.text)
                                  .then((value) {
                                ref
                                    .read(isLoadingLogInProvider.notifier)
                                    .state = false;
                              });
                            },
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {
                forgotPasswordDialog(context, texts);
              },
              child: Text(
                texts['login'][4],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpFields extends ConsumerWidget {
  final TextEditingController signUpName;
  final TextEditingController signUpEmail;
  final TextEditingController signUpPassword;
  final TextEditingController signUpCheckPassword;
  final FocusNode focusNodesignUpName;
  final FocusNode focusNodesignUpEmail;
  final FocusNode focusNodesignUpPassword;
  final FocusNode focusNodesignUpCheckPassword;
  const SignUpFields(
    this.signUpName,
    this.signUpEmail,
    this.signUpPassword,
    this.signUpCheckPassword,
    this.focusNodesignUpName,
    this.focusNodesignUpEmail,
    this.focusNodesignUpPassword,
    this.focusNodesignUpCheckPassword, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width < 768 ? size.width * .7 : size.height * .35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: signUpName,
              focusNode: focusNodesignUpName,
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(focusNodesignUpEmail),
              decoration: InputDecoration(
                labelText: texts['login'][0],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: signUpEmail,
              focusNode: focusNodesignUpEmail,
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(focusNodesignUpPassword),
              decoration: InputDecoration(
                labelText: texts['login'][1],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: signUpPassword,
              focusNode: focusNodesignUpPassword,
              onSubmitted: (value) => FocusScope.of(context)
                  .requestFocus(focusNodesignUpCheckPassword),
              obscureText: true,
              decoration: InputDecoration(
                labelText: texts['login'][2],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: !ref.watch(isLoadingLogInProvider) &&
                  !ref.watch(isLoadingSignUpProvider),
              controller: signUpCheckPassword,
              focusNode: focusNodesignUpCheckPassword,
              onSubmitted: (ref.watch(isLoadingLogInProvider) ||
                      ref.watch(isLoadingSignUpProvider))
                  ? null
                  : (value) {
                      ref.read(isLoadingSignUpProvider.notifier).state = true;
                      FirebaseServices()
                          .signUp(
                              context: context,
                              texts: texts,
                              email: signUpEmail.text,
                              password: signUpPassword.text,
                              checkPassword: signUpCheckPassword.text,
                              name: signUpName.text)
                          .then((value) {
                        ref.read(isLoadingSignUpProvider.notifier).state =
                            false;
                      });
                    },
              obscureText: true,
              decoration: InputDecoration(
                labelText: texts['login'][14],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .7,
              child: ref.watch(isLoadingSignUpProvider)
                  ? const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DefaultButton(
                      text: texts['login'][6],
                      action: (ref.watch(isLoadingLogInProvider) ||
                              ref.watch(isLoadingSignUpProvider))
                          ? null
                          : () {
                              ref.read(isLoadingSignUpProvider.notifier).state =
                                  true;
                              FirebaseServices()
                                  .signUp(
                                      context: context,
                                      texts: texts,
                                      email: signUpEmail.text,
                                      password: signUpPassword.text,
                                      checkPassword: signUpCheckPassword.text,
                                      name: signUpName.text)
                                  .then((value) {
                                ref
                                    .read(isLoadingSignUpProvider.notifier)
                                    .state = false;
                              });
                            },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
