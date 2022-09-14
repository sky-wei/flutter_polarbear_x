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
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';

class BigInputWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String iconName;
  final EdgeInsetsGeometry? iconPadding;
  final String? labelText;
  final bool autofocus;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final int maxLines;
  final Size? size;
  final Radius? radius;
  final FocusNode? focusNode;
  final String? actionIconName;
  final VoidCallback? actionPressed;

  const BigInputWidget({
    Key? key,
    this.controller,
    required this.iconName,
    this.iconPadding,
    this.labelText,
    this.autofocus = false,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.size,
    this.radius,
    this.focusNode,
    this.actionIconName,
    this.actionPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = this.size ?? const Size(double.infinity, 46);
    final radius = this.radius ?? const Radius.circular(6);

    final iconPadding = this.iconPadding ?? (
        PlatformUtil.isMobile() ?
        const EdgeInsets.fromLTRB(14, 0, 14, 0) :
        const EdgeInsets.fromLTRB(10, 0, 10, 0)
    );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        obscureText: obscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: iconPadding,
            child: SvgPicture.asset(
              'assets/svg/$iconName',
              color: Theme.of(context).hintColor,
              width: 22,
              height: 22,
            ),
          ),
          suffixIcon: actionIconName != null ? IconButton(
            onPressed: actionPressed,
            icon: SvgPicture.asset(
              'assets/svg/$actionIconName',
              color: Theme.of(context).hintColor,
              width: 22,
              height: 22,
            )
          ) : null,
          // labelText: labelText,
          hintStyle: const TextStyle(
              fontSize: 15
          ),
          hintText: labelText,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(radius)
          ),
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

