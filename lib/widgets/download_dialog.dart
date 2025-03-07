// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stockchef/widgets/default_button.dart';
import 'package:stockchef/widgets/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

void downloadDialog(BuildContext context, Map texts) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          texts['download'][0],
        ),
        content: SizedBox(
          height: 160,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  texts['download'][1],
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultButton(
                  text: texts['download'][2],
                  action: () async {
                    Uri url = Uri.parse(
                        'https://drive.google.com/file/d/1TY3iy6O8PyMTg5aBLmnmcOODmoTx2QBd/view?usp=sharing');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      showSnackBar(context, texts['download'][4]);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(texts['download'][3]),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
