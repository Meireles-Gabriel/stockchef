import 'package:flutter/material.dart';

class DefaultDrawerButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? action;
  const DefaultDrawerButton(
      {super.key,
      required this.action,
      required this.text,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: .5, vertical: .1),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: action,
          style: ButtonStyle(
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surface,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Icon(
                icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
