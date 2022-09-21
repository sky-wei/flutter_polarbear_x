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
import 'package:flutter_polarbear_x/data/item/action_item.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';

class SubTextWidget extends StatelessWidget {

  final String? title;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final int maxLines;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<ActionItem>? onAction;
  final bool readOnly;
  final bool obscureText;
  final List<ActionItem> actions;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const SubTextWidget({
    Key? key,
    this.title,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.maxLines = 1,
    this.hintText,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = true,
    this.obscureText = false,
    this.onEditingComplete,
    this.onSubmitted,
    this.actions = const <ActionItem>[],
    this.onAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) XBox.vertical5,
        if (title != null)
          Text(
            title!,
            style: TextStyle(
                color: Theme.of(context).hintColor
            ),
          ),
        XBox.vertical5,
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxLines == 1 ? 32 : 130,
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  maxLines: maxLines,
                  textInputAction: textInputAction,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  obscureText: obscureText,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
            actions.isEmpty ? XBox.horizontal15 : XBox.horizontal60,
            for (var action in actions)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () { if (onAction != null) onAction!(action); },
                    tooltip: action.name,
                    icon: SvgPicture.asset(
                        action.icon,
                        color: Theme.of(context).iconColor,
                        width: 20
                    )
                ),
              ),
            if (actions.isNotEmpty) XBox.horizontal10,
          ],
        ),
      ],
    );
  }
}
