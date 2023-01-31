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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/core/context.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:provider/provider.dart';


class SplashPage extends StatefulWidget {

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    context.read<AppContext>().initialize().then((value) {
      Navigator.pushReplacementNamed(
          context, kDebugMode ? XRoute.login : XRoute.login
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            S.of(context).loading,
            style: const TextStyle(
                fontSize: 18
            ),
          ),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
      ),
      onWillPop: () => Future.value(false)
    );
  }
}

