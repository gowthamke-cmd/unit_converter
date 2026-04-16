part of '../../custom_dropdown.dart';

Icon _defaultOverlayIconUp = Icon(
  color: Colors.indigo[500],
  Icons.keyboard_arrow_up_rounded,
  size: 20,
);

const EdgeInsets _defaultHeaderPadding = EdgeInsets.all(16);
const EdgeInsetsDirectional _overlayOuterPadding = EdgeInsetsDirectional.only(
  bottom: 12,
  start: 12,
  end: 12,
);
const Offset _defaultOverlayShadowOffset = Offset(0, 6);
const EdgeInsets _defaultListItemPadding = EdgeInsets.symmetric(
  vertical: 12,
  horizontal: 16,
);

class _DropdownOverlay<T> extends StatefulWidget {
  const _DropdownOverlay({
    required this.items,
    required this.itemsScrollCtrl,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    required this.searchHintText,
    required this.selectedItemNotifier,
    required this.selectedItemsNotifier,
    required this.excludeSelected,
    required this.onItemSelect,
    required this.noResultFoundText,
    required this.canCloseOutsideBounds,
    required this.maxLines,
    required this.overlayHeight,
    required this.dropdownType,
    required this.decoration,
    required this.hintStyle,
    required this.headerStyle,
    required this.listItemStyle,
    required this.noResultFoundStyle,
    required this.hideSelectedFieldWhenOpen,
    required this.searchRequestLoadingIndicator,
    required this.headerPadding,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.headerBuilder,
    required this.hintBuilder,
    required this.searchType,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.listItemBuilder,
    required this.headerListBuilder,
    required this.noResultFoundBuilder,
  });
  final List<T> items;
  final ScrollController? itemsScrollCtrl;
  final SingleSelectController<T?> selectedItemNotifier;
  final MultiSelectController<T> selectedItemsNotifier;
  final Function(T) onItemSelect;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText;
  final String searchHintText;
  final String noResultFoundText;
  final bool excludeSelected;
  final bool hideSelectedFieldWhenOpen;
  final bool canCloseOutsideBounds;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final int maxLines;
  final double? overlayHeight;
  final TextStyle? hintStyle;
  final TextStyle? headerStyle;
  final TextStyle? noResultFoundStyle;
  final TextStyle? listItemStyle;
  final EdgeInsets? headerPadding;
  final EdgeInsets? listItemPadding;
  final EdgeInsets? itemsListPadding;
  final Widget? searchRequestLoadingIndicator;
  final ListItemBuilder<T>? listItemBuilder;
  final HeaderBuilder<T>? headerBuilder;
  final HeaderListBuilder<T>? headerListBuilder;
  final HintBuilder? hintBuilder;
  final NoResultFoundBuilder? noResultFoundBuilder;
  final CustomDropdownDecoration? decoration;
  final _DropdownType dropdownType;

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;
  late List<T> items;
  late T? selectedItem;
  late List<T> selectedItems;
  late ScrollController scrollController;
  final GlobalKey<State<StatefulWidget>> key1 = GlobalKey();
  final GlobalKey<State<StatefulWidget>> key2 = GlobalKey();

  Widget hintBuilder(BuildContext context) => widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText,enabled: true)
        : defaultHintBuilder(context, widget.hintText);

  Widget headerBuilder(BuildContext context) => widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T,enabled: true)
        : defaultHeaderBuilder(context, item: selectedItem);

  Widget headerListBuilder(BuildContext context) => widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems,enabled: true)
        : defaultHeaderBuilder(context, items: selectedItems);

  Widget noResultFoundBuilder(BuildContext context) => widget.noResultFoundBuilder != null
        ? widget.noResultFoundBuilder!(context, widget.noResultFoundText)
        : defaultNoResultFoundBuilder(context, widget.noResultFoundText);

  Widget defaultListItemBuilder(
    BuildContext context,
    T result,
    VoidCallback onItemSelect,
    {required bool isSelected}
  ) => Row(
      children: <Widget>[
        Expanded(
          child: Text(
            result.toString(),
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: widget.listItemStyle ?? const TextStyle(fontSize: 16),
          ),
        ),
        if (widget.dropdownType == _DropdownType.multipleSelect)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Checkbox(
              onChanged: (_) => onItemSelect(),
              value: isSelected,
              activeColor:
                  widget.decoration?.listItemDecoration?.selectedIconColor,
              side: widget.decoration?.listItemDecoration?.selectedIconBorder,
              shape: widget.decoration?.listItemDecoration?.selectedIconShape,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
          ),
      ],
    );

  Widget defaultHeaderBuilder(BuildContext context, {T? item, List<T>? items}) => Text(
      items != null ? items.join(', ') : item.toString(),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      style:
          widget.headerStyle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );

  Widget defaultHintBuilder(BuildContext context, String hint) => Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          widget.hintStyle ??
          const TextStyle(fontSize: 16, color: Color(0xFFA7A7A7)),
    );

  Widget defaultNoResultFoundBuilder(BuildContext context, String text) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: widget.noResultFoundStyle ?? const TextStyle(fontSize: 16),
        ),
      ),
    );

  @override
  void initState() {
    super.initState();
    scrollController = widget.itemsScrollCtrl ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderObject? renderObject1 = key1.currentContext?.findRenderObject();
      final RenderObject? renderObject2 = key2.currentContext?.findRenderObject();
      if (renderObject1 is RenderBox && renderObject2 is RenderBox) {
        final RenderBox render1 =
            renderObject1;
        final RenderBox render2 =
            renderObject2;
        final double screenHeight = MediaQuery.of(context).size.height;
        double y = render1.localToGlobal(Offset.zero).dy;
        if (screenHeight - y < render2.size.height) {
          displayOverlayBottom = false;
          setState(() {});
        }
      }
    });

    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;

    widget.selectedItemNotifier.addListener(singleSelectListener);
    widget.selectedItemsNotifier.addListener(multiSelectListener);

    if (widget.excludeSelected &&
        widget.items.length > 1 &&
        selectedItem != null) {
      T value = selectedItem as T;
      items = widget.items.where((T item) => item != value).toList();
    } else {
      items = widget.items;
    }
  }

  @override
  void dispose() {
    widget.selectedItemNotifier.removeListener(singleSelectListener);
    widget.selectedItemsNotifier.removeListener(multiSelectListener);

    if (widget.itemsScrollCtrl == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  void singleSelectListener() {
    if (mounted) {
      selectedItem = widget.selectedItemNotifier.value;
    }
  }

  void multiSelectListener() {
    if (mounted) {
      selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  void onItemSelect(T value) {
    widget.onItemSelect(value);
    if (widget.dropdownType == _DropdownType.singleSelect) {
      setState(() => displayOverly = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // decoration
    final CustomDropdownDecoration? decoration = widget.decoration;

    // search availability check
    final bool onSearch = widget.searchType != null;

    // overlay offset
    final Offset overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 64);

    // list padding
    final EdgeInsets listPadding = onSearch
        ? const EdgeInsets.only(top: 8)
        : EdgeInsets.zero;

    // items list
    final Widget list = items.isNotEmpty
        ? _ItemsList<T>(
            scrollController: scrollController,
            listItemBuilder:(BuildContext context,T value,void Function() fun,{required bool isSelected}) =>
            widget.listItemBuilder?.call(context,value,isSelected: isSelected,fun) ?? defaultListItemBuilder(context,value,isSelected: isSelected,fun),
            excludeSelected: items.length > 1 && widget.excludeSelected,
            selectedItem: selectedItem,
            selectedItems: selectedItems,
            items: items,
            itemsListPadding: widget.itemsListPadding ?? listPadding,
            listItemPadding: widget.listItemPadding ?? _defaultListItemPadding,
            onItemSelect: onItemSelect,
            decoration: decoration?.listItemDecoration,
            dropdownType: widget.dropdownType,
          )
        : (mayFoundSearchRequestResult != null &&
                  !mayFoundSearchRequestResult!) ||
              widget.searchType == _SearchType.onListData
        ? noResultFoundBuilder(context)
        : const SizedBox(height: 12);

    final Stack child = Stack(
      children: <Widget>[
        Positioned(
          width: widget.size.width + 24,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            followerAnchor: displayOverlayBottom
                ? Alignment.topLeft
                : Alignment.bottomLeft,
            showWhenUnlinked: false,
            offset: overlayOffset,
            child: Container(
              key: key1,
              margin: _overlayOuterPadding,
              decoration: BoxDecoration(
                color:
                    decoration?.expandedFillColor ??
                    CustomDropdownDecoration._defaultFillColor,
                border: decoration?.expandedBorder,
                borderRadius:
                    decoration?.expandedBorderRadius ?? _defaultBorderRadius,
                boxShadow:
                    decoration?.expandedShadow ??
                    <BoxShadow>[
                      BoxShadow(
                        blurRadius: 24,
                        color: Colors.black.withValues(alpha: .08),
                        offset: _defaultOverlayShadowOffset,
                      ),
                    ],
              ),
              child: Material(
                color: Colors.transparent,
                child: _AnimatedSection(
                  animationDismissed: widget.hideOverlay,
                  expand: displayOverly,
                  axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                  child: SizedBox(
                    key: key2,
                    height: items.length > 4
                        ? widget.overlayHeight ?? (onSearch ? 270 : 225)
                        : null,
                    child: ClipRRect(
                      borderRadius:
                          decoration?.expandedBorderRadius ??
                          _defaultBorderRadius,
                      child: NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification notification) {
                              notification.disallowIndicator();
                              return true;
                            },
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            scrollbarTheme:
                                decoration?.overlayScrollbarDecoration ??
                                ScrollbarThemeData(
                                  thumbVisibility: WidgetStateProperty.all(
                                    true,
                                  ),
                                  thickness: WidgetStateProperty.all(5),
                                  radius: const Radius.circular(4),
                                  thumbColor: WidgetStateProperty.all(
                                    Colors.grey[300],
                                  ),
                                ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (!widget.hideSelectedFieldWhenOpen)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() => displayOverly = false);
                                  },
                                  child: Padding(
                                    padding:
                                        widget.headerPadding ??
                                        _defaultHeaderPadding,
                                    child: Row(
                                      children: <Widget>[
                                        if (widget.decoration?.prefixIcon !=
                                            null) ...<Widget>[
                                          widget.decoration!.prefixIcon!,
                                          const SizedBox(width: 12),
                                        ],
                                        Expanded(
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
                                        const SizedBox(width: 12),
                                        decoration?.expandedSuffixIcon ??
                                            _defaultOverlayIconUp,
                                      ],
                                    ),
                                  ),
                                ),
                              if (onSearch &&
                                  widget.searchType == _SearchType.onListData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forListData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onSearchedItems: (List<T> val) {
                                      setState(() => items = val);
                                    },
                                    decoration:
                                        decoration?.searchFieldDecoration ??
                                        _defaultFieldDecoration(),
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12,
                                        start: 8,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...<Widget>[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: _SearchField<T>.forListData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onSearchedItems: (List<T> val) {
                                                setState(() => items = val);
                                              },
                                              decoration:
                                                  decoration
                                                      ?.searchFieldDecoration ??
                                                  _defaultFieldDecoration(),
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  )
                              else if (onSearch &&
                                  widget.searchType ==
                                      _SearchType.onRequestData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forRequestData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onFutureRequestLoading: (bool val) {
                                      setState(() {
                                        isSearchRequestLoading = val;
                                      });
                                    },
                                    futureRequest: widget.futureRequest,
                                    futureRequestDelay:
                                        widget.futureRequestDelay,
                                    onSearchedItems: (List<T> val) {
                                      setState(() => items = val);
                                    },
                                    mayFoundResult: (bool val) =>
                                        mayFoundSearchRequestResult = val,
                                    decoration:
                                        decoration?.searchFieldDecoration ??
                                        _defaultFieldDecoration(),
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12,
                                        start: 8,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...<Widget>[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: _SearchField<T>.forRequestData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onFutureRequestLoading:
                                                  (bool val) {
                                                    setState(() {
                                                      isSearchRequestLoading =
                                                          val;
                                                    });
                                                  },
                                              futureRequest:
                                                  widget.futureRequest,
                                              futureRequestDelay:
                                                  widget.futureRequestDelay,
                                              onSearchedItems: (List<T> val) {
                                                setState(() => items = val);
                                              },
                                              mayFoundResult: (bool val) =>
                                                  mayFoundSearchRequestResult =
                                                      val,
                                              decoration:
                                                  decoration
                                                      ?.searchFieldDecoration ??
                                                  _defaultFieldDecoration(),
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  ),
                              if (isSearchRequestLoading)
                                widget.searchRequestLoadingIndicator ??
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                    )
                              else
                                items.length > 4 ? Expanded(child: list) : list,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.canCloseOutsideBounds) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => setState(() => displayOverly = false),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          child,
        ],
      );
    }

    return child;
  }

  SearchFieldDecoration _defaultFieldDecoration() {
    final BorderRadius borderRadius = BorderRadius.circular(10);
    // final Color _ = context.getColor().primary;
    final Color normalColor = Colors.grey;
    return SearchFieldDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: normalColor, width: 0.8),
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: normalColor, width: 0.8),
      ),
      fillColor: Colors.transparent,
      // hintStyle: context.getStyle().labelSmall,
      // textStyle: context.getStyle().labelMedium,
    );
  }
}
