// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sample_notification/utils.dart';

class FormTextFieldWidget extends StatelessWidget {
  FormTextFieldWidget(
      {super.key,
      required this.controller,
      required this.placeholder,
      required this.inputType,
      required this.avatar});
  TextEditingController controller;
  String placeholder;
  String avatar;
  TextInputType inputType;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.89,
      child: FormBuilderTextField(
        keyboardType: inputType,
        name: 'Title',
        controller: controller,
        readOnly: controller.text.length == 10 ? true : false,
        style: safeGoogleFont(
          'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4285714286,
          letterSpacing: 0.28,
          color: const Color(0xff2a232d),
        ),
        decoration: InputDecoration(
            prefixIconConstraints:
                const BoxConstraints(minWidth: 15, minHeight: 20),
            prefixIcon: avatar == ''
                ? Container(
                    width: 10,
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      avatar,
                      width: 15,
                      height: 20,
                    ),
                  ),
            fillColor: Colors.grey.shade100,
            filled: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none),
            hintText: placeholder,
            hintStyle: safeGoogleFont(
              'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4285714286,
              letterSpacing: 0.28,
            ),
            contentPadding: const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
      ),
    );
  }
}
