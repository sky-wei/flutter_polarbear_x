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

class FadeAnimateWidget extends AnimatedBuilder {

  FadeAnimateWidget({Key? key,
    required Animation<double> animation,
    Widget? child
  }) : super(key: key, animation: animation, builder: (context, child) {

    final curvedAnimation = CurvedAnimation(
        parent: animation, curve: Curves.easeOut
    );
    final tween = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(curvedAnimation);

    return FadeTransition(
      opacity: tween,
      child: child,
    );
  }, child: child);
}

