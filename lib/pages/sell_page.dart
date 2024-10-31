import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/widgets/default_button.dart';

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
          return HelperClass(
              mobile: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: 80,
                      child: DefaultButton(
                        text: 'Pay',
                        action: () {
                          try {} catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                      ),
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
