part of '../custom_dropdown.dart';

// overlay icon
Icon _defaultOverlayIconDown = Icon(
  color: Colors.indigo[500],
  Icons.keyboard_arrow_down_rounded,
  size: 20,
);

class _DropDownField<T> extends StatefulWidget {

  const _DropDownField({
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxLines,
    required this.dropdownType,
    required this.selectedItemsNotifier,
    super.key,
    this.hintText = 'Select value',
    this.fillColor,
    this.border,
    this.borderRadius,
    this.hintStyle,
    this.headerStyle,
    this.headerBuilder,
    this.shadow,
    this.headerListBuilder,
    this.hintBuilder,
    this.prefixIcon,
    this.suffixIcon,
    this.headerPadding,
    this.validator,
    this.formKey,
    this.enabled = true,
  });
  final VoidCallback onTap;
  final SingleSelectController<T?> selectedItemNotifier;
  final String hintText;
  final Color? fillColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final TextStyle? headerStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<BoxShadow>? shadow;
  final EdgeInsets? headerPadding;
  final int maxLines;
  final HeaderBuilder<T>? headerBuilder;
  final HeaderListBuilder<T>? headerListBuilder;
  final HintBuilder? hintBuilder;
  final _DropdownType dropdownType;
  final bool enabled;
  final MultiSelectController<T> selectedItemsNotifier;

  final String? Function(T?)? validator;
  final GlobalKey? formKey;

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  T? selectedItem;
  late List<T> selectedItems;
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;
  }

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  Widget hintBuilder(BuildContext context) => const SizedBox();

  Widget headerBuilder(BuildContext context) => widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T,enabled: widget.enabled)
        : defaultHeaderBuilder(oneItem: selectedItem);

  Widget headerListBuilder(BuildContext context) => widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems,enabled: widget.enabled)
        : defaultHeaderBuilder(itemList: selectedItems);

  Widget defaultHeaderBuilder({T? oneItem, List<T>? itemList}) => Text(
      itemList != null ? itemList.join(', ') : oneItem.toString(),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      style:
          widget.headerStyle ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.enabled ? null : Colors.black.withValues(alpha: .5),
          ),
    );

  Widget defaultHintBuilder(String hint, {bool enabled=false}) => Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          widget.hintStyle ??
          const TextStyle(fontSize: 16, color: Color(0xFFA7A7A7)),
    );

  @override
  void didUpdateWidget(covariant _DropDownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    switch (widget.dropdownType) {
      case _DropdownType.singleSelect:
        selectedItem = widget.selectedItemNotifier.value;
      case _DropdownType.multipleSelect:
        selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(10);
    final Color primaryColor = Colors.purple;
    final Color normalColor = Colors.grey;
    final Color errorColor = Colors.red;
    return FormField<T?>(
      key: widget.formKey,
      validator: (T? value) => widget.validator?.call(selectedItem),
      builder: (FormFieldState<dynamic> field) => MouseRegion(
          onEnter: (_) => _isHovered.value = true,
          onExit: (_) => _isHovered.value = false,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isHovered,
            builder: (BuildContext context, bool value, Widget? child) => GestureDetector(
                onTap: widget.onTap,
                child: InputDecorator(
                  isEmpty: widget.dropdownType == _DropdownType.singleSelect
                      ? selectedItem == null
                      : selectedItems.isEmpty,
                  decoration: InputDecoration(
                    floatingLabelBehavior: selectedItem != null
                        ? FloatingLabelBehavior.always
                        : FloatingLabelBehavior.never,
                    labelText: widget.hintText,
                    // labelStyle: context.getStyle().labelMedium,
                    // hintStyle: context.getStyle().labelSmall,

                    contentPadding:
                        widget.headerPadding ?? _defaultHeaderPadding,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: normalColor,
                        width: value ? 1.5 : 0.8,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: errorColor,
                        width: value ? 1.5 : 0.8,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    errorText: field.errorText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon:
                        widget.suffixIcon ??
                        (widget.enabled
                            ? _defaultOverlayIconDown
                            : Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.indigo[500],
                                size: 20,
                              )),
                  ),
                  child: GestureDetector(
                    // onTap: widget.enabled ? _handleDropdownTap : null,
                    child: switch (widget.dropdownType) {
                      _DropdownType.singleSelect =>
                        selectedItem != null
                            ? headerBuilder(context)
                            : hintBuilder(context),
                      _DropdownType.multipleSelect =>
                        selectedItems.isNotEmpty
                            ? headerListBuilder(context)
                            : hintBuilder(context),
                    },
                  ),
                ),
              ),
          ),
        ),
    );
  }
}
