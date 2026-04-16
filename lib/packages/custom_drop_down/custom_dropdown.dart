library;

import 'package:unit_convertor/router/path_exporter.dart';
import 'package:flutter/scheduler.dart';

export 'custom_dropdown.dart';

part 'models/controllers.dart';
// models
part 'models/custom_dropdown_decoration.dart';
part 'models/custom_dropdown_list_filter.dart';
part 'models/disabled_decoration.dart';
part 'models/list_item_decoration.dart';
part 'models/search_field_decoration.dart';
// utils
part 'utils/signatures.dart';
// widgets
part 'widgets/animated_section.dart';
part 'widgets/dropdown_field.dart';
part 'widgets/dropdown_overlay/dropdown_overlay.dart';
part 'widgets/dropdown_overlay/widgets/items_list.dart';
part 'widgets/dropdown_overlay/widgets/search_field.dart';
part 'widgets/overlay_builder.dart';
/// A simple data holder for an `id` and a `name`.
class NameId {
  /// Creates a [NameId] with the given [id] and [name].
  NameId({required this.id, required this.name,this.role});

  /// The unique identifier.
  String id;

  /// The display name.
  final String name;

  /// role field
  int? role;
}

enum _DropdownType { singleSelect, multipleSelect }

enum _SearchType { onListData, onRequestData }

const MaterialColor _defaultErrorColor = Colors.red;

const BorderRadius _defaultBorderRadius = BorderRadius.all(Radius.circular(12));

final Border _defaultErrorBorder = Border.all(
  color: _defaultErrorColor,
  width: 1.5,
);

/// custom drop down class
class CustomDropdown<T> extends StatefulWidget {
  /// constructor
  CustomDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.controller,
    this.itemsScrollController,
    this.initialItem,
    this.hintText,
    this.decoration,
    this.validator,
    this.validateOnChange = true,
    this.visibility,
    this.overlayController,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.maxLines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.excludeSelected = true,
    this.enabled = true,
    this.disabledDecoration,
    this.formKey,
  }) : assert(
         initialItem == null || controller == null,
         'Only one of initialItem or controller can be specified at a time',
       ),
       // assert(
       //   initialItem == null || items!.contains(initialItem),
       //   'Initial item must match with one of the item in items list.',
       // ),
       assert(
         controller == null ||
             controller.value == null ||
             items!.contains(controller.value),
         'Controller value must match with one of the item in items list.',
       ),
       _searchType = null,
       _dropdownType = _DropdownType.singleSelect,
       futureRequest = null,
       futureRequestDelay = null,
       noResultFoundBuilder = null,
       noResultFoundText = null,
       searchHintText = null,
       initialItems = null,
       onListChanged = null,
       listValidator = null,
       headerListBuilder = null,
       searchRequestLoadingIndicator = null,
       closeDropDownOnClearFilterSearch = false,
       multiSelectController = null;

  /// custom drop down with search
  CustomDropdown.search({
    required this.items,
    required this.onChanged,
    super.key,
    this.controller,
    this.itemsScrollController,
    this.initialItem,
    this.hintText,
    this.decoration,
    this.visibility,
    this.overlayController,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.disabledDecoration,
    this.formKey,
    this.closeDropDownOnClearFilterSearch = false,
  }) : assert(
         initialItem == null || controller == null,
         'Only one of initialItem or controller can be specified at a time',
       ),
       // assert(
       //   initialItem == null || items!.contains(initialItem),
       //   'Initial item must match with one of the item in items list.',
       // ),
       assert(
         controller == null ||
             controller.value == null ||
             items!.contains(controller.value),
         'Controller value must match with one of the item in items list.',
       ),
       _searchType = _SearchType.onListData,
       _dropdownType = _DropdownType.singleSelect,
       futureRequest = null,
       futureRequestDelay = null,
       initialItems = null,
       onListChanged = null,
       listValidator = null,
       headerListBuilder = null,
       searchRequestLoadingIndicator = null,
       multiSelectController = null;

  /// custom drop sown with search request
  const CustomDropdown.searchRequest({
    required this.futureRequest,
    required this.onChanged,
    super.key,
    this.futureRequestDelay,
    this.initialItem,
    this.items,
    this.controller,
    this.itemsScrollController,
    this.hintText,
    this.decoration,
    this.visibility,
    this.overlayController,
    this.formKey,
    this.searchHintText,
    this.noResultFoundText,
    this.listItemBuilder,
    this.headerBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.validator,
    this.validateOnChange = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.searchRequestLoadingIndicator,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  }) : assert(
         initialItem == null || controller == null,
         'Only one of initialItem or controller can be specified at a time',
       ),
       _searchType = _SearchType.onRequestData,
       _dropdownType = _DropdownType.singleSelect,
       initialItems = null,
       onListChanged = null,
       listValidator = null,
       headerListBuilder = null,
       multiSelectController = null;

  /// custom drop down with multi select
  CustomDropdown.multiSelect({
    required this.items,
    required this.onListChanged,
    super.key,
    this.multiSelectController,
    this.controller,
    this.initialItems,
    this.overlayController,
    this.itemsScrollController,
    this.listValidator,
    this.visibility,
    this.headerListBuilder,
    this.hintText,
    this.decoration,
    this.validateOnChange = true,
    this.listItemBuilder,
    this.hintBuilder,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxLines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.formKey,
    this.enabled = true,
    this.disabledDecoration,
  }) : assert(
         initialItems == null || multiSelectController == null,
         'Only one of initialItems or controller can be specified at a time',
       ),
       assert(
         initialItems == null ||
             initialItems.isEmpty ||
             initialItems.any((T e) => items!.contains(e)),
         'Initial items must match with the items in the items list.',
       ),
       assert(
         multiSelectController == null ||
             multiSelectController.value.isEmpty ||
             multiSelectController.value.any((T e) => items!.contains(e)),
         'Controller value must match with one of the item in items list.',
       ),
       _searchType = null,
       _dropdownType = _DropdownType.multipleSelect,
       initialItem = null,
       noResultFoundText = null,
       validator = null,
       headerBuilder = null,
       onChanged = null,
       excludeSelected = false,
       futureRequest = null,
       futureRequestDelay = null,
       noResultFoundBuilder = null,
       searchHintText = null,
       searchRequestLoadingIndicator = null,
       closeDropDownOnClearFilterSearch = false;

  /// custom drop down with multi search
  CustomDropdown.multiSelectSearch({
    required this.items,
    required this.onListChanged,
    super.key,
    this.multiSelectController,
    this.initialItems,
    this.formKey,
    this.controller,
    this.visibility,
    this.itemsScrollController,
    this.overlayController,
    this.listValidator,
    this.listItemBuilder,
    this.hintBuilder,
    this.decoration,
    this.headerListBuilder,
    this.noResultFoundText,
    this.noResultFoundBuilder,
    this.hintText,
    this.searchHintText,
    this.validateOnChange = true,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.maxLines = 1,
    this.overlayHeight,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.enabled = true,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  }) : assert(
         initialItems == null || multiSelectController == null,
         'Only one of initialItems or controller can be specified at a time',
       ),
       // assert(
       //   initialItems == null ||
       //       initialItems.isEmpty ||
       //       initialItems.any((T e) => items!.contains(e)),
       //   'Initial items must match with the items in the items list.',
       // ),
       assert(
         multiSelectController == null ||
             multiSelectController.value.isEmpty ||
             multiSelectController.value.any((T e) => items!.contains(e)),
         'Controller value must match with one of the item in items list.',
       ),
       _searchType = _SearchType.onListData,
       _dropdownType = _DropdownType.multipleSelect,
       initialItem = null,
       onChanged = null,
       validator = null,
       excludeSelected = false,
       headerBuilder = null,
       futureRequest = null,
       futureRequestDelay = null,
       searchRequestLoadingIndicator = null;

  /// custom drop down with multi search request
  const CustomDropdown.multiSelectSearchRequest({
    required this.futureRequest,
    required this.onListChanged,
    super.key,
    this.multiSelectController,
    this.formKey,
    this.futureRequestDelay,
    this.initialItems,
    this.items,
    this.controller,
    this.itemsScrollController,
    this.overlayController,
    this.visibility,
    this.hintText,
    this.decoration,
    this.searchHintText,
    this.noResultFoundText,
    this.headerListBuilder,
    this.listItemBuilder,
    this.hintBuilder,
    this.noResultFoundBuilder,
    this.listValidator,
    this.validateOnChange = true,
    this.maxLines = 1,
    this.overlayHeight,
    this.searchRequestLoadingIndicator,
    this.closedHeaderPadding,
    this.expandedHeaderPadding,
    this.itemsListPadding,
    this.listItemPadding,
    this.canCloseOutsideBounds = true,
    this.hideSelectedFieldWhenExpanded = false,
    this.enabled = true,
    this.disabledDecoration,
    this.closeDropDownOnClearFilterSearch = false,
  }) : assert(
         initialItems == null || multiSelectController == null,
         'Only one of initialItems or controller can be specified at a time',
       ),
       _searchType = _SearchType.onRequestData,
       _dropdownType = _DropdownType.multipleSelect,
       initialItem = null,
       onChanged = null,
       headerBuilder = null,
       excludeSelected = false,
       validator = null;

  /// The list of items user can select.
  final List<T>? items;

  /// Initial selected item from the list of [items].
  final T? initialItem;

  /// Initial selected items from the list of [items].
  final List<T>? initialItems;

  /// Scroll controller to access items list scroll behavior.
  final ScrollController? itemsScrollController;

  /// Text that suggests what sort of data the dropdown represents.
  ///
  /// Default to "Select value".
  final String? hintText;

  /// Text that suggests what to search in the search field.
  ///
  /// Default to "Search".
  final String? searchHintText;

  /// A method that validates the selected item.
  /// Returns an error string to display as per the validation, or null otherwise.
  final String? Function(T?)? validator;

  /// A method that validates the selected items.
  /// Returns an error string to display as per the validation, or null otherwise.
  final String? Function(List<T>)? listValidator;

  /// Enable the validation listener on item change.
  /// This implies to [validator] everytime when the item change.
  final bool validateOnChange;

  /// Called when the item of the [CustomDropdown] should change.
  final Function(T?)? onChanged;

  /// Called when the list of items of the [CustomDropdown] should change.
  final Function(List<T>)? onListChanged;

  /// Hide the selected item from the [items] list.
  final bool excludeSelected;

  /// Can close [CustomDropdown] overlay by tapping outside.
  /// Here "outside" covers the entire screen.
  final bool canCloseOutsideBounds;

  /// Hide the header field when [CustomDropdown] overlay opened/expanded.
  final bool hideSelectedFieldWhenExpanded;

  /// The asynchronous computation from which the items list returns.
  final Future<List<T>> Function(String)? futureRequest;

  /// Text that notify there's no search results match.
  ///
  /// Default to "No result found.".
  final String? noResultFoundText;

  /// Duration after which the [futureRequest] is to be executed.
  final Duration? futureRequestDelay;

  /// Text maxLines for header and list item text.
  final int maxLines;

  /// Padding for [CustomDropdown] header (closed state).
  final EdgeInsets? closedHeaderPadding;

  /// Padding for [CustomDropdown] header (opened/expanded state).
  final EdgeInsets? expandedHeaderPadding;

  /// Padding for [CustomDropdown] items list.
  final EdgeInsets? itemsListPadding;

  /// Padding for [CustomDropdown] each list item.
  final EdgeInsets? listItemPadding;

  /// Widget to display while search request loading.
  final Widget? searchRequestLoadingIndicator;

  /// [CustomDropdown] opened/expanded area height.
  /// Only applicable if items are greater than 4 otherwise adjust automatically.
  final double? overlayHeight;

  /// The [listItemBuilder] that will be used to build item on demand.
  final ListItemBuilder<T>? listItemBuilder;

  /// The [headerBuilder] that will be used to build [CustomDropdown] header field.
  final HeaderBuilder<T>? headerBuilder;

  /// The [hintBuilder] that will be used to build [CustomDropdown] hint of header field.
  final HintBuilder? hintBuilder;

  /// The [noResultFoundBuilder] that will be used to build area when there's no search results match.
  final NoResultFoundBuilder? noResultFoundBuilder;

  /// The [headerListBuilder] that will be used to build [CustomDropdown] header field.
  final HeaderListBuilder<T>? headerListBuilder;

  /// [CustomDropdown] decoration.
  /// Contain sub-decorations [SearchFieldDecoration], [ListItemDecoration] and [ScrollbarThemeData].
  final CustomDropdownDecoration? decoration;

  /// [CustomDropdown] enabled/disabled state.
  /// If disabled, you can not open the dropdown.
  final bool enabled;

  /// [CustomDropdown] disabled decoration.
  ///
  /// Note: Only applicable if dropdown is disabled.
  final CustomDropdownDisabledDecoration? disabledDecoration;

  /// [CustomDropdown] will close on tap Clear filter for all search
  /// and searchRequest constructors
  final bool closeDropDownOnClearFilterSearch;

  /// The [overlayController] allows you to explicitly handle the [CustomDropdown] overlay states (show/hide).
  final OverlayPortalController? overlayController;

  /// The [controller] that can be used to control [CustomDropdown] selected item.
  final SingleSelectController<T?>? controller;

  /// The [multiSelectController] that can be used to control [CustomDropdown.multiSelect] selected items.
  final MultiSelectController<T>? multiSelectController;

  /// Callback for dropdown [visibility].
  ///
  /// If both [visibility] and [overlayController] are provided, this callback never listens the changes of [overlayController].
  /// You have to explicitly check for [overlayController] visibility states using overlayController.isShowing property.
  final Function({required bool visibility})? visibility;

  final _SearchType? _searchType;

  final _DropdownType _dropdownType;

  /// global form-key
  final GlobalKey? formKey;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink layerLink = LayerLink();
  late SingleSelectController<T?> selectedItemNotifier;
  late MultiSelectController<T> selectedItemsNotifier;
  FormFieldState<(T?, List<T>)>? _formFieldState;

  void _selectedItemListener() {
    widget.onChanged?.call(selectedItemNotifier.value);
    _formFieldState?.didChange((selectedItemNotifier.value, <T>[]));
    if (widget.validateOnChange) {
      _formFieldState?.validate();
    }
  }

  void _selectedItemsListener() {
    widget.onListChanged?.call(selectedItemsNotifier.value);
    _formFieldState?.didChange((null, selectedItemsNotifier.value));
    if (widget.validateOnChange) {
      _formFieldState?.validate();
    }
  }

  @override
  void initState() {
    super.initState();

    selectedItemNotifier =
        widget.controller ?? SingleSelectController<T?>(widget.initialItem);

    selectedItemsNotifier =
        widget.multiSelectController ??
        MultiSelectController<T>(widget.initialItems ?? <T>[]);

    selectedItemNotifier.addListener(_selectedItemListener);

    selectedItemsNotifier.addListener(_selectedItemsListener);
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialItem != oldWidget.initialItem &&
        selectedItemNotifier.value != widget.initialItem) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectedItemNotifier.value = widget.initialItem;
      });
    }

    if (widget.initialItems != oldWidget.initialItems &&
        selectedItemsNotifier.value != widget.initialItems) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectedItemsNotifier.value = widget.initialItems ?? <T>[];
      });
    }

    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      selectedItemNotifier = widget.controller!;
    }

    if (widget.multiSelectController != oldWidget.multiSelectController &&
        widget.multiSelectController != null) {
      selectedItemsNotifier = widget.multiSelectController ??
          MultiSelectController<T>(List<T>.from(widget.initialItems ?? <T>[]));
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      selectedItemNotifier.dispose();
    } else {
      selectedItemNotifier.removeListener(_selectedItemListener);
    }

    if (widget.multiSelectController == null) {
      selectedItemsNotifier.dispose();
    } else {
      selectedItemsNotifier.removeListener(_selectedItemsListener);
    }

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final CustomDropdownDecoration decoration =
        widget.decoration ??
        CustomDropdownDecoration(
          closedFillColor: Colors.white.withValues(alpha: 0.75),
          expandedFillColor: Colors.white,
          // listItemStyle: context.getStyle().bodySmall,
          // headerStyle: context.getStyle().bodySmall,
          // errorStyle: context.getStyle().bodySmall?.copyWith(
          //   color: context.getColor().error,
          // ),
          closedBorder: Border.all(
            // color: context.getColor().onSurface,
            width: 0.8,
          ),
          closedErrorBorder: Border.all(
            // color: context.getColor().error,
            width: 0.8,
          ),
        );
    final CustomDropdownDisabledDecoration disabledDecoration =
        widget.disabledDecoration ??
        CustomDropdownDisabledDecoration(
          border: Border.all(color: Colors.grey, width: 0.8),
          // headerStyle: context.getStyle().bodySmall,
        );
    final String safeHintText = widget.hintText ?? 'Select value';

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: FormField<(T?, List<T>)>(
        initialValue: (selectedItemNotifier.value, selectedItemsNotifier.value),
        validator: ((T?, List<T>)? val) {
          if (widget._dropdownType == _DropdownType.singleSelect &&
              widget.validator != null) {
            return widget.validator!(val?.$1);
          }
          if (widget._dropdownType == _DropdownType.multipleSelect &&
              widget.listValidator != null) {
            return widget.listValidator!(val?.$2 ?? <T>[]);
          }
          return null;
        },
        builder: (FormFieldState<(T?, List<T>)> formFieldState) {
          _formFieldState = formFieldState;
          return _OverlayBuilder(
            overlayPortalController: widget.overlayController,
            visibility: widget.visibility,
            overlay: (Size size, void Function() hideCallback) => _DropdownOverlay<T>(
                onItemSelect: (T value) {
                  switch (widget._dropdownType) {
                    case _DropdownType.singleSelect:
                      selectedItemNotifier.value = value;
                    case _DropdownType.multipleSelect:
                      // logger.debugLog('value', value);
                      if (value is NameId) {
                        // logger.debugLog('value.id', value.id);
                      }

                      final List<T> currentVal = List<T>.from(selectedItemsNotifier.value);

                      final int index = currentVal.indexWhere((T item) {
                        // Compare by ID if it's a NameId
                        if (item is NameId && value is NameId) {
                          return item.id == value.id;
                        }
                        // Fallback to default equality
                        return item == value;
                      });

                      if (index != -1) {
                        currentVal.removeAt(index);
                      } else {
                        currentVal.add(value);
                      }

                      selectedItemsNotifier.value = List<T>.from(currentVal); // Always assign new list

                  }
                },
                noResultFoundText:
                    widget.noResultFoundText ?? 'No result found.',
                noResultFoundBuilder: widget.noResultFoundBuilder,
                items: widget.items ?? <T>[],
                itemsScrollCtrl: widget.itemsScrollController,
                selectedItemNotifier: selectedItemNotifier,
                selectedItemsNotifier: selectedItemsNotifier,
                size: size,
                listItemBuilder: widget.listItemBuilder,
                layerLink: layerLink,
                hideOverlay: hideCallback,
                hintStyle: decoration.hintStyle,
                headerStyle: decoration.headerStyle,
                noResultFoundStyle: decoration.noResultFoundStyle,
                listItemStyle: decoration.listItemStyle,
                headerBuilder: widget.headerBuilder,
                headerListBuilder: widget.headerListBuilder,
                hintText: safeHintText,
                searchHintText: widget.searchHintText ?? 'Search',
                hintBuilder: widget.hintBuilder,
                decoration: decoration,
                overlayHeight: widget.overlayHeight,
                excludeSelected: widget.excludeSelected,
                canCloseOutsideBounds: widget.canCloseOutsideBounds,
                searchType: widget._searchType,
                futureRequest: widget.futureRequest,
                futureRequestDelay: widget.futureRequestDelay,
                hideSelectedFieldWhenOpen: widget.hideSelectedFieldWhenExpanded,
                maxLines: widget.maxLines,
                headerPadding: widget.expandedHeaderPadding,
                itemsListPadding: widget.itemsListPadding,
                listItemPadding: widget.listItemPadding,
                searchRequestLoadingIndicator:
                    widget.searchRequestLoadingIndicator,
                dropdownType: widget._dropdownType,
              ),
            child: (void Function() showCallback) => CompositedTransformTarget(
                link: layerLink,
                child: _DropDownField<T>(
                  formKey: widget.formKey,
                  validator: widget.validator,
                  onTap: showCallback,
                  selectedItemNotifier: selectedItemNotifier,
                  border: formFieldState.hasError
                      ? (decoration.closedErrorBorder ?? _defaultErrorBorder)
                      : enabled
                      ? decoration.closedBorder
                      : disabledDecoration.border,
                  borderRadius: formFieldState.hasError
                      ? decoration.closedErrorBorderRadius
                      : enabled
                      ? decoration.closedBorderRadius
                      : disabledDecoration.borderRadius,
                  shadow: enabled
                      ? decoration.closedShadow
                      : disabledDecoration.shadow,
                  hintStyle: enabled
                      ? decoration.hintStyle
                      : disabledDecoration.hintStyle,
                  headerStyle: enabled
                      ? decoration.headerStyle
                      : disabledDecoration.headerStyle,
                  hintText: safeHintText,
                  hintBuilder: widget.hintBuilder,
                  headerBuilder: widget.headerBuilder,
                  headerListBuilder: widget.headerListBuilder,
                  prefixIcon: enabled
                      ? decoration.prefixIcon
                      : disabledDecoration.prefixIcon,
                  suffixIcon: enabled
                      ? decoration.closedSuffixIcon
                      : disabledDecoration.suffixIcon,
                  fillColor: enabled
                      ? decoration.closedFillColor
                      : disabledDecoration.fillColor,
                  maxLines: widget.maxLines,
                  headerPadding: widget.closedHeaderPadding,
                  dropdownType: widget._dropdownType,
                  selectedItemsNotifier: selectedItemsNotifier,
                  enabled: widget.enabled,
                ),
              ),
          );
        },
      ),
    );
  }
}
