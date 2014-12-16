// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of liquid.dynamic;

/// Generic Component VDom Node generated by component factory.
class VGenericComponent extends vdom.VComponent {
  InstanceMirror _instanceMirror;

  ClassMirror _classMirror;
  Map<Symbol, property> _propertyTypes;
  Map<Symbol, dynamic> _properties;

  VGenericComponent(
      this._classMirror,
      this._propertyTypes,
      this._properties,
      Object key,
      List<vdom.VNode> children,
      String id,
      Map<String, String> attributes,
      List<String> classes,
      Map<String, String> styles)
    : super(key, children, id, attributes, classes, styles);

  void create(vdom.Context context) {
    _instanceMirror = _classMirror.newInstance(const Symbol(''), const []);
    component = _instanceMirror.reflectee
      ..context = context;
    if (_properties != null) {
      _properties.forEach((k, v) {
        if (_propertyTypes.containsKey(k)) {
          _instanceMirror.setField(k, v);
        }
      });
    }
    component.create();
    ref = component.element;
  }

  void update(VGenericComponent other, vdom.Context context) {
    super.update(other, context);
    other._instanceMirror = _instanceMirror;

    if (other._properties != null) {
      other._properties.forEach((k, v) {
        final meta = _propertyTypes[k];
        if (meta != null && !meta.immutable) {
          _instanceMirror.setField(k, v);
        }
      });
    }
    component.dirty = true;
    component.internalUpdate();
  }

  String toString() =>
      '<${MirrorSystem.getName(_classMirror.simpleName)} key="$key"/>';
}

/// Factory generated by [componentFactory] method.
class _VGenericComponentFactory extends Function {
  /// Type of the [Component] to instantiate
  Type _componentType;
  ClassMirror _classMirror;
  Map<Symbol, property> _propertyTypes;

  _VGenericComponentFactory(this._componentType) {
    _classMirror = reflectClass(_componentType);
    assert(() {
      final MethodMirror constructor =
          _classMirror.declarations[_classMirror.simpleName];
      if (constructor != null) {
        for (final p in constructor.parameters) {
          if (!p.isOptional) {
            throw 'Component constructors should have optional arguments only.\n'
                  '${MirrorSystem.getName(_classMirror.simpleName)} constructor '
                  'parameter ${MirrorSystem.getName(p.simpleName)} isn\'t an '
                  'optional.';
          }
        }
      }
      return true;
    }());
    final publicVariables = _classMirror.declarations.values.where((d) {
      return !d.isPrivate && d is VariableMirror;
    });
    _propertyTypes = _lookupProperties(publicVariables, false);
  }

  /// Creates a new instance of [VGenericComponent] with [args] properties.
  VGenericComponent _create([Map args]) {
    if (args == null) {
      assert(() {
        _propertyTypes.forEach((k, v) {
          if (v.required) {
            throw '$_componentType component requires to specify '
                  '"${MirrorSystem.getName(k)}" property.';
          }
        });
        return true;
      }());
      return new VGenericComponent(_classMirror, _propertyTypes, null, null,
          null, null, null, null, null);
    }
    final HashMap<Symbol, dynamic> properties = new HashMap.from(args);
    final Object key = properties.remove(#key);
    final List<vdom.VNode> children = properties.remove(#children);
    final String id = properties.remove(#id);
    final Map<String, String> attributes = properties.remove(#attributes);
    final List<String> classes = properties.remove(#classes);
    final Map<String, String> styles = properties.remove(#styles);
    assert(() {
      for (final property in properties.keys) {
        if (!_propertyTypes.containsKey(property)) {
          throw '$_componentType component doesn\'t have a property '
                '"${MirrorSystem.getName(property)}".';
        }
        _propertyTypes.forEach((k, v) {
          if (v.required && !properties.containsKey(k)) {
            throw '$_componentType component requires to specify '
                  '"${MirrorSystem.getName(k)}" property.';
          }
        });
      }
      return true;
    }());
    return new VGenericComponent(_classMirror, _propertyTypes, properties,
        key, children, id, attributes, classes, styles);
  }

  /// It is used to implement variadic arguments.
  VGenericComponent noSuchMethod(Invocation invocation) {
    assert(invariant(invocation.positionalArguments.isEmpty, () =>
        'VComponent factory invocation shouldn\'t have positional arguments.\n'
        'Positional arguments: ${invocation.positionalArguments}'));
    return _create(invocation.namedArguments);
  }

  /// Factory method invoked without any arguments.
  VGenericComponent call() => _create();
}

/// [componentFactory] function generates new factory for [VComponent] vdom
/// nodes.
///
/// [componentFactory] function should be treated as part of Liquid DSL,
/// and it should be invoked only in top-level declarations:
///
/// ```dart
/// final myComponent = componentFactory(MyComponent);
/// class MyComponent extends Component {
///   ...
/// }
/// ```
///
/// When the project is compiled with transformer, call to this function will be
/// transformed into an optimized Class with function to instantiate it.
Function componentFactory(Type componentType) => new _VGenericComponentFactory(componentType);
