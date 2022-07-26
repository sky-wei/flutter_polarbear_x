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
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';

class BigSearchWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String iconName;
  final String? labelText;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const BigSearchWidget({
    Key? key,
    this.controller,
    required this.iconName,
    this.labelText,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SvgPicture.asset(
              'assets/svg/$iconName',
              color: Theme.of(context).iconColor,
              width: 30,
              height: 30,
            ),
          ),
          labelText: labelText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 23)
        ),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}