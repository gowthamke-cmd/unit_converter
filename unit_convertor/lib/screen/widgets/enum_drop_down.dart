import '../../router/path_exporter.dart';

/// A generic dropdown widget for any [Enum] type with custom builders.
///
/// This widget wraps [CustomDropdown] and adds:
/// - Customizable labels for items and header.
/// - Optional search functionality.
/// - Constrained width.
/// - Built-in validators.
///
/// Example usage:
/// ```dart
/// EnumDropdown<MyEnum>(
///   items: MyEnum.values,
///   selectedItem: MyEnum.firstValue,
///   onChanged: (value) => print(value),
///   itemLabelBuilder: (item) => item.name,
///   headerLabelBuilder: (item) => "Selected: ${item.name}",
/// )
/// ```
class EnumDropdown<T extends Enum> extends StatelessWidget {
  /// Creates an [EnumDropdown].
  ///
  /// [items], [onChanged], [itemLabelBuilder], and [headerLabelBuilder]
  /// must not be null.
  const EnumDropdown({
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    required this.headerLabelBuilder,
    super.key,
    this.selectedItem,
    this.hintText,
    this.searchHintText,
    this.validator,
    this.maxWidth,
    this.isSearchFieldRequired = true,
    this.formKey,
  });

  /// List of items to be shown in the dropdown.
  final List<T> items;

  /// Currently selected item in the dropdown.
  final T? selectedItem;

  /// Callback fired when the selected item changes.
  final void Function(T?) onChanged;

  /// Optional validator for form validation.
  final String? Function(T?)? validator;

  /// Placeholder text shown when nothing is selected.
  final String? hintText;

  /// Hint text shown inside the search field.
  final String? searchHintText;

  /// Maximum width for the dropdown. Defaults to `287`.
  final double? maxWidth;

  /// Builds a label for each item in the dropdown list.
  final String Function(T item) itemLabelBuilder;

  /// Builds a label for the currently selected header item.
  final String Function(T selectedItem) headerLabelBuilder;

  /// is search required
  final bool isSearchFieldRequired;

  /// global form-key
  final GlobalKey? formKey;

  @override
  Widget build(BuildContext context) {
    final Widget dropdown = items.length > 5
        ? CustomDropdown<T>.search(
            formKey: formKey,
            initialItem: selectedItem,
            items: items,
            onChanged: onChanged,
            hintText: hintText,
            searchHintText: searchHintText,
            validator: validator,
            hideSelectedFieldWhenExpanded: true,
            excludeSelected: false,
            listItemBuilder:
                (
                  BuildContext ctx,
                  T item,
                  void Function() onSelect,
                {required bool isSelected,}
                ) => _defaultItemBuilder(ctx, item),
            headerBuilder: (BuildContext ctx, T item,  {required bool enabled}) =>
                _defaultHeaderBuilder(ctx, item),
          )
        : CustomDropdown<T>(
            formKey: formKey,
            initialItem: selectedItem,
            items: items,
            onChanged: onChanged,
            hintText: hintText,
            validator: validator,
            hideSelectedFieldWhenExpanded: true,
            excludeSelected: false,
            listItemBuilder:
                (
                  BuildContext ctx,
                  T item,
                  void Function() onSelect,
                {required bool isSelected,}
                ) => _defaultItemBuilder(ctx, item),
            headerBuilder: (BuildContext ctx, T item,   {required bool enabled}) =>
                _defaultHeaderBuilder(ctx, item),
          );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 287),
      child: dropdown,
    );
  }

  /// Default list item builder (used if no custom builder is provided).
  ///
  /// Displays the item label with ellipsis overflow.
  Widget _defaultItemBuilder(BuildContext context, T item) => Row(
      children: <Widget>[
        Expanded(
          child: Text(
            itemLabelBuilder(item),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );

  /// Default header builder (used if no custom builder is provided).
  ///
  /// Displays the selected item label with ellipsis overflow.
  Widget _defaultHeaderBuilder(BuildContext context, T selectedItem) => Text(
      headerLabelBuilder(selectedItem),
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
}
