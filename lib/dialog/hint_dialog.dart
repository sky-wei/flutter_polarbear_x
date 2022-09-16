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

import '../generated/l10n.dart';
import '../util/platform_util.dart';
import '../util/size_box_util.dart';



class HintDialog extends StatelessWidget {

  final String title;
  final String message;

  const HintDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: _buildContent(context),
      ),
    );
  }

  /// 创建内容
  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        XBox.vertical30,
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical10,
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const Divider(thickness: 1),
        Row(
          children: [
            Expanded(
                child: _buildTextButton(
                    text: S.of(context).cancel,
                    onPressed: () => Navigator.pop(context)
                )
            ),
            XBox.horizontal5,
            const SizedBox(
              width: 1,
              height: 40,
              child: VerticalDivider(thickness: 1),
            ),
            XBox.horizontal5,
            Expanded(
              child: _buildTextButton(
                  text: S.of(context).ok,
                  onPressed: () => Navigator.pop(context, 1)
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback? onPressed
  }) {
    final double height = PlatformUtil.isMobile() ? 18 : 26;
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, height, 20, height))
      ),
    );
  }
}

