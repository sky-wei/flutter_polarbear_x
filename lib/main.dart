import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/mobile/polarbear_mobile.dart';
import 'package:flutter_polarbear_x/page/home/home_page.dart';
import 'package:flutter_polarbear_x/page/launcher/launcher_page.dart';
import 'package:flutter_polarbear_x/page/lock/lock_page.dart';
import 'package:flutter_polarbear_x/page/setting/preference_widget.dart';
import 'package:flutter_polarbear_x/page/splash/splash_page.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/app_navigator_observer.dart';
import 'package:flutter_polarbear_x/util/logger.dart';
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_polarbear_x/widget/monitor_widget.dart';
import 'package:flutter_polarbear_x/widget/restart_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';
import 'model/app_model.dart';

void main() {
  initLogger(() async {
    final appSetting = AppSetting(
      await SharedPreferences.getInstance()
    );
    runApp(
      RestartWidget(
        child: PlatformUtil.isPC() ?
        PolarBearX(appSetting: appSetting) :
        PolarBearMobileX(appSetting: appSetting)
      )
    );
  });
  if (PlatformUtil.isPC()) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = const Size(1300, 800);
      win.size = const Size(1500, 1000);
      win.alignment = Alignment.center;
      win.title = 'PasswordX';
      win.show();
    });
  }
  if (PlatformUtil.isMobile()) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );
  }
}

class PolarBearX extends StatelessWidget {

  final AppSetting appSetting;

  const PolarBearX({
    Key? key,
    required this.appSetting
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppModel(appSetting: appSetting)),
      ],
      child: MaterialApp(
        title: 'PasswordX',
        theme: XTheme.lightTheme(),
        darkTheme: XTheme.darkTheme(),
        themeMode: _getThemeMode(),
        debugShowCheckedModeBanner: false,
        routes: {
          XRoute.splash: (context) => const SplashPage(),
          XRoute.launcher: (context) => const LauncherPage(),
          XRoute.home: (context) => const HomePage(),
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

