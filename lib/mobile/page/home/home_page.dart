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
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

import '../../../generated/l10n.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_add.svg',
              width: 22,
              height: 22,
            )
          )
        ],
        title: Text(S.of(context).appName),
        titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).settingsColor,
      ),
      body: const Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/ic_all_items.svg',
              width: 22,
              height: 22,
            ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/ic_folder.svg',
                width: 22,
                height: 22,
              ),
              label: S.of(context).folder
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/ic_search.svg',
                width: 22,
                height: 22,
              ),
              label: S.of(context).search
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/ic_user.svg',
                width: 22,
                height: 22,
              ),
              label: 'Me'
          ),
        ],
        iconSize: 10,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        currentIndex: _currentIndex,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}

