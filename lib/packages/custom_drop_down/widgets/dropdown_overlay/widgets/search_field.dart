part of '../../../custom_dropdown.dart';

class _SearchField<T> extends StatefulWidget {
  const _SearchField.forListData({
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.decoration,
    super.key,
  }) : searchType = _SearchType.onListData,
       futureRequest = null,
       futureRequestDelay = null,
       onFutureRequestLoading = null,
       mayFoundResult = null;

  const _SearchField.forRequestData({
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.onFutureRequestLoading,
    required this.mayFoundResult,
    required this.decoration,
    super.key,
  }) : searchType = _SearchType.onRequestData;
  final List<T> items;
  final ValueChanged<List<T>> onSearchedItems;
  final String searchHintText;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final ValueChanged<bool>? onFutureRequestLoading;
  final ValueChanged<bool>? mayFoundResult;
  final SearchFieldDecoration? decoration;

  @override
  State<_SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<_SearchField<T>> {
  final TextEditingController searchCtrl = TextEditingController();
  bool isFieldEmpty = false;
  FocusNode focusNode = FocusNode();
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.searchType == _SearchType.onRequestData &&
        widget.items.isEmpty) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  void onSearch(String query) {
    if(widget.items is List<NameId>){
      final List<T> result = widget.items.where((T item) {
        if (item is CustomDropdownListFilter) {
          return item.filter(query);
        } else {
          return (item as NameId).name.toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
      widget.onSearchedItems(result);
    }else{
      final List<T> result = widget.items.where((T item) {
        if (item is CustomDropdownListFilter) {
          return item.filter(query);
        } else {
          return item.toString().toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
      widget.onSearchedItems(result);
    }
  }

  void onClear() {
    if (searchCtrl.text.isNotEmpty) {
      searchCtrl.clear();
      widget.onSearchedItems(widget.items);
    }
  }

  Future<void> searchRequest(String val) async {
    List<T> result = <T>[];
    try {
      result = await widget.futureRequest!(val);
      widget.onFutureRequestLoading!(false);
    }on Object catch (_) {
      widget.onFutureRequestLoading!(false);
    }
    widget.onSearchedItems(isFieldEmpty ? widget.items : result);
    widget.mayFoundResult!(result.isNotEmpty);

    if (isFieldEmpty) {
      isFieldEmpty = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        focusNode: focusNode,
        style: widget.decoration?.textStyle,
        onChanged: (String val) async {
          if (val.isEmpty) {
            isFieldEmpty = true;
          } else if (isFieldEmpty) {
            isFieldEmpty = false;
          }

          if (widget.searchType != null &&
              widget.searchType == _SearchType.onRequestData &&
              val.isNotEmpty) {
            widget.onFutureRequestLoading!(true);

            if (widget.futureRequestDelay != null) {
              _delayTimer?.cancel();
              _delayTimer = Timer(
                widget.futureRequestDelay ?? Duration.zero,
                () {
                  unawaited(searchRequest(val));
                },
              );
            } else {
              unawaited(searchRequest(val));
            }
          } else if (widget.searchType == _SearchType.onListData) {
            onSearch(val);
          } else {
            widget.onSearchedItems(widget.items);
          }
        },
        controller: searchCtrl,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              widget.decoration?.fillColor ??
              SearchFieldDecoration._defaultFillColor,
          constraints:
              widget.decoration?.constraints ??
              const BoxConstraints.tightFor(height: 40),
          contentPadding:
              widget.decoration?.contentPadding ?? const EdgeInsets.all(8),
          hintText: widget.searchHintText,
          hintStyle: widget.decoration?.hintStyle,
          prefixIcon:
              widget.decoration?.prefixIcon ??
              const Icon(Icons.search, size: 22),
          suffixIcon:
              widget.decoration?.suffixIcon?.call(onClear) ??
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 20),
              ),
          border:
              widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: .25),
                ),
              ),
          enabledBorder:
              widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: .25),
                ),
              ),
          focusedBorder:
              widget.decoration?.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: .25),
                ),
              ),
        ),
      ),
    );
}
