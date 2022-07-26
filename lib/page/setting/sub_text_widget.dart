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
import 'package:flutter_polarbear_x/util/size_box_util.dart';

import '../../theme/color.dart';

class SubTextWidget extends StatefulWidget {

  final String title;
  final String content;
  final String? action;
  final VoidCallback? onPressed;

  const SubTextWidget({
    Key? key,
    required this.title,
    required this.content,
    this.action,
    this.onPressed
  }) : super(key: key);

  @override
  State createState() => _SubTextState();
}

class _SubTextState extends State<SubTextWidget> {

  bool _actionState = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical15,
        MouseRegion(
          onEnter: (event) { setActionState(true); },
          onExit: (event) { setActionState(false); },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(
                    widget.content
                ),
              ),
              XBox.horizontal30,
              if (widget.action != null && _actionState)
                InkWell(
                  onTap: widget.onPressed,
                  child: Text(
                    widget.action!,
                    style: TextStyle(
                      color: Theme.of(context).themeColor
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  void setActionState(bool show) {
    setState(() {
      _actionState = show;
    });
  }
}

