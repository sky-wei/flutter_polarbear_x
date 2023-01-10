import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/desktop/polarbear_desktop.dart';
import 'package:flutter_polarbear_x/mobile/polarbear_mobile.dart';
import 'package:flutter_polarbear_x/util/logger.dart';
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_polarbear_x/widget/restart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/context.dart';


void main() {

  initLogger(() async {
    final baseContext = BaseContext();
    await baseContext.initialize();
    runApp(
      RestartWidget(
        child: PlatformUtil.isPC() ?
        PolarBearDesktopX(baseContext: baseContext) :
        PolarBearMobileX(baseContext: baseContext)
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
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}

