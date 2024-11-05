import 'package:flutter/material.dart';

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
          height: 10,
        ),
        Text(texts['login'][5]),
        const SizedBox(
          height: 10,
        ),
        const Expanded(
          child: VerticalDivider(),
        )
      ],
    );
  }
}
