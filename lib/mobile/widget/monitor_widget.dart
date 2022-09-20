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
import 'package:provider/provider.dart';

import '../model/app_mobile_model.dart';

class MonitorWidget extends StatefulWidget {

  final Widget? child;

  const MonitorWidget({
    Key? key,
    required this.child
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _MonitorWidgetState();
}

class _MonitorWidgetState extends State<MonitorWidget> {

  late AppMobileModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppMobileModel>();
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _appModel.updateMonitorTime(),
      child: widget.child,
    );
  }
}


