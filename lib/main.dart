import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_polarbear_x/page/launcher/launcher_page.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'model/app_model.dart';

void main() {
  runApp(const PolarBearX());
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
        title: 'PolarBearX',
        theme: XTheme.lightTheme(),
        darkTheme: XTheme.darkTheme(),
        debugShowCheckedModeBanner: false,
        routes: {
          XRoute.splash: (BuildContext context) => const LauncherPage(),
          // XRoute.login: (BuildContext context) => const LoginPage(),
          // XRoute.register: (BuildContext context) => const RegisterPage(),
          // XRoute.home: (BuildContext context) => const HomePage(),
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

