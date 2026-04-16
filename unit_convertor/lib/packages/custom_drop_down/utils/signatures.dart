part of '../custom_dropdown.dart';

/// Signature for building a single list item inside the custom dropdown.
///
/// - [context]: The build context.
/// - [item]: The current data item of type [T].
/// - [isSelected]: Whether the current item is selected.
/// - [onItemSelect]: Callback invoked when this item is selected.
typedef ListItemBuilder<T> =
    Widget Function(
      BuildContext context,
      T item,
      VoidCallback onItemSelect, {
      required bool isSelected,
    });

/// Signature for building the dropdown header when a single item is selected.
///
/// - [context]: The build context.
/// - [selectedItem]: The currently selected item.
/// - [enabled]: Whether the dropdown is enabled or disabled.
typedef HeaderBuilder<T> =
    Widget Function(
      BuildContext context,
      T selectedItem, {
      required bool enabled,
    });

/// Signature for building the dropdown header when multiple items are selected.
///
/// - [context]: The build context.
/// - [selectedItems]: The list of selected items.
/// - [enabled]: Whether the dropdown is enabled or disabled.
typedef HeaderListBuilder<T> =
    Widget Function(
      BuildContext context,
      List<T> selectedItems, {
      required bool enabled,
    });

/// Signature for building the hint widget shown when no item is selected.
///
/// - [context]: The build context.
/// - [hint]: The hint text to display.
/// - [enabled]: Whether the dropdown is enabled or disabled.
typedef HintBuilder =
    Widget Function(BuildContext context, String hint, {required bool enabled});

/// Signature for building a widget displayed when no search results are found.
///
/// - [context]: The build context.
/// - [text]: The message or label to display (e.g., "No results found").
typedef NoResultFoundBuilder =
    Widget Function(BuildContext context, String text);
