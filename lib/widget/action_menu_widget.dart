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

class ActionMenuWidget extends StatelessWidget {

  final String iconName;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const ActionMenuWidget({
    Key? key,
    required this.iconName,
    this.iconColor,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        'assets/svg/$iconName',
        width: 22,
        height: 22,
        color: iconColor ?? Theme.of(context).iconColor,
      )
    );
  }
}

