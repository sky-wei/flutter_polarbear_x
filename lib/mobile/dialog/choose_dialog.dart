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
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/platform_util.dart';

class ChooseDialog extends StatelessWidget {

  final List<ActionItem> actions;

  const ChooseDialog({
    Key? key,
    required this.actions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 150),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: _buildContent(context)
        )
    );
  }

  /// 创建内容
  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildTextButton(
                context: context,
                text: actions[index].name,
                textColor: actions[index].textColor,
                onPressed: () => Navigator.pop(context, index),
              );
            },
            itemCount: actions.length,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
          ),
          const Divider(
            height: 5,
            thickness: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: _buildTextButton(
                context: context,
                text: S.of(context).cancel,
                textColor: Theme.of(context).themeColor,
                onPressed: () => Navigator.pop(context)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextButton({
    required BuildContext context,
    required String text,
    Color? textColor,
    required VoidCallback? onPressed
  }) {
    final double height = PlatformUtil.isMobile() ? 18 : 26;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Theme.of(context).mainTextColor
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(0, height, 0, height))
      ),
    );
  }
}