// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:vdom/helpers.dart' as vdom;
import 'package:liquid/liquid.dart';
import 'package:liquid/forms.dart';

class Item {
  static int __nextId = 0;
  final int id;
  String text;

  Item([this.text = '']) : id = __nextId++;
}

final vTodoItem = vStaticTreeFactory(({item}) => vdom.li()(item.text));
final vTodoList = vStaticTreeFactory(({items}) {
  return vdom.ul()(items.map((i) => vTodoItem(key: i.id, item: i)).toList());
});

class TodoApp extends Component<DivElement> {
  @property List<Item> items;
  String inputText = '';

  void create() {
    super.create();
    _initEventListeners();
  }

  void _initEventListeners() {
    element.onClick.matches('.add-button').listen((e) {
      if (inputText.isNotEmpty) {
        _addItem(inputText);
        inputText = '';
        invalidate();
      }
      e.preventDefault();
      e.stopPropagation();
    });

    element.onChange.matches('input').listen((e) {
      InputElement element = e.matchingTarget;
      inputText = element.value;
      e.stopPropagation();
    });
  }

  void _addItem(String text) {
    items.add(new Item(text));
  }

  build() {
    return vRoot()([
      vdom.h2()('TODO'),
      vTodoList(items: items),
      vdom.form()([
        vTextInput(value: inputText),
        vdom.button(classes: ['add-button'])('Add item')
      ])
    ]);
  }
}

main() {
  injectComponent(new TodoApp()..items = [], document.body);
}
