import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/texts.dart';
import 'package:stockchef/widgets/language_switch.dart';
import 'package:stockchef/widgets/theme_switch.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: HelperClass(
        mobile: const MobileBody(),
        tablet: const Placeholder(),
        desktop: const Placeholder(),
        paddingWidth: size.width * 0.1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class MobileBody extends ConsumerWidget {
  const MobileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(textsNotifierProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (Theme.of(context).brightness == Brightness.dark)
                    Container(
                      width: 71,
                      height: 71,
                      decoration: BoxDecoration(
                        color: lightTheme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Image.asset(
                    'assets/logo.png',
                    color: darkTheme.colorScheme.surface,
                    height: 70,
                  ),
                ],
              ),
              Text(
                'StockChef',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Image.asset('assets/intro.png', width: size.width * .8),
          Text(texts['intro'][0]),
          const LanguageSwitch(),
          const ThemeSwitch()
        ],
      ),
    );
  }
}
