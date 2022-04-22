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

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/theme/color.dart';

import '../../widget/head_logo_widget.dart';
import 'home_user_info.dart';

class HomeSide extends StatefulWidget {

  const HomeSide({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSideState();
}

class _HomeSideState extends State<HomeSide> {
  
  @override
  Widget build(BuildContext context) {

    // Theme.of(context).copyWith()

    return Container(
      color: const Color(0xFF222530),
      // color: Theme.of(context).backgroundColor,
      constraints: const BoxConstraints.expand(width: 260),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: XColor.white
        ),
        child: Column(
          children: const [
            HeadLogoWidget(),
            HomeUserInfoWidget(),
          ],
        ),
      ),
    );
  }
}

