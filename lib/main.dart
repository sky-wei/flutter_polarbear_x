import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_polarbear_x/page/home/home_page.dart';
import 'package:flutter_polarbear_x/page/launcher/launcher_page.dart';
import 'package:flutter_polarbear_x/page/splash/splash_page.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'model/app_model.dart';

void main() {
  runApp(
    const RestartWidget(
      child: PolarBearX(),
    )
  );
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1500, 1000);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = 'PasswordX';
    win.show();
  });
}

class PolarBearX extends StatelessWidget {

  const PolarBearX({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppModel()),
      ],
      child: MaterialApp(
        title: 'PasswordX',
        theme: XTheme.lightTheme(),
        darkTheme: XTheme.darkTheme(),
        // themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routes: {
          XRoute.splash: (BuildContext context) => const SplashPage(),
          XRoute.launcher: (BuildContext context) => const LauncherPage(),
          XRoute.home: (BuildContext context) => const HomePage(),
        },
        initialRoute: XRoute.splash,
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

