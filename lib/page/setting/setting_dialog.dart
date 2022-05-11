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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingDialog extends StatelessWidget {

  static const double _defaultElevation = 24.0;
  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  const SettingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final EdgeInsets effectivePadding = MediaQuery.of(context).viewInsets + EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);//(insetPadding ?? EdgeInsets.zero);
    return AnimatedPadding(
      padding: effectivePadding,
      duration: Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(width: 900, height: 700),
            child: Material(
              color: dialogTheme.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
              elevation: dialogTheme.elevation ?? _defaultElevation,
              shape: dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              clipBehavior: Clip.none,
              child: Text('AA'),
            ),
          ),
        ),
      ),
    );
  }
}

// class _SettingPageState extends State<SettingPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: 1000,
//         height: 800,
//         child: Text('AA'),
//       ),
//     );
//   }
// }

