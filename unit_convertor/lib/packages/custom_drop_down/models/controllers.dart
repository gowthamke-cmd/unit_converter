part of '../custom_dropdown.dart';
/// Controller for handling a single selected value.
/// Extends [ValueNotifier] so UI can listen to changes.
class SingleSelectController<T> extends ValueNotifier<T?> {
  /// Initializes the controller with an optional starting value.
  SingleSelectController(super._value);

  /// Clears the current selection (sets value to `null`).
  void clear() {
    value = null;
  }

  /// Returns true if there is a selected value.
  bool get hasValue => value != null;
}

/// Controller for handling multiple selected values.
/// Uses a [List] of generic type `T`.
class MultiSelectController<T> extends ValueNotifier<List<T>> {
  /// Initializes the controller with an initial list of values.
  MultiSelectController(super._value);

  /// Adds a value to the selection list.
  void add(T valueToAdd) {
    value = <T>[...value, valueToAdd];
  }

  /// Removes a value from the selection list.
  void remove(T valueToRemove) {
    value = value.where((T value) => value != valueToRemove).toList();
  }

  /// Clears all selected values.
  void clear() {
    value = <T>[];
  }

  /// Returns true if there is at least one selected value.
  bool get hasValues => value.isNotEmpty;
}
