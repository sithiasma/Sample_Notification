// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sample_notification/utils.dart';

class TextFieldLabel extends StatelessWidget {
  TextFieldLabel({super.key, required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 22, top: 20, bottom: 10),
      child: Text(
        title,
        style: safeGoogleFont(
          'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4285714286,
          letterSpacing: 0.28,
          color: const Color(0xff2a232d),
        ),
      ),
    );
  }
}
