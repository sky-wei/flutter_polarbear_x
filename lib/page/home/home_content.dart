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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/sub_title_widget.dart';
import 'package:flutter_svg/svg.dart';

class HomeContent extends StatefulWidget {

  const HomeContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Sky");
    _userNameController = TextEditingController(text: "Sky");
    _passwordController = TextEditingController(text: "******");
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: appWindow.titleBarHeight + 40, right: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubListWidget(
                  title: 'ITEM INFORMATION',
                  children: [
                    SubItemWidget(
                      controller: _nameController,
                      title: 'Name',
                    ),
                    const SubItemLine(),
                    SubItemWidget(
                      controller: _userNameController,
                      title: 'UserName',
                    ),
                    const SubItemLine(),
                    SubItemWidget(
                      controller: _passwordController,
                      title: 'Password',
                    ),
                  ],
                ),
                XBox.vertical30,
                SubListWidget(
                  title: 'ITEM INFORMATION',
                  children: [
                    SubItemWidget(
                      controller: _nameController,
                      title: 'Name',
                    ),
                  ],
                )
              ],
            ),
          ),
          XBox.horizontal20,
          _buildMenuList()
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Padding(
      padding: EdgeInsets.only(top: 26),
      child: Material(
        color: XColor.white,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              XBox.vertical10,
              IconButton(
                  onPressed: () { },
                  tooltip: 'Edit',
                  icon: SvgPicture.asset(
                    'assets/svg/ic_edit.svg',
                    color: XColor.black,
                    width: 20,
                  )
              ),
              XBox.vertical10,
              IconButton(
                  onPressed: () { },
                  tooltip: 'Copy',
                  icon: SvgPicture.asset(
                    'assets/svg/ic_copy.svg',
                    color: XColor.black,
                    width: 20,
                  )
              ),
              XBox.vertical10,
              IconButton(
                  onPressed: () { },
                  tooltip: 'Delete',
                  icon: SvgPicture.asset(
                    'assets/svg/ic_delete.svg',
                    color: XColor.deleteColor,
                    width: 20,
                  )
              ),
              XBox.vertical10,
            ],
          ),
        ),
      ),
    );
  }
}

class SubListWidget extends StatelessWidget {
  
  final String title;
  final List<Widget> children;

  const SubListWidget({
    Key? key,
    required this.title,
    this.children = const <Widget>[]
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleWidget(title: title),
        XBox.vertical10,
        Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 15),
            child: Column(
              children: children,
            ),
          )
        )
      ],
    );
  }
}

class SubItemWidget extends StatelessWidget {

  final String title;
  final TextEditingController? controller;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const SubItemWidget({
    Key? key,
    required this.title,
    this.controller,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XBox.vertical5,
        Text(
          title,
          style: const TextStyle(
            color: XColor.grayColor
          ),
        ),
        XBox.vertical5,
        SizedBox(
          width: double.infinity,
          height: 32,
          child: TextField(
            controller: controller,
            autofocus: autofocus,
            decoration: const InputDecoration(
              border: InputBorder.none
            ),
            maxLines: 1,
            textInputAction: textInputAction,
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly,
          ),
        )
      ],
    );
  }
}

class SubItemLine extends StatelessWidget {

  const SubItemLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 24,
      thickness: 1,
    );
  }
}
