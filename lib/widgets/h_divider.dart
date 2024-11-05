import 'package:flutter/material.dart';

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
          width: 10,
        ),
        Text(texts['login'][5]),
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          child: Divider(),
        )
      ],
    );
  }
}
