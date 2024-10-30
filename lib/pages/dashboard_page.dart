import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return HelperClass(
              mobile: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .8,
                  child: const Placeholder(),
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
