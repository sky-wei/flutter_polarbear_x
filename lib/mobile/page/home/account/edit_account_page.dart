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
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';


class EditAccountPage extends StatefulWidget {

  final bool editState;
  final AccountItem account;

  const EditAccountPage({
    Key? key,
    this.editState = true,
    required this.account
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ActionMenuWidget(
          iconName: 'ic_back.svg',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.of(context).editItem),
        titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _saveAccount(),
            child: Text(S.of(context).save)
          )
        ],
        backgroundColor: Theme.of(context).dialogBackgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 保存
  void _saveAccount() {

  }
}

