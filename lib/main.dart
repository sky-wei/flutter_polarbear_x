import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/page/home/home_page.dart';
import 'package:flutter_polarbear_x/page/launcher/launcher_page.dart';
import 'package:flutter_polarbear_x/page/lock/lock_page.dart';
import 'package:flutter_polarbear_x/page/setting/preference_widget.dart';
import 'package:flutter_polarbear_x/page/splash/splash_page.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:flutter_polarbear_x/util/logger.dart';
import 'package:flutter_polarbear_x/widget/monitor_widget.dart';
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
        child: PolarBearX(appSetting: appSetting)
      )
    );
  });
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(1300, 800);
    win.size = const Size(1500, 1000);
    win.alignment = Alignment.center;
    win.title = 'PasswordX';
    win.show();
  });
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
        navigatorObservers: [_MyNavigatorObserver()],
      ),
    );
  }

  /// 获取主题模式
  ThemeMode _getThemeMode() {
    final mode = appSetting.getDarkMode(ThemeItem.system);
    return ThemeItem.light == mode ? ThemeMode.light : ThemeItem.dark == mode ? ThemeMode.dark : ThemeMode.system;
  }
}


class RestartWidget extends StatefulWidget {

  final Widget child;

  const RestartWidget({
    Key? key,
    required this.child
  }) : super(key: key);

  static void restartApp(BuildContext context) {
    //查找顶层_RestartWidgetState并重启
    context.findAncestorStateOfType<_RestartState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() => _RestartState();
}


class _RestartState extends State<RestartWidget> {

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();//重新生成key导致控件重新build
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}


class _MyNavigatorObserver extends NavigatorObserver {

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    XLog.d('>>>>>>>>>>>> didPush $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    XLog.d('>>>>>>>>>>>> didPop $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    XLog.d('>>>>>>>>>>>> didRemove $route');
  }
}

