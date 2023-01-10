
/*
 * Copyright (c) 2023 The sky Authors.
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

import 'dart:collection';


typedef BuildComponent = XComponent Function(XComponentManager componentManager);


abstract class XInitialize {

  void initialize();
}


abstract class XDisposable {

  void dispose();
}


abstract class XComponent implements XInitialize, XDisposable {

}


class AbstractComponent implements XComponent {

  @override
  void initialize() {
  }

  @override
  void dispose() {
  }
}


abstract class XComponentManager implements XInitialize, XDisposable {

  bool isDispose();

  T getComponent<T extends XComponent>(String name);

  bool hasComponent(String name);
}


class ComponentManager implements XComponentManager {

  final Map<String, XComponentAdapter> _adapterCache = HashMap();
  var _dispose = false;

  @override
  void initialize() {
  }

  @override
  void dispose() {
    for (var name in _adapterCache.keys.toList()) {
      unregisterComponent(name);
    }
    _dispose = true;
  }

  @override
  T getComponent<T extends XComponent>(String name) {

    if (isDispose()) {
      throw ComponentException();
    }

    var adapter = _adapterCache[name];

    if (adapter == null) {
      throw ComponentException('没有找到 $name 组件！');
    }

    if (!adapter.isCreateComponent()) {
      // 创建组件
      adapter.createComponent();
    }

    return adapter.getComponentInstance() as T;
  }

  @override
  bool hasComponent(String name) {
    return _adapterCache.containsKey(name);
  }

  @override
  bool isDispose() {
    return _dispose;
  }

  void registerComponent({
    required String name,
    required XComponent component
  }) {

    if (hasComponent(name)) {
      throw ComponentException('$name 组件已经存在！');
    }

    _adapterCache[name] = ComponentAdapter(
        key: name,
        component: component
    );
  }

  void registerLazyComponent({
    required String name,
    required BuildComponent builder
  }) {

    if (hasComponent(name)) {
      throw ComponentException('$name 组件已经存在！');
    }

    _adapterCache[name] = LazyComponentAdapter(
        componentManager: this,
        key: name,
        builder: builder
    );
  }

  void unregisterComponent(String name) {
    final adapter = _adapterCache.remove(name);
    if (adapter != null) {
      adapter.dispose();
    }
  }
}


abstract class XComponentAdapter implements XDisposable {

  String getComponentKey();

  bool isCreateComponent();

  void createComponent();

  XComponent getComponentInstance();
}

class ComponentAdapter extends XComponentAdapter {

  final String key;
  final XComponent component;

  ComponentAdapter({
    required this.key,
    required this.component
  });

  @override
  void createComponent() {
  }

  @override
  void dispose() {
    component.dispose();
  }

  @override
  XComponent getComponentInstance() {
    return component;
  }

  @override
  String getComponentKey() {
    return key;
  }

  @override
  bool isCreateComponent() {
    return true;
  }
}

class LazyComponentAdapter extends XComponentAdapter {

  final XComponentManager componentManager;
  final String key;
  final BuildComponent builder;

  XComponent? _component;

  LazyComponentAdapter({
    required this.componentManager,
    required this.key,
    required this.builder,
  });

  @override
  void createComponent() {

    if (isCreateComponent()) {
      // 已经创建不需要处理
      return;
    }

    // 创建组件
    final component = builder(componentManager);
    component.initialize();
    _component = component;
  }

  @override
  XComponent getComponentInstance() {
    if (!isCreateComponent()) {
      throw ComponentException('$key 组件未创建！');
    }
    return _component!;
  }

  @override
  String getComponentKey() {
    return key;
  }

  @override
  bool isCreateComponent() {
    return _component != null;
  }

  @override
  void dispose() {
    _component?.dispose();
    _component = null;
  }
}


class ComponentException implements Exception {

  final dynamic message;

  ComponentException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

