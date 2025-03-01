import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/language_switch.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageSwitch()],
      ),
      body: HelperClass(
        mobile: IntroBody(
          pageController: _pageController,
          currentPage: _currentPage,
          imageWidth: .5,
        ),
        tablet: IntroBody(
          pageController: _pageController,
          currentPage: _currentPage,
          imageWidth: .3,
        ),
        desktop: IntroBody(
          pageController: _pageController,
          currentPage: _currentPage,
          imageWidth: .2,
        ),
        paddingWidth: size.width * 0.1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

// ignore: must_be_immutable
class IntroBody extends ConsumerWidget {
  final PageController pageController;
  int currentPage;
  final double imageWidth;

  IntroBody(
      {super.key,
      required this.pageController,
      required this.currentPage,
      required this.imageWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode theme = ref.watch(themeNotifierProvider);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (Theme.of(context).brightness == Brightness.dark)
                    Container(
                      width: 71,
                      height: 71,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Image.asset(
                    'assets/logo.png',
                    color: theme == ThemeMode.light
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
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
          Image.asset(
              theme == ThemeMode.light
                  ? 'assets/intro1.png'
                  : 'assets/intro2.png',
              width: size.width * imageWidth),
          Column(
            children: [
              SizedBox(
                width: size.width * .8,
                height: 80,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: texts['intro'].length - 1,
                  onPageChanged: (index) {
                    currentPage = index;
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        texts['intro'][index],
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: pageController,
                count: texts['intro'].length - 5,
                effect: WormEffect(
                  dotHeight: 7,
                  dotWidth: 10,
                  activeDotColor:
                      ref.watch(themeNotifierProvider) == ThemeMode.dark
                          ? darkTheme.colorScheme.primary
                          : lightTheme.colorScheme.primary,
                  dotColor: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: DefaultButton(
              text: texts['intro'][3],
              action: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(texts['intro'][4]),
              ),
              TextButton(
                onPressed: () {},
                child: Text(texts['intro'][5]),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// class DefaultPage extends ConsumerWidget {
//   const DefaultPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final Size size = MediaQuery.sizeOf(context);
//     ThemeMode theme = ref.watch(themeNotifierProvider);
//     Map texts = ref.watch(languageNotifierProvider)['texts'];
//     return Scaffold(
//       appBar: AppBar(),
//       bottomNavigationBar: DefaultBottomAppBar(texts: texts),
//       drawer: DefaultDrawer(theme: theme, texts: texts),
//       body: HelperClass(
//         mobile: const Text('Page'),
//         tablet: const Placeholder(),
//         desktop: const Placeholder(),
//         paddingWidth: size.width * .1,
//         bgColor: Theme.of(context).colorScheme.surface,
//       ),
//     );
//   }
// }
