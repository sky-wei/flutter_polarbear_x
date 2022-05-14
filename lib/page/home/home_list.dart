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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../widget/big_search_widget.dart';
import 'home_side.dart';

class HomeList extends StatefulWidget {

  const HomeList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  List<DemoItem> _demoItems = [
    DemoItem("Test1", "Sky", DateTime.now()),
    DemoItem("Test2", "Sky", DateTime.now()),
    DemoItem("Test3", "Sky", DateTime.now()),
    DemoItem("Test4", "Sky", DateTime.now()),
    DemoItem("Test5", "Sky", DateTime.now()),
    DemoItem("Test6", "Sky", DateTime.now()),
    DemoItem("Test7", "Sky", DateTime.now()),
    DemoItem("Test8", "Sky", DateTime.now()),
    DemoItem("Test8", "Sky", DateTime.now()),
    DemoItem("Test9", "Sky", DateTime.now()),
    DemoItem("Test10", "Sky", DateTime.now()),
    DemoItem("Test11", "Sky", DateTime.now()),
    DemoItem("Test12", "Sky", DateTime.now()),
    DemoItem("Test13", "Sky", DateTime.now()),
  ];

  DemoItem? _curDemoItem;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColor.listColor,
      constraints: const BoxConstraints.expand(width: 340),
      padding: EdgeInsets.only(top: appWindow.titleBarHeight),
      child: Column(
        children: [
          _buildSearHead(),
          XBox.horizontal20,
          Expanded(
            child: _buildList(),
          )
        ],
      ),
    );
  }

  Widget _buildSearHead() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 26, right: 20, bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: ListSearchWidget(
              iconName: 'ic_search.svg',
              labelText: S.of(context).search,
            ),
          ),
          XBox.horizontal5,
          IconButton(
            onPressed: () {

            },
            icon: SvgPicture.asset(
              'assets/svg/ic_add.svg',
              color: XColor.black,
              width: 20,
              height: 20,
            ),
            tooltip: S.of(context).addAccountTip,
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return ListItemWidget(
          item: _demoItems[index],
          onChoose: _isChooseItem,
          onPressed: _chooseHandler,
        );
      },
      itemCount: _demoItems.length,
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(color: Color(0xFFE7ECF3)),
        );
      },
    );
  }

  bool _isChooseItem(DemoItem item) => _curDemoItem == item;

  void _chooseHandler(DemoItem item) {
    setState(() {
      _curDemoItem = item;
    });
  }
}

class ListItemWidget extends StatelessWidget {

  final DemoItem item;
  final ChooseItem<DemoItem> onChoose;
  final ValueChanged<DemoItem>? onPressed;
  final EdgeInsetsGeometry? padding;

  final DateFormat _dateFormat = DateFormat.yMMMMd();

  ListItemWidget({
    Key? key,
    required this.item,
    required this.onChoose,
    this.onPressed,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final choose = onChoose(item);

    return Padding(
      padding: padding?? const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: XColor.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: choose ? XColor.listChooseColor : XColor.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            splashColor: XColor.listChooseColor,
            highlightColor: XColor.listChooseColor,
            enableFeedback: false,
            borderRadius: BorderRadius.circular(6),
            onTap: () { if (onPressed != null) onPressed!(item); },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          // color: XColor.sideTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                        ),
                      ),
                      XBox.vertical10,
                      Text(
                        item.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: XColor.grayColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                        ),
                      ),
                      XBox.vertical5,
                      Text(
                        _dateFormat.format(item.lastTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: XColor.grayColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  // GestureDetector(
                  //
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListSearchWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String iconName;
  final String? labelText;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const ListSearchWidget({
    Key? key,
    this.controller,
    required this.iconName,
    this.labelText,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SvgPicture.asset(
                'assets/svg/$iconName',
                color: XColor.black,
                width: 12,
                height: 12,
              ),
            ),
            hintText: labelText,
            hintStyle: const TextStyle(
              fontSize: 14
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
        ),
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

class DemoItem {

  final String name;
  final String username;
  final DateTime lastTime;

  DemoItem(this.name, this.username, this.lastTime);
}

