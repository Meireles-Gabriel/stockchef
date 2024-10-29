import 'package:flutter/material.dart';
import 'package:stockchef/utilities/auth_services.dart';
import 'package:stockchef/widgets/default_button.dart';

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('Sell Page'),
            DefaultButton(
                text: 'Log Out',
                action: () {
                  AuthServices().logOut(context);
                })
          ],
        ),
      ),
    );
  }
}
