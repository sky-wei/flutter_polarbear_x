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

class RestartWidget extends StatefulWidget {

  final Widget child;

  const RestartWidget({
    Key? key,
    required this.child
  }) : super(key: key);

  static void restartApp(BuildContext context) {
    //查找顶层_RestartWidgetState并重启
    context.findAncestorStateOfType<_RestartState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() => _RestartState();
}


class _RestartState extends State<RestartWidget> {

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();//重新生成key导致控件重新build
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
