/*
 * Copyright (c) 2022 The sky Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';

class BigInputWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String iconName;
  final String? labelText;
  final bool autofocus;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final int maxLines;

  const BigInputWidget({
    Key? key,
    this.controller,
    required this.iconName,
    this.labelText,
    this.autofocus = false,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 46,
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SvgPicture.asset(
              'assets/svg/$iconName',
              color: XColor.grayColor,
              width: 22,
              height: 22,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: 15
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 23)
        ),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}

