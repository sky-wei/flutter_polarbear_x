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
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';

class InputDialog extends StatelessWidget {

  final String title;
  final String? labelText;
  final String value;
  final int maxLines;
  final bool obscureText;
  final String? tips;

  const InputDialog({
    Key? key,
    required this.title,
    this.labelText,
    this.value = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.tips
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: InputWidget(
          title: title,
          labelText: labelText,
          value: value,
          maxLines: maxLines,
          obscureText: obscureText,
          tips: tips,
        ),
      ),
    );
  }
}

class InputWidget extends StatefulWidget {

  final String title;
  final String? labelText;
  final String value;
  final int maxLines;
  final bool obscureText;
  final String? tips;

  const InputWidget({
    Key? key,
    required this.title,
    this.labelText,
    this.value = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.tips
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => InputWidgetState();
}

class InputWidgetState extends State<InputWidget> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
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
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical10,
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: widget.labelText,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))
                    )
                ),
                maxLines: widget.maxLines,
                obscureText: widget.obscureText,
                textInputAction: widget.maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: widget.maxLines > 1 ? TextInputType.multiline : TextInputType.text,
                onSubmitted: (value) => _ok(),
              ),
              if (widget.tips != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text(
                    widget.tips!,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 12
                    ),
                  ),
                ),
            ],
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
    final double height = PlatformUtil.isMobile() ? 18 : 26;
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, height, 20, height))
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
