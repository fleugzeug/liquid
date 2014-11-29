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

class TodoItem extends Component<LIElement> {
  Item item;

  TodoItem(Context context, this.item) : super(context);

  void create() {
    element = new LIElement();
  }

  void updateProperties(Item newItem) {
    if (item.text != newItem.text) {
      item = newItem;
      update();
    }
  }

  build() => new VRootElement([vdom.t(item.text)]);
}

class VTodoItem extends VComponentBase<TodoItem, LIElement> {
  Item item;
  VTodoItem(Object key, this.item) : super(key);

  void create(Context context) {
    component = new TodoItem(context, item);
    ref = component.element;
  }

  void update(VTodoItem other, Context context) {
    super.update(other, context);
    component.updateProperties(other.item);
  }
}

class TodoList extends Component<UListElement> {
  List<Item> items;

  TodoList(Context context, this.items) : super(context);

  void create() {
    element = new UListElement();
  }

  build() => new VRootElement(items.map((i) => new VTodoItem(i.id, i)).toList());
}

class VTodoList extends VComponentBase<TodoList, UListElement> {
  List<Item> items;

  VTodoList(Object key, this.items) : super(key);

  void create(Context context) {
    component = new TodoList(context, items);
    ref = component.element;
  }

  void update(VTodoList other, Context context) {
    super.update(other, context);
    component.update();
  }
}

class TodoApp extends Component<DivElement> {
  final List<Item> items;
  String inputText = '';

  TodoApp(Context context, this.items) : super(context);

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
    return new VRootElement([
      vdom.h3(0, [vdom.t('TODO')]),
      new VTodoList(1, this.items),
      vdom.form(2, [
        new TextInput(0, value: inputText),
        vdom.button(1, [vdom.t('Add item')], classes: ['add-button'])
        ])
      ]);
  }
}

main() {
  injectComponent(new TodoApp(null, []), document.body);
}
