// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sample_notification/utils.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget(
      {super.key,
      required this.bgColor,
      required this.title,
      required this.buttonColor,
      required this.onTap});
  Color bgColor;
  String title;
  ValueGetter onTap;
  Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: MediaQuery.of(context).size.width * 0.89,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: safeGoogleFont(
                'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.365,
                color: buttonColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
