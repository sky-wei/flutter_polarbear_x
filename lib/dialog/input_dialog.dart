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
import '../util/size_box_util.dart';

class InputDialog extends StatelessWidget {

  const InputDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
        width: 400,
        child: InputWidget(),
      ),
    );
  }
}

class InputWidget extends StatefulWidget {

  const InputWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InputWidgetState();
}

class InputWidgetState extends State<InputWidget> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        XBox.vertical30,
        // Text(
        //   'Input',
        //   style: const TextStyle(
        //       color: XColor.grayColor
        //   ),
        // ),
        XBox.vertical10,
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
          child: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'Input',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))
                )
            ),
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: TextInputType.text,
          ),
        ),
        const Divider(thickness: 1),
        Row(
          children: [
            Expanded(
              child: _buildTextButton(
                  text: S.of(context).cancel,
                  onPressed: _cancel
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
                  onPressed: _ok
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
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 30, 20, 30))
      ),
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _ok() {
    Navigator.pop(context, _controller.text);
  }
}
