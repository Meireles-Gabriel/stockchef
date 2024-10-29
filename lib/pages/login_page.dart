import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/language_switch.dart';

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
                    ),
                    HDivider(texts: texts),
                    SignUpFields(
                      signUpName,
                      signUpEmail,
                      signUpPassword,
                      signUpCheckPassword,
                    )
                  ],
                ),
              ),
            ),
            tablet: const Placeholder(),
            desktop: const Placeholder(),
            paddingWidth: size.width * 0.1,
            bgColor: Theme.of(context).colorScheme.surface,
          );
        },
      ),
    );
  }
}

class HDivider extends StatelessWidget {
  const HDivider({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(texts['login'][5]),
        const SizedBox(
          width: 5,
        ),
        const Expanded(
          child: Divider(),
        )
      ],
    );
  }
}

class VDivider extends StatelessWidget {
  const VDivider({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: VerticalDivider(),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(texts['login'][5]),
        const SizedBox(
          height: 5,
        ),
        const Expanded(
          child: VerticalDivider(),
        )
      ],
    );
  }
}

class LogInFields extends ConsumerWidget {
  final dynamic logInEmail;
  final dynamic logInPassword;

  const LogInFields({
    super.key,
    required this.logInEmail,
    required this.logInPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width < 768 ? size.width * .7 : size.height * .7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: logInEmail,
              decoration: InputDecoration(
                labelText: texts['login'][1],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: logInPassword,
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
              child: DefaultButton(
                text: texts['login'][3],
                action: () {},
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {},
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
  const SignUpFields(
    this.signUpName,
    this.signUpEmail,
    this.signUpPassword,
    this.signUpCheckPassword, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width < 768 ? size.width * .7 : size.height * .7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: signUpName,
              decoration: InputDecoration(
                labelText: texts['login'][0],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: signUpEmail,
              decoration: InputDecoration(
                labelText: texts['login'][1],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: signUpPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: texts['login'][2],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: signUpCheckPassword,
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
              child: DefaultButton(
                text: texts['login'][6],
                action: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
