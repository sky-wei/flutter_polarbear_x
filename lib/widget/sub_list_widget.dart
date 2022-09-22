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
import 'package:flutter_polarbear_x/util/size_box_util.dart';

import 'sub_title_widget.dart';

class SubListWidget extends StatelessWidget {

  final String? title;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;

  const SubListWidget({
    Key? key,
    this.title,
    this.padding,
    this.children = const <Widget>[]
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) SubTitleWidget(title: title!),
        if (title != null) XBox.vertical15,
        Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            )
        )
      ],
    );
  }
}

