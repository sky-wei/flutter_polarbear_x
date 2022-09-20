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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../data/item/theme_item.dart';
import '../data/repository/app_setting.dart';
import '../generated/l10n.dart';
import '../route.dart';
import '../theme/theme.dart';
import '../util/app_navigator_observer.dart';
import 'model/app_mobile_model.dart';
import 'page/home/main_page.dart';
import 'page/lock/lock_page.dart';
import 'page/login/login_page.dart';
import 'page/splash/splash_page.dart';
import 'widget/monitor_widget.dart';

class PolarBearMobileX extends StatelessWidget {

  final AppSetting appSetting;

  const PolarBearMobileX({
    Key? key,
    required this.appSetting
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppMobileModel(appSetting: appSetting)),
      ],
      child: MaterialApp(
        title: 'PasswordX',
        theme: XTheme.lightTheme(),
        darkTheme: XTheme.darkTheme(),
        themeMode: _getThemeMode(),
        debugShowCheckedModeBanner: false,
        routes: {
          XRoute.splash: (context) => const SplashPage(),
          XRoute.login: (context) => const LoginPage(),
          XRoute.home: (context) => const MainPage(),
          XRoute.lock: (context) => const LockPage(),
        },
        builder: (context, child) => MonitorWidget(child: child),
        initialRoute: XRoute.splash,
        locale: appSetting.getLocale(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        navigatorObservers: [AppNavigatorObserver()],
      ),
    );
  }

  /// 获取主题模式
  ThemeMode _getThemeMode() {
    final mode = appSetting.getDarkMode(ThemeItem.system);
    return ThemeItem.light == mode ? ThemeMode.light : ThemeItem.dark == mode ? ThemeMode.dark : ThemeMode.system;
  }
}

